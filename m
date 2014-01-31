Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaAaOHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:07:54 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36860 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaAaOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:07:52 -0500
Message-ID: <52EBAE41.8060403@cogentembedded.com>
Date: Fri, 31 Jan 2014 18:08:01 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: Andreas Larsson <andreas@gaisler.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] can: sja1000: of: add reg-io-width property for
 8, 16 and 32-bit register access
References: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch> <1391175277-19833-6-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1391175277-19833-6-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 31-01-2014 17:34, Florian Vaussard wrote:

> Add the 'reg-io-width' property for 8, 16 and 32-bit access, like
> what is currently done with IORESOURCE_MEM_{8,16,32}BIT for non-OF
> boot.

> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>   drivers/net/can/sja1000/sja1000_platform.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can/sja1000/sja1000_platform.c
> index 50dece8..25122bf 100644
> --- a/drivers/net/can/sja1000/sja1000_platform.c
> +++ b/drivers/net/can/sja1000/sja1000_platform.c
> @@ -102,8 +102,20 @@ static void sp_populate_of(struct sja1000_priv *priv, struct device_node *of)
>   	int err;
>   	u32 prop;
>
> -	priv->read_reg = sp_read_reg8;
> -	priv->write_reg = sp_write_reg8;
> +	err = of_property_read_u32(of, "reg-io-width", &prop);
> +	if (err)
> +		prop = 1;
> +
> +	if (prop == 4) {

    This is asking to be a *switch* statement instead.

> +		priv->read_reg = sp_read_reg32;
> +		priv->write_reg = sp_write_reg32;
> +	} else if (prop == 2) {
> +		priv->read_reg = sp_read_reg16;
> +		priv->write_reg = sp_write_reg16;
> +	} else {
> +		priv->read_reg = sp_read_reg8;
> +		priv->write_reg = sp_write_reg8;
> +	}

WBR, Sergei

