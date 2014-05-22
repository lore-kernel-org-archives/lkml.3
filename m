Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaEVPvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:51:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:3018 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaEVPvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:51:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,887,1392192000"; 
   d="scan'208";a="435599008"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: RE: [PATCH] x86, MCE: Kill CPU_POST_DEAD
Thread-Topic: [PATCH] x86, MCE: Kill CPU_POST_DEAD
Thread-Index: AQHPddLE0hRWVs+cdkuAQt4Gebmk35tMvgMg
Date: Thu, 22 May 2014 15:50:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328133C0@ORSMSX114.amr.corp.intel.com>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com> <20140522100820.GE4383@pd.tnic>
 <537DE579.6000505@linux.vnet.ibm.com>
 <20140522123251.GU30445@twins.programming.kicks-ass.net>
 <20140522153006.GK4383@pd.tnic>
In-Reply-To: <20140522153006.GK4383@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4MFpNEi027867

>> So I think we can reduce it to just the one rwsem (with recursion) if we
>> shoot CPU_POST_DEAD in the head.
>
> Here's the first bullet. Stressing my box here with Steve's hotplug
> script seems to work fine.
>
> Tony, any objections?

what was this comment referring to:

    /* intentionally ignoring frozen here */

After you move the cmci_rediscover() call, it is now in a place where we are
no longer ignoring frozen (i.e. the old placement did the rediscover even if the
CPU_TASKS_FROZEN bit was set - with the new placement we will skip rediscovery.

So we were working around some interaction between cpu hotplug and frozen.
Do we no longer need to do that?

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
