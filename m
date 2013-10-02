Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3JBLvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:51:20 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19511 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3JBLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:51:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Oct 2013 04:47:24 -0700
Message-ID: <524C0E4B.4050603@nvidia.com>
Date: Wed, 2 Oct 2013 17:45:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT][PATCH 2/2] regulator: as3722: Fix off-by-one n_voltages
 setting for SDx
References: <1380641628.19681.3.camel@phoenix> <1380641753.19681.5.camel@phoenix>
In-Reply-To: <1380641753.19681.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 October 2013 09:05 PM, Axel Lin wrote:
> AS3722_SDx_VSEL_MAX means the maximum selector, the n_voltages should be
> AS3722_SDx_VSEL_MAX + 1.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/regulator/as3722-regulator.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
> index c6a1fc6..91b0abe 100644
> --- a/drivers/regulator/as3722-regulator.c
> +++ b/drivers/regulator/as3722-regulator.c
> @@ -99,7 +99,7 @@ static const struct as3722_register_mapping as3722_reg_lookup[] = {
>   		.sleep_ctrl_mask = AS3722_SD0_EXT_ENABLE_MASK,
>   		.control_reg = AS3722_SD0_CONTROL_REG,
>   		.mode_mask = AS3722_SD0_MODE_FAST,
> -		.n_voltages = AS3722_SD0_VSEL_MAX,
> +		.n_voltages = AS3722_SD0_VSEL_MAX + 1,
>   	},

Agree, to allow the VSEL_MAX as valid value, it need to be +1 in n_voltages.

         if (selector >= rdev->desc->n_voltages)
                 return -EINVAL;


Originally, I offset this because of min_sel is  1 as thinking that 
n_voltages are number of voltages but it become MAX_VSEL. Seems my 
interpretation issue.

In header, it is defined as
#define AS3722_SD0_VSEL_MIN                             0x01
#define AS3722_SD0_VSEL_MAX                             0x5A
#define AS3722_SD2_VSEL_MIN                             0x01
#define AS3722_SD2_VSEL_MAX                             0x7F


Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

