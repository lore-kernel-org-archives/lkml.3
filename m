Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3B1Xwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:52:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42424 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3B1Xws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:52:48 -0500
Date: Fri, 1 Mar 2013 00:52:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL] x86/microcode for v3.9-rc1
Message-ID: <20130228235238.GF9767@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yinghai Lu <yinghai@kernel.org>
References: <201302220456.r1M4ua12006362@terminus.zytor.com>
 <20130228231608.GA17468@pd.tnic>
 <512FE6D2.7070704@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C71220528AAA95@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220528AAA95@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:28:06PM +0000, Yu, Fenghua wrote:
>> gcc is warning that the function is using lots of stack. In the
>> context that it is running in this is most likely not a problem
>> given how small the overrun is, but it might be worthwhile to see if
>> there is anything which can be moved out to static storage or some
>> other variant.
>>
>> Static storage is tricky to use in this context since it runs in
>> flat linear mode (without paging, and therefore without the +3 GB
>> offset) on 32 bits.
>
> The errors might be related to the arrays defined
> mc_saved_tmp[MAX_UCODE_COUNT].
>
> Could you send your .config to me so that I can reproduce the issue?
> I don't see the issue in my build environment and in Fengguang's test
> environment.

Ok, forget it. It was some local .config file corruption which caused
include/generated/autoconf.h and include/config/auto.conf to have a line

CONFIG_FRAME_WARN=1024

which would cause the warnings.

The 1024 ceiling value is also consistent with the warnings complaining
about something being > 1024 bytes.

Default CONFIG_FRAME_WARN on x86_64 is 2048 which explains why those
warnings never trigger on 64-bit.

So, we all can relax ourselves, especially I :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
