Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaBUO15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:27:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38281 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaBUO1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:27:55 -0500
Date: Fri, 21 Feb 2014 15:27:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dougthompson@xmission.com, bhelgaas@google.com, JBeulich@suse.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
        Arindam.Nath@amd.com
Subject: Re: [PATCH] amd64_edac: Add support for newer F16h models
Message-ID: <20140221142749.GC11531@pd.tnic>
References: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:28:46AM -0600, Aravind Gopalakrishnan wrote:
> Extending ECC decoding support for F16h M30h.
> 
> Tested on F16h M30h with ECC turned on using mce_amd_inj module and
> the patch works fine.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> Tested-by: Arindam Nath <Arindam.Nath@amd.com>
> ---
>  arch/x86/kernel/amd_nb.c  |  2 ++
>  drivers/edac/amd64_edac.c | 24 ++++++++++++++++++++++++
>  drivers/edac/amd64_edac.h |  3 +++
>  include/linux/pci_ids.h   |  2 ++
>  4 files changed, 31 insertions(+)

...

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 97fbecd..e91ad27 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -528,6 +528,8 @@
>  #define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
>  #define PCI_DEVICE_ID_AMD_16H_NB_F3	0x1533
>  #define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
> +#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F3 0x1583
> +#define PCI_DEVICE_ID_AMD_16H_M30H_NB_F4 0x1584

Just put those in arch/x86/include/asm/amd_nb.h as amd64_edac.c includes
it already and you can avoid the pci_ids.h addition. Unless there are
plans to use F{3,4} in other places too...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
