Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaDRRIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:08:21 -0400
Received: from smtp-out-082.synserver.de ([212.40.185.82]:1203 "EHLO
	smtp-out-073.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753862AbaDRRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:08:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8753
Message-ID: <53515BFA.3060601@metafoo.de>
Date: Fri, 18 Apr 2014 19:08:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 2/2] regmap: i2c: fallback to SMBus if the adapter
 does not support standard I2C
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com> <1397727612-32103-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1397727612-32103-3-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
> +					    const struct regmap_config *config)
> +{
> +	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C))
> +		return &regmap_i2c;
> +	else if (config->val_bits == 16 &&
> +		 i2c_check_functionality(i2c->adapter,
> +					 I2C_FUNC_SMBUS_WORD_DATA))
> +		return &regmap_smbus_word;
> +	else if (config->val_bits == 8 &&
> +		 i2c_check_functionality(i2c->adapter,
> +					 I2C_FUNC_SMBUS_BYTE_DATA))
> +		return &regmap_smbus_byte;

The fallback code should also check that reg_bits is 8.

> +
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +

