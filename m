Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3J1Lt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:49:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37246 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab3J1Lt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:49:28 -0400
Date: Mon, 28 Oct 2013 11:49:24 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes
Message-ID: <20131028114924.GL1982@console-pimps.org>
References: <20131027214815.GH1982@console-pimps.org>
 <20131028111741.GA7830@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028111741.GA7830@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct, at 12:17:41PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > Guys, do you think we could get the EFI earlyprintk support into the
> > 'x86/efi' branch for the upcoming merge window? I know it's quite late
> > in the game but since it's a new feature it shouldn't introduce any kind
> > of regression and is a much needed feature.
> > 
> > The following changes since commit c158c3bf59951bbb44bd7ccca9e6665dfd1617c5:
> > 
> >   boot, efi: Remove redundant memset() (2013-10-04 20:07:47 +0100)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> > 
> > for you to fetch changes up to 32c9e70fc3912c3b9c7d53ce016960ce99ff93d4:
> > 
> >   x86/efi: Add EFI framebuffer earlyprintk support (2013-10-27 21:18:48 +0000)
> 
> This breaks on x86-64 allmodconfig with:
> 
> arch/x86/built-in.o: In function `early_efi_setup':
> early_printk.c:(.init.text+0x27e9f): undefined reference to `get_default_font'

Ooops! The following patch fixes it. Would you like me to squash this
with the top commit on 'efi-next', retag and resend the pull request?

---

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b6fe388..0f3621e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -61,7 +61,8 @@ config EARLY_PRINTK_DBGP
 
 config EARLY_PRINTK_EFI
 	bool "Early printk via the EFI framebuffer"
-	depends on EFI && EARLY_PRINTK && FONT_SUPPORT
+	depends on EFI && EARLY_PRINTK
+	select FONT_SUPPORT
 	---help---
 	  Write kernel log output directly into the EFI framebuffer.
 
-- 
Matt Fleming, Intel Open Source Technology Center
