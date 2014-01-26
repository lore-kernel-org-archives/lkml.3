Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaAZVkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:40:35 -0500
Received: from mail.active-venture.com ([67.228.131.205]:49762 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:40:34 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E580CE.8080100@roeck-us.net>
Date: Sun, 26 Jan 2014 13:40:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jean Delvare <khali@linux-fr.org>
CC: LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Wei Ni <wni@nvidia.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
References: <52E561D0.4040308@roeck-us.net> <20140126211357.6fa68909@endymion.delvare> <52E573B6.9040903@roeck-us.net> <20140126214936.7736f530@endymion.delvare> <20140126212256.GK11727@sirena.org.uk>
In-Reply-To: <20140126212256.GK11727@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 01:22 PM, Mark Brown wrote:
> On Sun, Jan 26, 2014 at 09:49:36PM +0100, Jean Delvare wrote:
>> On Sun, 26 Jan 2014 12:44:38 -0800, Guenter Roeck wrote:
>
>>> Maybe there is some configuration option, or maybe something needs to be
>>> configured from user space. I found neither.
>
>> Neither would be acceptable to my eyes anyway. Things worked out of the
>> box before, they should keep working out of the box.
>
> They only worked with a debug option turned on and generated warnings
> every time they were used...  that kernel config would've been actively
> broken for devices that wanted to do anything at all interesting with
> the regulators and would've been prone to issues with init ordering and
> races in any cases where there are actually regulators.
>
>>> Another possible fix would be to have the regulator core return -ENODEV
>>> instead of -EPROBE_DEFER on non-dt systems. No idea if this would be acceptable
>>> or even feasible.
>
>> Well, either the regulator subsystem gets fixed (or provides a suitable
>> API for drivers like lm90 and we update the lm90 driver to use it), or
>> I'll just revert the problematic commit for now. This is a severe
>> regression, we just can't leave things that way.
>
> It's not an issue in the driver, it's an issue in the combination of the
> platform and the kernel config.  If the regulator API is going to be
> turned on for the platform then either the platform needs to configure
> the supplies or it needs to tell the regulator core that it's safe to
> start using dummy regulators.
>
> What is this platform and why does it have the regulator API enabled in
> the first place?
>

It is a PC running Ubuntu. you'd have to ask the distro maintainers why they
turn on regulators.

config-3.8.0-26-generic:CONFIG_REGULATOR=y
config-3.8.0-35-generic:CONFIG_REGULATOR=y
config-3.11.0-13-generic:CONFIG_REGULATOR=y

Guenter

