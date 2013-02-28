Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3B1X2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:28:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:1351 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3B1X2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:28:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,757,1355126400"; 
   d="scan'208";a="262864875"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: RE: [GIT PULL] x86/microcode for v3.9-rc1
Thread-Topic: [GIT PULL] x86/microcode for v3.9-rc1
Thread-Index: AQHOELkHDmkvCmd5tUaA2VfA77GJ6JiQd9cAgAAB6QD//3o0QA==
Date: Thu, 28 Feb 2013 23:28:06 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220528AAA95@ORSMSX105.amr.corp.intel.com>
References: <201302220456.r1M4ua12006362@terminus.zytor.com>
 <20130228231608.GA17468@pd.tnic> <512FE6D2.7070704@zytor.com>
In-Reply-To: <512FE6D2.7070704@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1SNSEcI017339



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Thursday, February 28, 2013 3:23 PM
> To: Borislav Petkov; H. Peter Anvin; Linus Torvalds; Yu, Fenghua; Ingo
> Molnar; Linux Kernel Mailing List; Thomas Gleixner; Yinghai Lu
> Subject: Re: [GIT PULL] x86/microcode for v3.9-rc1
> 
> On 02/28/2013 03:16 PM, Borislav Petkov wrote:
> >
> > Some strange build warnings I get here:
> >
> > arch/x86/kernel/microcode_intel_early.c: In function
> `get_matching_model_microcode.isra.3.constprop.9':
> > arch/x86/kernel/microcode_intel_early.c:366:1: warning: the frame
> size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > arch/x86/kernel/microcode_intel_early.c: In function
> `save_mc_for_early':
> > arch/x86/kernel/microcode_intel_early.c:550:1: warning: the frame
> size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> >
> > What's up?
> >
> 
> gcc is warning that the function is using lots of stack.  In the
> context
> that it is running in this is most likely not a problem given how small
> the overrun is, but it might be worthwhile to see if there is anything
> which can be moved out to static storage or some other variant.
> 
> Static storage is tricky to use in this context since it runs in flat
> linear mode (without paging, and therefore without the +3 GB offset) on
> 32 bits.
> 
> 	-hpa

The errors might be related to the arrays defined mc_saved_tmp[MAX_UCODE_COUNT].

Could you send your .config to me so that I can reproduce the issue? I don't see the issue in my build environment and in Fengguang's test environment.

Thanks.

-Fenghua

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
