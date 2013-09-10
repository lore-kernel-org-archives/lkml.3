Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3IJDVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:21:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16739 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJDVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:21:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Sep 2013 20:21:30 -0700
Message-ID: <522E9059.3070305@nvidia.com>
Date: Tue, 10 Sep 2013 11:22:01 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-2-git-send-email-wni@nvidia.com> <20130909111242.GW29403@sirena.org.uk> <522DB253.6000707@roeck-us.net> <20130909135022.GZ29403@sirena.org.uk> <20130909155043.GA18975@roeck-us.net>
In-Reply-To: <20130909155043.GA18975@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 11:50 PM, Guenter Roeck wrote:
> On Mon, Sep 09, 2013 at 02:50:22PM +0100, Mark Brown wrote:
>> On Mon, Sep 09, 2013 at 04:34:43AM -0700, Guenter Roeck wrote:
>>> On 09/09/2013 04:12 AM, Mark Brown wrote:
>>>> On Mon, Sep 09, 2013 at 06:29:11PM +0800, Wei Ni wrote:
>>
>>>> This doesn't look good, it is going to ignore actual errors - I *really*
>>>> doubt that vcc is optional, it looks like it's the main power supply for
>>>> the device.  You should use normal regulator_get(), _optional() is for
>>>> supplies which could physically not be provided in a system (eg, if the
>>>> device can generate them internally if required).
>>
>>> Then he'll have to make sure that all devicetree files in the system
>>> contain references to this regulator.
>>
>> Or get the patches applied on top of the code that'll be going in this
>> cycle implementing get_optional() properly - when that's done the
>> default will be to provide a dummy supply for regulator_get().  If you
>> ack the patch I'd be happy to carry it.
>>
> Jean will have to ack it.
> 
I think it's better to use get_optional(), and ignore the errors except
-EPROBE_DEFER. Because many platform may always power on this device,
and will not provide regulator for it, so if we get errors from
regulator subsystem and return it directly, then the probe() can't be
implemented, this driver can't work properly, even though it can work
without regulator support.
Mark, do you mean you have patches for regulator_get_optional() and
regulator_get()?

Wei.

