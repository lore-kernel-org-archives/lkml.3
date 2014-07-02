Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaGBNrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:47:07 -0400
Received: from svenfoo.org ([82.94.215.22]:44312 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaGBNrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:47:05 -0400
Message-ID: <53B40D55.6000602@zonque.org>
Date: Wed, 02 Jul 2014 15:47:01 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>, linux-sound@vger.kernel.org
CC: devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        broonie@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3] ASoC: tas2552: Support TI TAS2552 Amplifier
References: <1404307852-10456-1-git-send-email-dmurphy@ti.com>
In-Reply-To: <1404307852-10456-1-git-send-email-dmurphy@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 07/02/2014 03:30 PM, Dan Murphy wrote:
> +	if (np) {
> +		data->power_gpio = of_get_named_gpio(np, "enable-gpio", 0);
> +	} else if (pdata) {
> +		data->power_gpio = pdata->enable_gpio;
> +	} else {
> +		dev_err(dev, "Platform or dev tree data not set\n");
> +		return -ENODEV;
> +	}

New code for GPIO handling should use the new gpiod interface.
See include/linux/gpio/consumer.h, or the sta350 codec driver.

For that to work, you also need to rename the property to
'enable-gpios', even though there's only one.


Daniel

