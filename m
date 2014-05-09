Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaEIHMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:12:55 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52052 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaEIHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:12:53 -0400
Date: Fri, 9 May 2014 08:12:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 3/7] mfd: add support for sun6i PRCM
 (Power/Reset/Clock Management) unit
Message-ID: <20140509071246.GE5767@lee--X1>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com>
 <20140508110205.GB5767@lee--X1>
 <536BE366.8080907@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536BE366.8080907@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +static struct platform_driver sun6i_prcm_driver = {
> >> +	.driver = {
> >> +		.name = "sun6i-prcm",
> >> +		.owner = THIS_MODULE,
> >> +		.of_match_table = sun6i_prcm_dt_ids,
> >> +	},
> >> +	.probe = sun6i_prcm_probe,
> > You need a .remove() call-back.
> 
> This driver cannot be compiled as module (see the Kconfig definition)
> and the devices are not hotpluggable, as a result a probed device will
> never be removed.
> 
> Do you still want me to implement the remove function ?

.remove() also be run on shut down.  It's best practice to have one.

> >> +module_platform_driver(sun6i_prcm_driver);
> >> +
> >> +MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
> >> +MODULE_DESCRIPTION("Allwinner sun6i PRCM driver");
> >> +MODULE_LICENSE("GPL v2");
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
