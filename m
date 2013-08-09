Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968260Ab3HISiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:38:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:34186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968150Ab3HISiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:38:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,847,1367996400"; 
   d="scan'208";a="360348102"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Thread-Topic: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Thread-Index: AQHOiHJi+cm++MPa80WiAzcLiv5LH5mKbKhAgAANp+CAAalMAIABKXMQ
Date: Fri, 9 Aug 2013 18:38:10 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A53C01E@ORSMSX106.amr.corp.intel.com>
References: <20130723230026.394a5ee1@googlemail.com>
 <20130724133254.GE30777@pd.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C712205A53B73A@ORSMSX106.amr.corp.intel.com>
 <20130808174906.GC27974@pd.tnic>
In-Reply-To: <20130808174906.GC27974@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79IcRwe011986

> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Thursday, August 08, 2013 10:49 AM
> On Wed, Aug 07, 2013 at 11:34:01PM +0000, Yu, Fenghua wrote:
> > > This check won't work when CPU0 is hot added. So we need to find a
> > > better way to fix this.
> > >
> >
> > Maybe need to change the check as follows to take care of CPU0 hot
> add case?
> >
> > if ((cpu && system_state == SYSTEM_BOOTING) || (system_state ==
> SYSTEM_RUNNING))
> > 	load_ucode_ap();
> 
> Ok, just for my own understanding - I haven't played with cpu hotadd
> yet
> so when you do this, is the hot-added socket containing the BSP not cpu
> 0 anymore?
> 
> Or when you hot-remove the socket containing the BSP, another AP
> becomes
> the BSP and preserves its old number?

When BSP is logically hot removed/offlined, there is no BSP any more in Linux, i.e. cpu0 is not in online mask. CPU0 can be logically hot added back again.

Currently kernel doesn't support physically hot remove CPU0 yet.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
