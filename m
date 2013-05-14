Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3ENJxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:53:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45065 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:53:50 -0400
Message-ID: <5192099B.4000203@ti.com>
Date: Tue, 14 May 2013 12:53:31 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Enric Balletbo Serra <eballetbo@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-omap@vger.kernel.org>, <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH] spi: spi-omap2-mcspi.c: Add dts for slave device configuration.
References: <1364252415-3613-1-git-send-email-matthias.bgg@gmail.com> <CAB=otbTtRN9xyO0whNz-UbW+Xo0_X8XWLcWZt=7MfUfrnNqwww@mail.gmail.com>
In-Reply-To: <CAB=otbTtRN9xyO0whNz-UbW+Xo0_X8XWLcWZt=7MfUfrnNqwww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -745,6 +781,11 @@ static int omap2_mcspi_setup_transfer(struct
> spi_device *spi,
>          mcspi = spi_master_get_devdata(spi->master);
>          spi_cntrl = mcspi->master;
>
> +       if (!cd && spi->dev.of_node) {
> +               cd = omap2_mcspi_get_slave_ctrldata(spi);
 > +               spi->controller_data = cd;

Here you call omap2_mcspi_get_slave_ctrldata function that allocate 
memory for cd structure, but this memory never freed.

Also, why do you read DT data in omap2_mcspi_setup_transfer function?
Under certain conditions the omap2_mcspi_setup_transfer function may be 
calling for each transfer and each call it will check (!cd && 
spi->dev.of_node) condition.

Consider to move DT data read code from omap2_mcspi_setup_transfer to
omap2_mcspi_setup function and free spi->controller_data pointer in 
omap2_mcspi_cleanup function.

