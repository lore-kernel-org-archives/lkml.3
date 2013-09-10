Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3IJDkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:40:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42820 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJDke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:40:34 -0400
Message-ID: <522E94AE.7000804@wwwdotorg.org>
Date: Mon, 09 Sep 2013 21:40:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Wei Ni <wni@nvidia.com>, Mark Brown <broonie@kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-2-git-send-email-wni@nvidia.com> <20130909111242.GW29403@sirena.org.uk> <522DB253.6000707@roeck-us.net> <20130909135022.GZ29403@sirena.org.uk> <20130909155043.GA18975@roeck-us.net> <522E9059.3070305@nvidia.com> <522E93D6.2010304@roeck-us.net>
In-Reply-To: <522E93D6.2010304@roeck-us.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 09:36 PM, Guenter Roeck wrote:
> On 09/09/2013 08:22 PM, Wei Ni wrote:
>> On 09/09/2013 11:50 PM, Guenter Roeck wrote:
>>> On Mon, Sep 09, 2013 at 02:50:22PM +0100, Mark Brown wrote:
>>>> On Mon, Sep 09, 2013 at 04:34:43AM -0700, Guenter Roeck wrote:
>>>>> On 09/09/2013 04:12 AM, Mark Brown wrote:
>>>>>> On Mon, Sep 09, 2013 at 06:29:11PM +0800, Wei Ni wrote:
>>>>
>>>>>> This doesn't look good, it is going to ignore actual errors - I
>>>>>> *really*
>>>>>> doubt that vcc is optional, it looks like it's the main power
>>>>>> supply for
>>>>>> the device.  You should use normal regulator_get(), _optional() is
>>>>>> for
>>>>>> supplies which could physically not be provided in a system (eg,
>>>>>> if the
>>>>>> device can generate them internally if required).
>>>>
>>>>> Then he'll have to make sure that all devicetree files in the system
>>>>> contain references to this regulator.
>>>>
>>>> Or get the patches applied on top of the code that'll be going in this
>>>> cycle implementing get_optional() properly - when that's done the
>>>> default will be to provide a dummy supply for regulator_get().  If you
>>>> ack the patch I'd be happy to carry it.
>>>>
>>> Jean will have to ack it.
>>>
>> I think it's better to use get_optional(), and ignore the errors except
>> -EPROBE_DEFER. Because many platform may always power on this device,
>> and will not provide regulator for it, so if we get errors from
>> regulator subsystem and return it directly, then the probe() can't be
>> implemented, this driver can't work properly, even though it can work
>> without regulator support.
>> Mark, do you mean you have patches for regulator_get_optional() and
>> regulator_get()?
>>
> 
> My understanding is that by adding regulator support you essentially
> committed to adding regulators (if necessary dummy ones) for this driver
> to all those platforms. This is quite similar to other drivers in the
> same situation. Once you start along that route, you'll have to go it
> all the way.

By using regulator_get_optional(), the regulator should be optional,
hence you only have to add it to platforms that need it.

