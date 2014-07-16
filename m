Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbaGPFlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:41:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55908 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124AbaGPFlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:41:12 -0400
Message-ID: <53C61057.7000704@ti.com>
Date: Wed, 16 Jul 2014 08:40:39 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Asadi <asadi.samuel@gmail.com>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 46/94] ARM: dts: am335x-evm: Enable the McASP FIFO for
 audio
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com> <1405443709-15288-46-git-send-email-asadi.samuel@gmail.com>
In-Reply-To: <1405443709-15288-46-git-send-email-asadi.samuel@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 08:01 PM, Sam Asadi wrote:
> From: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> The use of FIFO in McASP can reduce the risk of audio under/overrun and
> lowers the load on the memories since the DMA will operate in bursts.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
> ---
>  arch/arm/boot/dts/am335x-evm.dts |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

What is the reason this patch is in this */94 series? What is this series of
patches anyways?
FWIW the two McASP FIFO enable patch is already in mainline and they should
not be backported to older kernels w/o the changes in the mcasp driver in 3.16.

> 
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index ecb2677..e2156a5 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -529,8 +529,8 @@
>  		serial-dir = <  /* 0: INACTIVE, 1: TX, 2: RX */
>  			0 0 1 2
>  		>;
> -		tx-num-evt = <1>;
> -		rx-num-evt = <1>;
> +		tx-num-evt = <32>;
> +		rx-num-evt = <32>;
>  };
>  
>  &tps {
> 


-- 
Péter
