Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3IILer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:34:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59546 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3IILep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:34:45 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522DB253.6000707@roeck-us.net>
Date: Mon, 09 Sep 2013 04:34:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-2-git-send-email-wni@nvidia.com> <20130909111242.GW29403@sirena.org.uk>
In-Reply-To: <20130909111242.GW29403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 04:12 AM, Mark Brown wrote:
> On Mon, Sep 09, 2013 at 06:29:11PM +0800, Wei Ni wrote:
>
>> +	reg = devm_regulator_get_optional(dev, "vcc");
>> +	if (!IS_ERR(reg)) {
>> +		err = regulator_enable(reg);
>> +		if (err < 0) {
>> +			dev_err(&client->dev,
>> +				"Failed to enable regulator: %d\n", err);
>> +			return err;
>> +		}
>> +		msleep(25);
>> +	} else {
>> +		if (PTR_ERR(reg) == -EPROBE_DEFER)
>> +			return -EPROBE_DEFER;
>> +	}
>
> This doesn't look good, it is going to ignore actual errors - I *really*
> doubt that vcc is optional, it looks like it's the main power supply for
> the device.  You should use normal regulator_get(), _optional() is for
> supplies which could physically not be provided in a system (eg, if the
> device can generate them internally if required).
>
Then he'll have to make sure that all devicetree files in the system contain references
to this regulator.

> Also do you really need 25ms after power on?
>
I had not noticed, but I recommend to reject the patch because of it. If we add 25ms delay to each driver,
booting the system will take as long as booting windows. If enabling the regulator needs time,
the regulator subsystem should do it.

Guenter

