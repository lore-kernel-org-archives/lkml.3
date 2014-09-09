Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbaIIO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:57:20 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61219 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbaIIO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:57:16 -0400
Date: Tue, 9 Sep 2014 16:57:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL v2] EFI urgent fixes
Message-ID: <20140909145711.GD19536@gmail.com>
References: <20140909080233.GG18582@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909080233.GG18582@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Folks, this is a resend of the EFI urgent pull request from yesterday
> with the non-regression-fixing patches dropped as Ingo requested. The
> patches fix two regressions introduced during the merge window, and one
> introduced in -rc2.
> 
> The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
> 
>   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 0ceac9e094b065fe3fec19669740f338d3480498:
> 
>   efi/arm64: Fix fdt-related memory reservation (2014-09-09 07:51:09 +0100)
> 
> ----------------------------------------------------------------
>  * Fix early boot regression affecting x86 EFI boot stub when loading
>    initrds above 4GB - Yinghai Lu
> 
>  * Relocate GOT entries in the x86 EFI boot stub now that we have
>    symbols with global visibility - Matt Fleming
> 
>  * fdt memory reservation fix for arm64 - Mark Salter
> 
> ----------------------------------------------------------------
> Mark Salter (1):
>       efi/arm64: Fix fdt-related memory reservation
> 
> Matt Fleming (1):
>       x86/efi: Fixup GOT in all boot code paths
> 
> Yinghai Lu (1):
>       x86/efi: Only load initrd above 4g on second try
> 
>  arch/arm64/mm/init.c               |  3 +-
>  arch/x86/boot/compressed/eboot.c   | 18 +++++++-----
>  arch/x86/boot/compressed/head_32.S | 54 ++++++++++++++++++++++++++----------
>  arch/x86/boot/compressed/head_64.S | 56 ++++++++++++++++++++++++++++----------
>  drivers/firmware/efi/libstub/fdt.c | 10 ++++++-
>  5 files changed, 102 insertions(+), 39 deletions(-)

Pulled into tip:x86/urgent, thanks a lot Matt!

	Ingo
