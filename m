Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaJ1Rqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:46:39 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46799 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1Rqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:46:38 -0400
Date: Tue, 28 Oct 2014 10:46:33 -0700
From: josh@joshtriplett.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH 0/3] x86_64: Tidy up vsyscall emulation and make it
 optional
Message-ID: <20141028174633.GB12195@cloud>
References: <cover.1414516558.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414516558.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:22:25AM -0700, Andy Lutomirski wrote:
> Now that arch/x86/kernel/vsyscall_64.c contains only vsyscall
> emulation code, clean it up and make it optional.
> 
> Patch 1 makes vsyscall=none work be a bit more self-consistent: it
> actually removes the fake vsyscall page instead of just segfaulting
> anyone who tries to use it.
> 
> Patch 2 is pure cosmetic cleanup.
> 
> Patch 3 is the meat: it lets vsyscall emulation be configured out.
> The config option to disable it is hidden under CONFIG_EXPERT, since
> it will break legacy code.
> 
> Note that, last I checked, current userspace is unlikely to work if
> the vDSO *and* vsyscalls are off.  Take it up with the glibc
> maintainers.
> 
> This applies on top of tip/x86/vdso.
> 
> Andy Lutomirski (3):
>   x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
>   x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
>   x86_64,vsyscall: Make vsyscall emulation configurable

Nice!

For patches 1 and 2:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

For patch 3, I responded with a possible minor improvement, but with or
without that:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I assume these should go through tip/x86/vdso as well?

Also, any plans to do something similar for vsyscall_gtod.c?

- Josh Triplett
