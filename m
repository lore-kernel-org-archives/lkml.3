Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbbAVQx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:53:26 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:35884 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbbAVQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:53:22 -0500
Message-ID: <54C12AF9.40200@mentor.com>
Date: Thu, 22 Jan 2015 10:53:13 -0600
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        Ohad Ben-Cohen <ohad@wizery.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 2/2] remoteproc: microblaze: Add support for microblaze
 on Zynq
References: <a458462d2dc6901440bded015608f7a9df9e7942.1421662385.git.michal.simek@xilinx.com> <10276362c737fc9da863f1a07737fd91f7340242.1421662385.git.michal.simek@xilinx.com>
In-Reply-To: <10276362c737fc9da863f1a07737fd91f7340242.1421662385.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 04:30 AM, Michal Simek wrote:
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index 5e343bab9458..3955f42e9e9c 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -64,4 +64,15 @@ config DA8XX_REMOTEPROC
>  	  It's safe to say n here if you're not interested in multimedia
>  	  offloading.
> 
> +config MB_REMOTEPROC
> +	tristate "Support Microblaze remoteproc"
> +	depends on ARCH_ZYNQ && !DEBUG_SG
> +	select GPIO_XILINX
> +	select REMOTEPROC
> +	select RPMSG
> +	default m
> +	help
> +	  Say y here to support Xilinx Microblaze remote processors
> +	  on the Xilinx Zynq.
> +
>  endmenu

The dependency on !DEBUG_SG seems unusual, and worth a comment if it's
truly needed.  And the module should be disabled by default, no?

