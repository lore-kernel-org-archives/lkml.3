Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaHMJw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:52:28 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9554 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMJw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:52:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Aug 2014 02:39:08 -0700
Message-ID: <53EB3556.9010504@nvidia.com>
Date: Wed, 13 Aug 2014 12:52:22 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/3] Thermal reset support in PMC
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com> <20140813080744.GD7735@ulmo> <53EB1DF5.301@nvidia.com> <53EB250D.5070207@nvidia.com> <20140813085728.GF7735@ulmo>
In-Reply-To: <20140813085728.GF7735@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 11:57, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Aug 13, 2014 at 11:42:53AM +0300, Mikko Perttunen wrote:
>>
>>
>> On 13/08/14 11:12, Mikko Perttunen wrote:
>>> On 13/08/14 11:07, Thierry Reding wrote:
>>>>> Old Signed by an unknown key
>>>>
>>>> On Tue, Aug 05, 2014 at 11:12:57AM +0300, Mikko Perttunen wrote:
>>>>> Hi,
>>>>>
>>>>> this series adds support for hardware-triggered thermal reset to the PMC
>>>>> driver. Namely, it adds device tree properties for specifying the I2C
>>>>> command to be sent when thermtrip is triggered. It is to be noted
>>>>> that thermtrip won't be ever triggered without a soctherm driver to
>>>>> calibrate the sensors, but I'll follow up with that patch.
>>>>>
>>>>> pmc.c required some juggling around to make the match data usable in
>>>>> probe, since I didn't want to put the code into the initcall either, since
>>>>> the soctherm driver won't be initialized by that point anyway.
>>>>>
>>>>> Series tested on Jetson-TK1. Should work on Tegra30 and Tegra114 too.
>>>>
>>>> Can you describe the procedure used to test this? We currently have a
>>>> bunch of features in Tegra that some people have tested at some point
>>>> during development but the test procedures never got documented. That
>>>> means whenever we want to test something we need to go and reinvent a
>>>> bunch of tests after the fact.
>>>>
>>>> So what I'd like to start doing is collect tests (preferably in some
>>>> scripted way) so that they can be kept in a repository that people can
>>>> easily clone and run on devices.
>>>>
>>>> Could you provide something like that for thermtrip?
>>>
>>> Sure. I'll see if I can make a just a test script or if a local patch is
>>> needed to test. Btw, I also have a pretty nice test script for EMC
>>> ready, and I agree that such a repository would be very nice.
>>
>> Here is a test program. It it works, the device with immediately shut down.
>>
>> https://gist.github.com/cyndis/66126c9c176b5f94a76f
>
> Is there a way to set the trip temperature without going through
> /dev/mem? I'd expect the device to have a sysfs interface of some
> sort.

The thermtrip "device" isn't currently exposed in any way. If it were 
exposed, I suppose it would be exposed as thermal zone devices, each 
with one trip point. Even then, the thermal framework doesn't really 
support this properly; none of the trip point types really apply to this 
kind of trip point, and x86 systems don't expose their trips either. 
Anyway, since debugging is pretty much the only use case for modifying 
the trip temperature, I thought adding the tz_devices would be a bit 
overkill.

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>
