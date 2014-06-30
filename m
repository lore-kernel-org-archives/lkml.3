Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaF3VZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:25:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53212 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaF3VZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:25:01 -0400
Date: Mon, 30 Jun 2014 23:23:35 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, "Wenyou.Yang" <wenyou.yang@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: act8865: Explictly initialize of_node
 array
Message-ID: <20140630212334.GA5745@gmail.com>
References: <1404113529.21614.1.camel@phoenix>
 <1404113605.21614.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404113605.21614.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:33:25PM +0800, Axel Lin wrote:
> Silence below build warning:
>   CC [M]  drivers/regulator/act8865-regulator.o
> drivers/regulator/act8865-regulator.c: In function ‘act8865_pmic_probe’:
> drivers/regulator/act8865-regulator.c:321: warning: ‘of_node’ may be used uninitialized in this function

Hi Axel,

some days ago I submitted a patch series that adds support for other
act88xx chips to the driver and reworks the probe function, also
indirectly fixing the warning about uninitialized of_node:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265477.html

Beniamino

> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/act8865-regulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
> index f07be36..e9fea78 100644
> --- a/drivers/regulator/act8865-regulator.c
> +++ b/drivers/regulator/act8865-regulator.c
> @@ -276,7 +276,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
>  	struct act8865_platform_data *pdata = dev_get_platdata(dev);
>  	struct regulator_config config = { };
>  	struct act8865 *act8865;
> -	struct device_node *of_node[ACT8865_REG_NUM];
> +	struct device_node *of_node[ACT8865_REG_NUM] = { };
>  	int i;
>  	int ret;
>  
> -- 
> 1.9.1


