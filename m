Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaHNMPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:15:46 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33981 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaHNMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:15:45 -0400
Message-ID: <53ECA866.2080306@linaro.org>
Date: Thu, 14 Aug 2014 13:15:34 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
CC: devicetree@vger.kernel.org, alexandre torgue <alexandre.torgue@st.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>, kernel@stlinux.com
Subject: Re: [PATCH 3/5] phy: miphy28lp: Provide support for the MiPHY28lp
 Generic PHY
References: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org> <1407944075-8093-4-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1407944075-8093-4-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabi,

I did not review the full patchset but this function caught my attention..

> +};
> +
> +static int miphy28lp_get_ressource_byname(struct device_node *child,
> +					  char *name, struct resource *res)
> +{

s/miphy28lp_get_ressource_byname/miphy28lp_get_resource_byname

> +	int index, ret = 0, count = 0;
> +	int reg_tuple_size;
> +	const __be32 *p;
> +
> +	reg_tuple_size = (of_n_addr_cells(child) +
> +			of_n_size_cells(child)) * sizeof(u32);
> +
> +	p = of_get_property(child, "reg", &count);
> +	if (count % reg_tuple_size != 0)
> +		ret = -EINVAL;
> +
> +	count /= reg_tuple_size;
> +
> +	for (index = 0; index < count; index++) {
> +		const char *rname = NULL;
> +
> +		ret = of_property_read_string_index(child, "reg-names",
> +						    index, &rname);
> +		if (!strcmp(name, rname))
> +			return of_address_to_resource(child, index, res);
> +	}
> +
> +	return 1;
This function looks bit complicated, can't we just use:

	index = of_property_match_string(np, "reg-names", rname);
	if (index < 0)
		return -ENODEV;

	return of_address_to_resource(child, index, res);



--srini
