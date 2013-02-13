Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3BMHIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:08:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16383 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3BMHIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:08:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 12 Feb 2013 23:03:16 -0800
Message-ID: <511B3AA0.7020403@nvidia.com>
Date: Wed, 13 Feb 2013 12:32:56 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] clk: tegra: initialise parent of uart clocks
References: <1360682279-23051-1-git-send-email-ldewangan@nvidia.com> <511A7FF1.1030009@wwwdotorg.org>
In-Reply-To: <511A7FF1.1030009@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013 11:16 PM, Stephen Warren wrote:
> On 02/12/2013 08:17 AM, Laxman Dewangan wrote:
>> Initialise the parent of UARTs to PLLP and disabling clock by
>> default.
> This patch wasn't tested, was it? Without the patch I just sent titled
> "ARM: tegra: remove clock-frequency properties from serial nodes", the
> UART clocks get turned off and the console breaks.

I tested this in next-20130212 where "clock-frequency" is there in 
tegra30.dtsi file.
If you remove this from dts file at all then it will not work as there 
is no execution path to call the clk_prepare_enable().

of_serial.c file:
         if (of_property_read_u32(np, "clock-frequency", &clk)) {

                 /* Get clk rate through clk driver if present */
                 info->clk = clk_get(&ofdev->dev, NULL);
                 if (IS_ERR(info->clk)) {
                         dev_warn(&ofdev->dev,
                                 "clk or clock-frequency not defined\n");
                         return PTR_ERR(info->clk);
                 }

                 clk_prepare_enable(info->clk);
                 clk = clk_get_rate(info->clk);
         }
