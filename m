Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbbAHKj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:39:29 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51981 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753018AbbAHKj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:39:28 -0500
Date: Thu, 8 Jan 2015 10:39:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150108103911.GQ12302@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
 <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
 <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk>
 <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:14:07PM +0000, Catalin Marinas wrote:
> On 7 January 2015 at 20:53, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Now, if I understand Linus correctly, what irks him is when someone
> > upgrades a kernel on a platform, and some userland breaks.  That's
> > something which I've said multiple times I don't have a problem
> > agreeing with, and I suspect no one in this thread would disagree
> > that this is a serious failing, and one which needs fixing ASAP.
> 
> Agree. But I assume you refer to the fact that we removed the BogoMIPS
> reporting. It's fine to have it reverted.
> 
> > However, if running userland on platform A works, and but it doesn't
> > work on platform B.  The breakage may well be due to platform A reporting
> > 300 bogomips because it's using the kernel software loop, and platform
> > B reporting 6 bogomips because its using a hardware timer, but the CPU
> > is actually faster.  However, this is not a kernel problem, and it
> > certainly is not a regression.  It's a userspace bug which needs
> > userspace to fix.
> 
> We need to look back at the point we added timer-based delay about 2.5
> years ago. Prior to commit d0a533b18235d362, platform A reported
> bogomips 300. After that commit, the *same* platform A (not B),
> started reported 6.

Correct.

> Is the above considered user breakage? That's what Nico is trying to
> solve. If we are fine with it, than we can close this thread, no
> further changes needed.

It's not a regression - yet.  No one has shown that userspace has broken
according to the definition of the first quote above, and that's the
whole point.

> We can document it as Linus suggests and say that prior to whatever
> version we had 2.5 years ago, BogoMIPS was based on a busy loop. In
> more recent kernels, it is based on a timer delay. User space should
> make use of such information when interpreting BogoMIPS.

We don't need to document it - we just need to point people at this
URL:

http://en.wikipedia.org/wiki/BogoMips

which already describes it fully, including the existing ARM timer
behaviour.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
