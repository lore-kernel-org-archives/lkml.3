Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3FRPxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:53:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33316 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3FRPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:53:18 -0400
Message-ID: <51C0826B.4060101@wwwdotorg.org>
Date: Tue, 18 Jun 2013 09:53:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        gg@slimlogic.co.uk
Subject: Re: [PATCH v2 2/4] MFD: Palmas: Add SMPS10_BOOST feature
References: <1371549794-7406-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1371549794-7406-1-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 04:03 AM, J Keerthy wrote:
> The SMPS10 regulator is not presesnt in all the variants
> of the PALMAS PMIC family. Hence adding a feature to distingush
> between them.

> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c

> +	match = of_match_device(of_match_ptr(of_palmas_match_tbl), &i2c->dev);
> +
> +	if (match) {
> +		features = (unsigned int *)match->data;
> +		palmas->features = *features;
> +	} else {
> +		return -ENODATA;
> +	}


I think it's more common to do the error-checking first. That way, the
success-case code doesn't need an indent:

match = of_match...(...);
if (!match)
    return -ENODATA;

features = ...;
palmas->features = *features;

