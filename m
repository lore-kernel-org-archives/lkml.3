Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaDPRQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:16:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50665 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754727AbaDPRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:16:15 -0400
Message-ID: <534EBADE.1000608@free-electrons.com>
Date: Wed, 16 Apr 2014 19:16:14 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH] regmap: i2c: fallback to SMBus if the adapter does not
 support standard I2C
References: <20140415223849.GJ12304@sirena.org.uk> <1397636170-664-1-git-send-email-boris.brezillon@free-electrons.com> <20140416170638.GT12304@sirena.org.uk>
In-Reply-To: <20140416170638.GT12304@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 16/04/2014 19:06, Mark Brown wrote:
> On Wed, Apr 16, 2014 at 10:16:10AM +0200, Boris BREZILLON wrote:
>
>> +	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C)) {
>> +		return &regmap_i2c;
>> +	} else if (config->val_bits == 16 &&
>> +		   i2c_check_functionality(i2c->adapter,
>> +					   I2C_FUNC_SMBUS_WORD_DATA)) {
>> +                config->reg_read = regmap_smbus_word_reg_read;
>> +                config->reg_write = regmap_smbus_word_reg_write;
>> +		return NULL;
> This all looks good to me except we shouldn't be modifying the config
> struct (it's supposed to be const).  We should instead add the ability
> for the bus to set these ops - that'll also be useful for things like
> AC'97.

Actually I do not modify the passed config struct, I copy the config
values into a local instance and then modify this local instance
appropriately.
But I agree that having a proper way to overload config parameters would
be better.
Any suggestion on how this should be done ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

