Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936404Ab3DRRdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:33:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10215 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936140Ab3DRRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:33:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 18 Apr 2013 10:31:12 -0700
Message-ID: <51702D5E.6060304@nvidia.com>
Date: Thu, 18 Apr 2013 22:59:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: palmas: Fix min_uV for LDO8 tracking mode
References: <1366304032.27953.1.camel@phoenix>
In-Reply-To: <1366304032.27953.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013 10:23 PM, Axel Lin wrote:
> When SMPS45 is set to off and LDO8 tracking is enabled, the output voltage can
> be set from 0.45 to 1.65 V. Thus set min_uV to be 450000.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Laxman,
> My understanding is based on your comment in the code.
>          /*
>           * When SMPS45 is set to off and LDO8 tracking is enabled, the LDO8
>           * output is defined by the LDO8_VOLTAGE.VSEL register divided by two,
>           * and can be set from 0.45 to 1.65 V.
>           */
>
> Can you confirm if this patch is correct or not?

Yes, this is correct.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>


Unfortunately the PMIC device which we have is having bug for which we 
are disabling tracking before going to suspend and enabling again in 
resume and hence it is not
caught. I will pull this change to my downstream also.

