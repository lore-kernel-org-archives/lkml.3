Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3IENVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:21:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43987 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab3IENVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:21:11 -0400
Date: Thu, 5 Sep 2013 14:21:06 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com,
        tony.luck@gmail.com, grant.likely@secretlab.ca, x86@kernel.org
Subject: Re: [PATCH v4 0/3] Make commonly useful UEFI functions common
Message-ID: <20130905132106.GA7579@console-pimps.org>
References: <1378377295-32758-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378377295-32758-1-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Sep, at 11:34:52AM, Leif Lindholm wrote:
> This set breaks out some common code from x86/ia64 EFI support
> code and puts it into drivers/firmware/efi.
> 
> First it takes the definition of the global "efi" data structure
> and moves it into global efi.c. Then it implements a common version
> of efi_config_init().
> 
> Secondly it breaks the efi_lookup_mapped_addr() function out of x86
> and places it in global efi.c, for shared use with future ARM
> patches.
> 
> IA64 code compile tested only.
> 
> Leif Lindholm (3):
>   ia64: add early_memremap() alias for early_ioremap()
>   efi: x86: ia64: provide a generic efi_config_init()
>   efi: x86: make efi_lookup_mapped_addr() a common function
> 
>  arch/ia64/include/asm/io.h  |    1 +
>  arch/ia64/kernel/efi.c      |   54 ++++-------------
>  arch/x86/platform/efi/efi.c |  126 ++++----------------------------------
>  drivers/firmware/efi/efi.c  |  140 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h         |    8 +++
>  5 files changed, 170 insertions(+), 159 deletions(-)

Thanks Leif.

I've pulled this patch series into the 'arm/efi-stub' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

as I know that Grant wanted these changes (and the subsequent patches)
in a clean branch.

Tip folks, how can we get the 'arm/efi-stub' branch into linux-next? My
plan was to merge 'arm/efi-stub' into my 'next' branch and ask you to
pull that into whichever branch you include in linux-next. Does that
work?

-- 
Matt Fleming, Intel Open Source Technology Center
