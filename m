Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3KFOSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:18:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43778 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab3KFOST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:18:19 -0500
Date: Wed, 6 Nov 2013 15:20:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131106142025.GB16072@x1.alien8.de>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 09:25:52PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> In order to enable on arm64 and improve the build coverage, remove the
> dependency on ARCH_HIGHBANK.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Robert Richter <rric@kernel.org>
> Cc: linux-edac@vger.kernel.org
> ---
>  drivers/edac/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f090..fc8aaaf 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -328,14 +328,14 @@ config EDAC_TILE
>  
>  config EDAC_HIGHBANK_MC
>  	tristate "Highbank Memory Controller"
> -	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
> +	depends on EDAC_MM_EDAC

Please, no, this'll get enabled on other arches where this driver is
simply N/A. It should only depend on the ARM arches it supports.

-- 
Regards/Gruss,
Boris.
