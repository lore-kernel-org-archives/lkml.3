Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaCUVXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:23:38 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:52684 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaCUVXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:23:36 -0400
Date: Fri, 21 Mar 2014 22:23:20 +0100
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Hubert Chaumette <hchaumette@adeneo-embedded.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
Message-ID: <20140321222320.14370739@e6520eb>
In-Reply-To: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com>
References: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com>
Organization: =?ISO-8859-1?B?RXVrculh?= Electromatique
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hubert,

Le Fri, 21 Mar 2014 18:08:07 +0100,
Hubert Chaumette <hchaumette@adeneo-embedded.com> a écrit :

> 
> Update KSZ9031RN phy fixup for Congatec conga-QEVAL and conga-QMX6 combo :
> set RGMII GTX_CLK and RX_CLK pad skew to +0.96ns.
> 
> Signed-off-by: Hubert Chaumette <hchaumette@adeneo-embedded.com>
> ---
>  arch/arm/mach-imx/mach-imx6q.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index 76e5db4..db307c2 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -77,6 +77,9 @@ static int ksz9031rn_phy_fixup(struct phy_device *dev)
>  	mmd_write_reg(dev, 2, 5, 0);
>  	mmd_write_reg(dev, 2, 8, 0x003ff);
>  
> +	/* For Congatec conga-QMX6 board */
> +	mmd_write_reg(dev, 0x02, 0x06, 0xffff);
> +
>  	return 0;
>  }
>  
that's board specific (the needed delay depends on the routing delay on
the PCB), so this should not go in a generic file.

Eric
