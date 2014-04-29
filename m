Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbaD2LVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:21:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52253 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933713AbaD2LVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:21:16 -0400
Date: Tue, 29 Apr 2014 12:21:02 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        catalin.marinas@arm.com, msalter@redhat.com, grant.likely@linaro.org,
        roy.franz@linaro.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 03/10] efi: add helper function to get UEFI params
 from FDT
Message-ID: <20140429112102.GG26088@console-pimps.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <1398442154-19974-4-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442154-19974-4-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr, at 05:09:07PM, Leif Lindholm wrote:
> From: Mark Salter <msalter@redhat.com>
> 
> ARM and ARM64 architectures use the device tree to pass UEFI parameters
> from stub to kernel. These parameters are things known to the stub but
> not discoverable by the kernel after the stub calls ExitBootSerives().
> There is a helper function in:
> 
>    drivers/firmware/efi/fdt.c
> 
> which the stub uses to add the UEFI parameters to the device tree.
> This patch adds a complimentary helper function which UEFI runtime
> support may use to retrieve the parameters from the device tree.
> If an architecture wants to use this helper, it should select
> CONFIG_UEFI_PARAMS_FROM_FDT.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  drivers/firmware/efi/Kconfig |    7 ++++
>  drivers/firmware/efi/efi.c   |   79 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h          |    9 +++++
>  3 files changed, 95 insertions(+)

Looks OK, but is there any chance we could swap CONFIG_UEFI_* for
CONFIG_EFI_* when someone picks this up? We've generally done pretty
well to keep the naming consistent and I'd like to hold on to that
consistency for as long as possible (especially since the function names
begin efi_*).

And yes, I realise that no one (apart from perhaps Apple) ships with EFI
anymore and it's all UEFI, but we've kinda developed our own naming
scheme at this point.

Otherwise, 

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
