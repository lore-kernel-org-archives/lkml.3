Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3DTSl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 14:41:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40254 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3DTSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 14:41:57 -0400
Date: Sat, 20 Apr 2013 20:41:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>, Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume does not work after timekeeping change
Message-ID: <20130420184152.GA4649@pd.tnic>
References: <5172B86C.5030606@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5172B86C.5030606@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 05:46:52PM +0200, Jiri Slaby wrote:
> Hi,
> 
> my machine does not wake from suspend to RAM on my box running the -next
> kernel. The last thing I see is "Disabling non-boot CPUs ...". I
> bisected it to this commit:
> 
> commit 7ec98e15aa049b7a2ca73485f31cf4f90c34e2dd
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Feb 21 22:51:39 2013 +0000
> 
>     timekeeping: Delay update of clock->cycle_last
> 
> 
> Reverting that one on the top of -next-20130419 makes it work again.
> 
> 
> I also tried it inside a VM using suspend to disk. There, it behaves
> like it takes a minute or so to wake up. So I tried to wait on the real
> HW too, but it never resumes there.

Right, and I'm seeing it here too but it sometimes does resume after
about a minute or so and sometimes it doesn't.

Reverting the patch by hand ontop of tip/master fixes the issue here
too.

Btw, Ingo, remember how I was telling you that I'm seeing
temporary lockups with tip/master and resume issues
with the last line being "Disabling non-boot CPUs ..."
http://marc.info/?l=linux-kernel&m=136610574502492 - this commit was the
culprit.

Good job Jiri.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
