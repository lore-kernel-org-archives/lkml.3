Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965854Ab3HHPVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:21:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59922 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965802Ab3HHPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:21:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5203B78C.7010101@roeck-us.net>
Date: Thu, 08 Aug 2013 08:21:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Wei Ni <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        khali@linux-fr.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-2-git-send-email-wni@nvidia.com> <20130808110136.GA6427@sirena.org.uk> <52038035.7030803@roeck-us.net> <20130808130840.GC6427@sirena.org.uk>
In-Reply-To: <20130808130840.GC6427@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 06:08 AM, Mark Brown wrote:
> On Thu, Aug 08, 2013 at 04:25:41AM -0700, Guenter Roeck wrote:
>> On 08/08/2013 04:01 AM, Mark Brown wrote:
>
>>> That said if you *are* going to do this you should request the
>>> regulator using devm_regulator_get_optional(), this is intended to
>>> support things that don't need regulators (though that's not the case
>>> here).
>
>> The lm90 driver works perfectly fine without regulator.
>
> I'd be most surprised if the device worked without power, if the driver
> fails to get and enable a regulator for it then that's not great
> (especially if it does so silently).
>
Correct, but it appears that the driver magically worked for a long time
without it.

Is it guaranteed that the driver keeps working for all cases where
regulator support is enabled in the kernel, and where it used to work
so far without mandating the existence of this specific regulator ?
My main concern is having to deal with complaints that the driver stopped
working for no good reason.

In this context, is it common practice to name such regulators "vdd"
or similar ? What if there are multiple LM90 or compatible chips
in a system, connected to different power rails ? Who determines
if the regulator is supposed to be named "vdd" or "vcc" or anything
else, and to which power rails it is actually connected ? How can
and does one guarantee that "vdd" is the correct regulator to use
for all systems ? What if some other driver requests "vdd", but the chip
it supports happens to be connected to a different power rail ?

Sorry for my ignorance in that matter. I did browse through Documentation/power,
but did not find a clear answer.

> Note that the regulator API is written to stub itself out if not
> enabled, the code should be able to assume that it's there.
>
I am aware of that; this is why the driver should not dump an error message
if the function returns NULL and bail out, as it did originally.

Guenter

