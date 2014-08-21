Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaHUTaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:30:17 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:40472 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaHUTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <1408612915-8657-2-git-send-email-Yanjun.Zhu@windriver.com>
References: <1408612915-8657-1-git-send-email-Yanjun.Zhu@windriver.com>
	<1408612915-8657-2-git-send-email-Yanjun.Zhu@windriver.com>
Date: Thu, 21 Aug 2014 14:30:12 -0500
Message-ID: <CAHrpEqTtsLk3x3ocHSXh3C1ysvqq+RSg-sD0YZ5O8iuZfMYvEg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net:fec: buffer descriptor member variable order in IMX6
From: Zhi Li <lznuaa@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Zhu Yanjun <Yanjun.Zhu@windriver.com>,
        Frank Li <Frank.Li@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 4:21 AM, Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> From Reference Manual, freescale IMX6 is little endian mode. Therefore
> the first structure field is length, the second is status.
>
> CC: David Miller <davem@davemloft.net>
> CC: Frank Li <Frank.Li@freescale.com>
> Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
> ---
>  drivers/net/ethernet/freescale/fec.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 671d080..96a5f8a 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -147,7 +147,8 @@
>  /*
>   *     Define the buffer descriptor structure.
>   */
> -#if defined(CONFIG_ARCH_MXC) || defined(CONFIG_SOC_IMX28)
> +#if defined(CONFIG_ARCH_MXC) || defined(CONFIG_SOC_IMX28) || \
> +                       defined(CONFIG_ARCH_MX6)

CONFIG_ARCH_MXC already included CONFIG_ARCH_MX6
ARCH_MXC included whole MX serial, MX35, MX5x, MX6x.

IMX28 is special, coming from sigmatel chip.

So it is not necessary to add ARCH_MX6


Best regards
Frank Li

>  struct bufdesc {
>         unsigned short cbd_datlen;      /* Data length */
>         unsigned short cbd_sc;  /* Control and status info */
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
