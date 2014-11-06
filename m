Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaKFNvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:51:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaKFNvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:51:19 -0500
Message-ID: <545B7CD5.8090802@suse.de>
Date: Thu, 06 Nov 2014 14:51:17 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "J. German Rivera" <German.Rivera@freescale.com>,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
CC: stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Subject: Re: [PATCH 3/3 v3] drivers/bus: Device driver for FSL-MC DPRC devices
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com> <1412429015-30564-4-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1412429015-30564-4-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04.10.14 15:23, J. German Rivera wrote:
> From: "J. German Rivera" <German.Rivera@freescale.com>
> 
> A DPRC (Data Path Resource Container) is an isolation device
> that contains a set of DPAA networking devices to be
> assigned to an isolation domain (e.g., a virtual machine).
> 
> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> ---
> Changes in v3:
> - Addressed comments from Kim Phillips:
>   * Renamed files:
>     drivers/bus/fsl-mc/fsl_mc_dprc.c -> drivers/bus/fsl-mc/dprc-driver.c
> 
> - Addressed comments from Timur Tabi:
>   * Changed dprc_scan_container() to just return dprc_scan_objects()
>   * Changed all functions that had goto out/error when no common cleanup
>     was done, to just have multiple return points.
>   * Replaced error cleanup boolean flags with multiple exit points.
>   * REmoved __must_chewck from dprc_scan_*() functions
> 
> Changes in v2:
> - Addressed comments from Kim Phillips:
>   * Fix warning in drivers/bus/fsl-mc/fsl_mc_dprc.c:173
>   * Fixed linker errors when MC bus driver built as module
> 
>  drivers/bus/fsl-mc/Makefile      |    3 +-
>  drivers/bus/fsl-mc/dprc-driver.c |  383 ++++++++++++++++++++++++++++++++++++++
>  drivers/bus/fsl-mc/mc-bus.c      |    8 +
>  include/linux/fsl/mc-private.h   |   10 +
>  4 files changed, 403 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/bus/fsl-mc/dprc-driver.c
> 
> diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
> index decd339..424e58e 100644
> --- a/drivers/bus/fsl-mc/Makefile
> +++ b/drivers/bus/fsl-mc/Makefile
> @@ -10,5 +10,6 @@ obj-$(CONFIG_FSL_MC_BUS) += mc-bus-driver.o
>  mc-bus-driver-objs := mc-bus.o \
>  		      mc-sys.o \
>  		      dprc.o \
> -		      dpmng.o
> +		      dpmng.o \
> +		      dprc-driver.o
> 
> diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
> new file mode 100644
> index 0000000..8be6a2a
> --- /dev/null
> +++ b/drivers/bus/fsl-mc/dprc-driver.c
> @@ -0,0 +1,383 @@
> +/*
> + * Freescale daata path resource container (DPRC) driver

daata? ;)

Is there any way I can play with this bus? How far do I get with only
these 3 patches applied today?


Alex
