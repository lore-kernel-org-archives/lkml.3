Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaBZFM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:12:27 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13010 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaBZFMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:12:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Feb 2014 21:09:43 -0800
Message-ID: <530D77B0.8080807@nvidia.com>
Date: Wed, 26 Feb 2014 14:12:16 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393237593-28121-1-git-send-email-acourbot@nvidia.com> <530B952D.2000006@wwwdotorg.org> <530BFC58.6020003@nvidia.com> <530D1B7A.9070209@wwwdotorg.org> <530D748D.6010802@nvidia.com> <530D754A.60700@wwwdotorg.org>
In-Reply-To: <530D754A.60700@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 02:02 PM, Stephen Warren wrote:
> On 02/25/2014 09:58 PM, Alexandre Courbot wrote:
>> On 02/26/2014 07:38 AM, Stephen Warren wrote:
>>> On 02/24/2014 07:13 PM, Alexandre Courbot wrote:
>>>> On 02/25/2014 03:53 AM, Stephen Warren wrote:
>>>>> On 02/24/2014 03:26 AM, Alexandre Courbot wrote:
>>>>>> Add a device tree for NVIDIA SHIELD. The set of enabled features is
>>>>>> still minimal with no display option (although HDMI should be easy
>>>>>> to get to work) and USB requiring external power.
> ...
>>>> For the Wifi chip, non-removable would be the correct setting
>>>> hardware-wise, but there is a trap: the chip has its reset line asserted
>>>> at boot-time, and you need to set GPIO 229 to de-assert it. Only after
>>>> that will the device be detected on the SDIO bus. Since it lacks a CD
>>>> line, it must be polled, hence the broken-cd property.
>>>
>>> How does that GPIO get manipulated right now? I assume you must be
>>> manually configuring it via sysfs after boot or something? If so,
>>> perhaps it's best to just leave out the WiFi node until it works
>>> automatically.
>>
>> The GPIO needs to be set from user-space, yes. But if we leave the Wifi
>> node out, I'm concerned that wireless will not be usable at all,
>> wouldn't it?
>
> True, but if we have no representation of the device in DT that works
> without manually enabling clocks and/or GPIOs, it's not a
> complete/accurate representation of the HW, so it doesn't make sense to
> add it to DT. Yes, I admit that sucks.

Well, I can always enable it in my out-of-tree branch until we can push 
the complete binding in mainline, so I'm ok with taking it out of this 
patch for now.
