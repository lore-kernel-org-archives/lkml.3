Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaCTK6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:58:47 -0400
Received: from mail.mycable.de ([46.4.59.52]:55974 "EHLO mail.mycable.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbaCTK6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:58:45 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 06:58:44 EDT
Message-ID: <532AC81E.90303@mycable.de>
Date: Thu, 20 Mar 2014 11:51:10 +0100
From: Michael Stickel <ms@mycable.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Guenter Roeck <linux@roeck-us.net>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH v3 6/7] OF: spi: Add overlay bus handler
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com> <1395179766-31575-7-git-send-email-pantelis.antoniou@konsulko.com>
In-Reply-To: <1395179766-31575-7-git-send-email-pantelis.antoniou@konsulko.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.03.2014 22:56, schrieb Pantelis Antoniou:
> Add the bus handler registration needed for performing overlays
> containing spi devices.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  drivers/spi/spi.c | 345 ++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 242 insertions(+), 103 deletions(-)
> 

nc is not set in of_register_spi_device and causes an Oops.
Using nc = node works.
What is the purpose of nc?

> +of_register_spi_device(struct spi_master *master, struct device_node *node)
> +{
> +	struct spi_device *spi;
> +	struct device_node *nc;
> +	int err;
> +	u32 value;
> +
> +	/* Alloc an spi_device */
> +	spi = spi_alloc_device(master);
> +	if (!spi) {
> +		dev_err(&master->dev, "spi_device alloc error for %s\n",
> +			nc->full_name);
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/* Select device driver */
> +	err = of_modalias_node(nc, spi->modalias,
> +				sizeof(spi->modalias));
> +	if (err) {
> +		dev_err(&master->dev, "cannot find modalias for %s\n",
> +			nc->full_name);
> +		goto err_out;
> +	}



