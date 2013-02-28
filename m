Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3B1XYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:24:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42598 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3B1XYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:24:36 -0500
Message-ID: <512FE6D2.7070704@zytor.com>
Date: Thu, 28 Feb 2013 15:22:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL] x86/microcode for v3.9-rc1
References: <201302220456.r1M4ua12006362@terminus.zytor.com> <20130228231608.GA17468@pd.tnic>
In-Reply-To: <20130228231608.GA17468@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 03:16 PM, Borislav Petkov wrote:
> 
> Some strange build warnings I get here:
> 
> arch/x86/kernel/microcode_intel_early.c: In function `get_matching_model_microcode.isra.3.constprop.9':
> arch/x86/kernel/microcode_intel_early.c:366:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> arch/x86/kernel/microcode_intel_early.c: In function `save_mc_for_early':
> arch/x86/kernel/microcode_intel_early.c:550:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> What's up?
> 

gcc is warning that the function is using lots of stack.  In the context
that it is running in this is most likely not a problem given how small
the overrun is, but it might be worthwhile to see if there is anything
which can be moved out to static storage or some other variant.

Static storage is tricky to use in this context since it runs in flat
linear mode (without paging, and therefore without the +3 GB offset) on
32 bits.

	-hpa

