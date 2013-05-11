Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3EKTLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 15:11:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48581 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3EKTL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 15:11:29 -0400
Date: Sat, 11 May 2013 20:10:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Russ Anderson <rja@sgi.com>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v10 09/11] arm, prepare reboot_mode for moving to
	generic kernel code.
Message-ID: <20130511191051.GE18614@n2100.arm.linux.org.uk>
References: <1368273447-11958-1-git-send-email-holt@sgi.com> <1368273447-11958-10-git-send-email-holt@sgi.com> <20130511130457.GD18614@n2100.arm.linux.org.uk> <588ed084-fed7-4bd9-bcd7-a32f40bd404a@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <588ed084-fed7-4bd9-bcd7-a32f40bd404a@email.android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, stop this idiotic incomprehensible jargon.

On Sat, May 11, 2013 at 08:47:28AM -0700, H. Peter Anvin wrote:
> By the way, do we really need Yoda programming here?
> 
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> >On Sat, May 11, 2013 at 06:57:25AM -0500, Robin Holt wrote:
> >> This patch prepares for the moving the parsing of reboot= to the
> >generic
> >> kernel code by making reboot_mode into a more generic form.
> >> 
> >> Signed-off-by: Robin Holt <holt@sgi.com>
> >> To: Andrew Morton <akpm@linux-foundation.org>
> >> To: Russell King <linux@arm.linux.org.uk>
> >> Cc: Russ Anderson <rja@sgi.com>
> >> Cc: Robin Holt <holt@sgi.com>
> >> Cc: H. Peter Anvin <hpa@zytor.com>
> >> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> >> Cc: the arch/x86 maintainers <x86@kernel.org>
> >> Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
> >
> >Almost-but-not-quite-Acked-by: Russell King
> ><rmk+kernel@arm.linux.org.uk> :)
> >
> >> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> >> index f219703..92b47df 100644
> >> --- a/arch/arm/kernel/process.c
> >> +++ b/arch/arm/kernel/process.c
> >> @@ -174,14 +174,14 @@ void arch_cpu_idle(void)
> >>  		default_idle();
> >>  }
> >>  
> >> -static char reboot_mode = 'h';
> >> +enum reboot_mode reboot_mode = REBOOT_HARD;
> >>  
> >> -int __init reboot_setup(char *str)
> >> +static int __init reboot_setup(char *str)
> >>  {
> >> -	reboot_mode = str[0];
> >> +	if ('s' == str[0])
> >> +		reboot_mode = REBOOT_SOFT;
> >
> >Remember we talked about the 'gpio' mode as well, so you also need here
> >+	if ('g' == str[0])
> >		reboot_mode = REBOOT_GPIO;
> 
> -- 
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
