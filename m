Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3JCMHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:07:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10289 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JCMHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:07:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Oct 2013 05:03:40 -0700
Message-ID: <524D63A9.10608@nvidia.com>
Date: Thu, 3 Oct 2013 18:01:37 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] regulator: as3722: Fix equation to calculate max_uV
 in regulator_lin_range macro
References: <1380718076.7307.1.camel@phoenix>
In-Reply-To: <1380718076.7307.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 06:17 PM, Axel Lin wrote:
> Fix off-by-one in the equation to calculate max_uV and also adjust the _min_uV
> setting accordingly.
>
> For LDOs:
> The voltage select bits set the LDO output voltage 0.825V...3.3V, 25mV steps
>    ....00h : LDO off
>    01h-24h : V_LDO4 = 0.8V + ldo4_vsel * 25mV
>                     = 0.825V + (ldo4_vsel - 1h) * 25mV
>    25h-3Fh : do not use
>    40h-7Fh : V_LDO4 = 1.725V + (ldo4_vsel - 40h) * 25mV
>
> For SD2345:
> The voltage select bits set the DC/DC output voltage level and power the DC/DC
> converter down.
>    ....00h : DC/DC powered down
>    01h-40h : V_SD2 = 0.6V + sd2_vsel * 12.5mV
>                    = 0.6125V + (sd2_vsel - 1h) * 12.5mV
>    41h-70h : V_SD2 = 1.4V + (sd2_vsel - 40h) * 25mV
>                    = 1.425V + (sd2_vsel - 41h) * 25mV
>    71h-7Fh : V_SD2 = 2.6V + (sd2_vsel - 70h) * 50mV
>                    = 2.65V + (sd2_vsel - 71h) * 50mV
>
> Note, the third entry in as3722_sd2345_ranges is wrong in current code.
> Fix it based on the datasheet.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
