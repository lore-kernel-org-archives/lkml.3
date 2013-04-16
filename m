Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3DPMI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:08:28 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:42040 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832Ab3DPMI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:08:27 -0400
Message-ID: <516D3F2F.8080905@stericsson.com>
Date: Tue, 16 Apr 2013 14:08:15 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT][PATCH 1/3] regulator: ab8500-ext: Don't allow set idle
 mode if info->cfg->hwreq is set
References: <1365598464.24689.1.camel@phoenix>
In-Reply-To: <1365598464.24689.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 02:54 PM, Axel Lin wrote:
> The regulator always on with high power mode if info->cfg->hwreq is set.
>
> If we allow set idle mode when info->cfg->hwreq is set, get_mode() returns
> REGULATOR_MODE_IDLE but the regulator actually is in REGULATOR_MODE_NORMAL mode.
> This patch avoid inconsistent status return by get_mode().
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>z
> ---
>   drivers/regulator/ab8500-ext.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> index 9aee21c..f0a1bbf 100644
> --- a/drivers/regulator/ab8500-ext.c
> +++ b/drivers/regulator/ab8500-ext.c
> @@ -192,6 +192,10 @@ static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
>   		info->update_val = info->update_val_hp;
>   		break;
>   	case REGULATOR_MODE_IDLE:
> +		/* Always on with high power mode if info->cfg->hwreq is set */
> +		if (info->cfg && info->cfg->hwreq)
> +			return -EINVAL;
> +
>   		info->update_val = info->update_val_lp;
>   		break;
>   
I prefer to have info->update_val updated to reflect requested mode (in 
get_mode) instead of returning -EINVAL. This is how I interpret Mark's 
comment on the other patch ([PATCH] regulator: ab8500: Fix get_mode for 
shared mode regulators).Otherwise, the patch should work fine.

Regards,

Bengt
