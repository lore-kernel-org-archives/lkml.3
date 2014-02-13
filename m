Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaBMLRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:17:15 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:51206 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbaBMLRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:17:13 -0500
Date: Thu, 13 Feb 2014 11:17:02 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, patches@linaro.org,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 03/22] efi: add helper function to get UEFI params from
 FDT
Message-ID: <20140213111637.GE20717@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
 <1391619853-10601-4-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391619853-10601-4-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Feb, at 05:03:54PM, Leif Lindholm wrote:
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

Is there a particular reason this change is being added to
drivers/firmware/efi/efi.c and not drivers/firmware/efi/fdt.c?

-- 
Matt Fleming, Intel Open Source Technology Center
