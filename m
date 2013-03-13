Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3CMIh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:37:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:41830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3CMIhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,834,1355126400"; 
   d="scan'208";a="305376933"
Date: Wed, 13 Mar 2013 09:37:20 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, swarren@nvidia.com, ian@slimlogic.co.uk
Subject: Re: [PATCH V2] mfd: palmas: provide irq flags through DT/platform
 data
Message-ID: <20130313083720.GD21994@zurbaran>
References: <1362149026-21170-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362149026-21170-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Fri, Mar 01, 2013 at 08:13:46PM +0530, Laxman Dewangan wrote:
> Currently driver sets the irq type to IRQF_TRIGGER_LOW which is
> causing interrupt registration failure in ARM based SoCs as:
> [    0.208479] genirq: Setting trigger mode 8 for irq 118 failed (gic_set_type+0x0/0xf0)
> [    0.208513] dummy 0-0059: Failed to request IRQ 118: -22
> 
> Provide the irq flags through platform data if device is registered
> through board file or get the irq type from DT node property in place
> of hardcoding the irq flag in driver to support multiple platforms.
> 
> Also configure the device to generate the interrupt signal according to
> flag type.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Use palmas_update_bits() for rea/modiy/write.
> 
>  drivers/mfd/palmas.c       |   36 +++++++++++++++++++++++++++++++++---
>  include/linux/mfd/palmas.h |    1 +
>  2 files changed, 34 insertions(+), 3 deletions(-)
Patch applied to my mfd-fixes tree now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
