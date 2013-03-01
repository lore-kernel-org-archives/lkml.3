Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3CAAJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:09:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:9759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3CAAJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:09:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="scan'208";a="292064538"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: RE: [GIT PULL] x86/microcode for v3.9-rc1
Thread-Topic: [GIT PULL] x86/microcode for v3.9-rc1
Thread-Index: AQHOELkHDmkvCmd5tUaA2VfA77GJ6JiQd9cAgAAB6QD//3o0QIAAjhYA//990SA=
Date: Fri, 1 Mar 2013 00:09:27 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220528AAADB@ORSMSX105.amr.corp.intel.com>
References: <201302220456.r1M4ua12006362@terminus.zytor.com>
 <20130228231608.GA17468@pd.tnic> <512FE6D2.7070704@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C71220528AAA95@ORSMSX105.amr.corp.intel.com>
 <20130228235238.GF9767@pd.tnic>
In-Reply-To: <20130228235238.GF9767@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2109TeM017517

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Thursday, February 28, 2013 3:53 PM
> To: Yu, Fenghua; H. Peter Anvin
> Cc: H. Peter Anvin; Linus Torvalds; Ingo Molnar; Linux Kernel Mailing
> List; Thomas Gleixner; Yinghai Lu
> Subject: Re: [GIT PULL] x86/microcode for v3.9-rc1
> 
> On Thu, Feb 28, 2013 at 11:28:06PM +0000, Yu, Fenghua wrote:
> >> gcc is warning that the function is using lots of stack. In the
> >> context that it is running in this is most likely not a problem
> >> given how small the overrun is, but it might be worthwhile to see if
> >> there is anything which can be moved out to static storage or some
> >> other variant.
> >>
> >> Static storage is tricky to use in this context since it runs in
> >> flat linear mode (without paging, and therefore without the +3 GB
> >> offset) on 32 bits.
> >
> > The errors might be related to the arrays defined
> > mc_saved_tmp[MAX_UCODE_COUNT].
> >
> > Could you send your .config to me so that I can reproduce the issue?
> > I don't see the issue in my build environment and in Fengguang's test
> > environment.
> 
> Ok, forget it. It was some local .config file corruption which caused
> include/generated/autoconf.h and include/config/auto.conf to have a
> line
> 
> CONFIG_FRAME_WARN=1024
> 
> which would cause the warnings.
> 
> The 1024 ceiling value is also consistent with the warnings complaining
> about something being > 1024 bytes.
> 
> Default CONFIG_FRAME_WARN on x86_64 is 2048 which explains why those
> warnings never trigger on 64-bit.
> 
> So, we all can relax ourselves, especially I :-)
> 
> Thanks.
> 
> --
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --

Ok. Agree, 1024 is too small. Nice to know that:)

Merci.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
