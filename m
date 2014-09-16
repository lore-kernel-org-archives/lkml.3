Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaIPGi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:38:56 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40638 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaIPGiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:38:54 -0400
Date: Tue, 16 Sep 2014 08:38:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Martin Kelly <martin@martingkelly.com>
Cc: x86@kernel.org, vishwesh.m.rudramuni@intel.com, joe@perches.com,
        hpa@linux.intel.com, aubrey.li@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
Message-ID: <20140916063850.GB14807@gmail.com>
References: <1410841463-24826-1-git-send-email-martin@martingkelly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410841463-24826-1-git-send-email-martin@martingkelly.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Kelly <martin@martingkelly.com> wrote:

> When compiling with CONFIG_DEBUG_FS=n, gcc emits an unused variable
> warning for pmc_atom.c because "ret" is used only within the
> CONFIG_DEBUG_FS block. This patch fixes it up to eliminate "ret" when
> CONFIG_DEBUG_FS=n.
> 
> Signed-off-by: Martin Kelly <martkell@amazon.com>
> ---
>  arch/x86/kernel/pmc_atom.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
> index 0c424a6..66e7d88 100644
> --- a/arch/x86/kernel/pmc_atom.c
> +++ b/arch/x86/kernel/pmc_atom.c
> @@ -240,7 +240,9 @@ err:
>  static int pmc_setup_dev(struct pci_dev *pdev)
>  {
>  	struct pmc_dev *pmc = &pmc_device;
> +#ifdef CONFIG_DEBUG_FS
>  	int ret;
> +#endif /* CONFIG_DEBUG_FS */
>  
>  	/* Obtain ACPI base address */
>  	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);

This uglifies the code which is bad. A nicer fix would be to 
improve the code: for example define pmc_dbgfs_register() in the 
!DEBUG_FS case as well, with a return 0 or so.

Thanks,

	Ingo
