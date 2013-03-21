Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3CUSTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:19:48 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47635 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3CUSTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:19:46 -0400
Message-ID: <514B4F3F.8000308@gmail.com>
Date: Thu, 21 Mar 2013 13:19:43 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Lior Amsalem <alior@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>
Subject: Re: [PATCH 2/5] arm: mvebu: Select DMA_BOUNCE when LPAE is selected
 in Kconfig
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <1363883179-1361-3-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1363883179-1361-3-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 11:26 AM, Gregory CLEMENT wrote:
> From: Lior Amsalem <alior@marvell.com>
> 
> For mvebu IOs are 32 bits and we have 40 bits memory due to LPAE so
> make sure we give 32 bits addresses to the IOs.
> 
> Signed-off-by: Lior Amsalem <alior@marvell.com>
> Tested-by: Franklin <flin@marvell.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/mach-mvebu/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
> index 440b13e..617da94 100644
> --- a/arch/arm/mach-mvebu/Kconfig
> +++ b/arch/arm/mach-mvebu/Kconfig
> @@ -13,6 +13,7 @@ config ARCH_MVEBU
>  	select MVEBU_CLK_CORE
>  	select MVEBU_CLK_CPU
>  	select MVEBU_CLK_GATING
> +	select DMABOUNCE if ARM_LPAE

This alone is not enough to use bounce buffers. Am I missing something?

Rob

>  
>  if ARCH_MVEBU
>  
> 

