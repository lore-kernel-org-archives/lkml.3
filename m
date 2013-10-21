Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JUN7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:59:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49976 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab3JUN7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:59:19 -0400
Date: Mon, 21 Oct 2013 15:59:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
Message-ID: <20131021135917.GA6117@nazgul.tnic>
References: <526325C9.7030705@gmail.com>
 <20131020091813.GA4972@pd.tnic>
 <52646E0E.6040204@gmail.com>
 <20131021105401.GA5019@nazgul.tnic>
 <526513B5.5050203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <526513B5.5050203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 07:44:53AM -0400, Austin S Hemmelgarn wrote:
> Specifically, boot time was reduced by approximately half a second
> (measured as time from starting init till having a usable graphical
> login),

How did you measure that? Kernel printk timestamps? I keep repeating
this and you simply don't state your benchmarking methods clearly
enough, for some reason: I need a detailed explanation about how exactly
you're doing your measurements so that I or anyone else for that matter,
can repeat them.

> and the system ran approximately 1 degree cooler under heavy
> load (namely a full GCC+binutils bootstrap with one job per virtual
> CPU core).

Ditto.

> Using lm_sensors with CONFIG_FAM15H_POWER enabled, simply run the
> command `sensors` a couple of times on an idle system as root comparing
> the values between having CONFIG_MPILEDRIVER=y and CONFIG_GENERIC_CPU=y.
> For this specific case I recorded the wattage values at one minute

That's too coarse-grained since the sensors output will give your
momentary power consumption. But I see what you do here and I'll run a
modified, more finer-granulary test of yours on my machine too to check.

> Something else to keep in mind, the effects of -mtune=generic change
> over time, as these processors become less common, the optimizations

Which processors?

> done by -mtune=generic will shift away from them. The reason that many
> of the equivalent options in the kernel currently provide as much
> benefit as they do is that gcc no longer tries to create machine code
> that is tuned for them unless you tell it to.

This doesn't really make much sense because the single biggest build
target is distros with a single system image which is supposed to run as
optimally as possible on any x86 hardware.

So specialized builds are only for Gentoo users and others who build
customized kernels. And those who can do that, can also apply this patch
to their own tree.
