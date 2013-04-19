Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3DSFBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 01:01:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1714 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3DSFBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 01:01:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 18 Apr 2013 22:01:36 -0700
Message-ID: <5170CEBC.5030200@nvidia.com>
Date: Fri, 19 Apr 2013 10:27:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: palmas: Don't update tstep register for
 SMPS3 and SMPS7
References: <1366342893.20735.0.camel@phoenix>
In-Reply-To: <1366342893.20735.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013 09:11 AM, Axel Lin wrote:
> SMPS3 and SMPS7 do not have tstep_addr setting, so current code actually
> writes 0 to PALMAS_SMPS12_CTRL(0x0) register when set_ramp_delay callback
> is called for SMPS3 and SMPS7.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/regulator/palmas-regulator.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index f26344e..cfa143a 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -438,6 +438,10 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
>   	unsigned int addr = palmas_regs_info[id].tstep_addr;
>   	int ret;
>   
> +	/* SMPS3 and SMPS7 do not have tstep_addr setting */
> +	if (!addr)
> +		return 0;
> +

I avoided to compare the tstep_addr because it can be 0 offset also but 
seeing TPS65913 and TPS80036 (which are palma devices),  seeing that 
valid tstep is always non-zero.
Table are populated for offset and there is base register address for 
group of the configuration like smps12_ctl offset is 0 and base is 0x120 
(TPS65913).

I think similar check need to be there in probe also as part of 
cleanups, in place of checking the reg_id, we can check the tstep.


