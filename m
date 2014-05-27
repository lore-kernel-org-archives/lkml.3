Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaE0WdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:33:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:21870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaE0WdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:33:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,923,1392192000"; 
   d="scan'208";a="518656576"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH] x86, MCE: Flesh out when to panic comment
Thread-Topic: [PATCH] x86, MCE: Flesh out when to panic comment
Thread-Index: AQHPeMv4f2OJPRjwKESY7TWOSfRq25tTJI8AgAAETgCAAdE5YIAAfmYA//+Mm0A=
Date: Tue, 27 May 2014 22:33:15 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3281EFC9@ORSMSX114.amr.corp.intel.com>
References: <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic> <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic> <537D2522.80702@zytor.com>
 <20140526101859.GD25732@pd.tnic>
 <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
 <20140526110634.GG25732@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3281EEA5@ORSMSX114.amr.corp.intel.com>
 <20140527222404.GE4366@pd.tnic>
In-Reply-To: <20140527222404.GE4366@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4RMXRIN026717

> And this tolerant check looks fishy to me:
>
>                if (s->sev >= MCE_UC_SEVERITY && ctx == IN_KERNEL) {
>                        if (panic_on_oops || tolerant < 1)
>                                return MCE_PANIC_SEVERITY;
>                }
>
> since we set it to 1 by default. But I'll look again on a clear head
> tomorrow - it is too late here.

tolerant level 0 exists - but is somewhat crazy in the opposite direction
from the large values.  Look at the comment in mce.c ... level 0
means always panic if you see a UC error

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
