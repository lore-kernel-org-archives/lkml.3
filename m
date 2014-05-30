Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbaE3XDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:03:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:63907 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaE3XD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:03:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,944,1392192000"; 
   d="scan'208";a="540266048"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Chen, Gong" <gong.chen@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Thread-Topic: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Thread-Index: AQHPeilSOyJTIZwXt0erLrK7gz6USJtWk/0AgAASiACAAAYGgIACpdkAgAAMgACAAGDh4A==
Date: Fri, 30 May 2014 23:03:27 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
 <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
 <20140530092232.GA13495@gchen.bj.intel.com> <20140530100716.GE28131@pd.tnic>
In-Reply-To: <20140530100716.GE28131@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4UN3fnU020091

>> For memory error location, I will utilize type offset to save one
>> more byte, furthermore, I want to drop requestor_id, responder_id
>> and target_id. 1) They are very rare (I've never seen them by now)
>
> My concern is, are we sure we're never going to need them at all? Tony,
> what's your take on this?

They may seem rare because our BIOS doesn't bother to provide them.
Other BIOS writers may be more diligent.

I flip-flop on the issue of how much detail to log.  For the majority
of users it is enough to just point at the DIMM.  That's the thing that
they can easily replace.

But OEMs and large scale users often want to know every tiny detail
so they can look for patterns between errors reported across a large
fleet. So I hate to drop information on the floor that might be useful
to someone later.

All of this stuff only applies to server systems - so quibbling over
a handful of *bytes* in an error record on a system that has tens,
hundreds or even thousands of *gigabytes* of memory seems
a bit pointless.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
