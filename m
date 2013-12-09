Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab3LINo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:44:58 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:38102 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590Ab3LINo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:44:56 -0500
Message-ID: <52A5C950.7070903@cogentembedded.com>
Date: Mon, 09 Dec 2013 17:44:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: srinivas kandagatla <srinivas.kandagatla@st.com>,
        Chen-Yu Tsai <wens@csie.org>
CC: devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-sunxi@googlegroups.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC
 in Allwinner A20 SoC's
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-5-git-send-email-wens@csie.org> <52A5A7B2.4000509@st.com>
In-Reply-To: <52A5A7B2.4000509@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-12-2013 15:21, srinivas kandagatla wrote:

>> +static int sun7i_gmac_init(struct platform_device *pdev)
>> +{
>> +	struct resource *res;
>> +	struct device *dev = &pdev->dev;
>> +	void __iomem *addr = NULL;
>> +	struct plat_stmmacenet_data *plat_dat = NULL;

    No need to initialize it since you're assigning to it right below.

>> +	u32 priv_clk_reg;
>> +
>> +	plat_dat = dev_get_platdata(&pdev->dev);
>> +	if (!plat_dat)
>> +		return -EINVAL;

> dev_get_platdata will return NULL for DT, So this function will fail all
> the time.

    Indeed, unless the probe() method assigns it from the 'data' field of
'struct of_device_id'.

> How is it supposed to work?
> Am I missing some thing?

    Look at stmmac_pltfr_probe().

> --srini

WBR, Sergei

