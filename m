Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3IQMBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:01:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8023 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3IQMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:01:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 17 Sep 2013 04:58:24 -0700
Message-ID: <52384996.8050704@nvidia.com>
Date: Tue, 17 Sep 2013 17:52:46 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "florian.lobmaier@ams.com" <florian.lobmaier@ams.com>
Subject: Re: [PATCH 1/4] mfd: add support for AMS AS3722 PMIC
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com> <1379400338-20704-2-git-send-email-ldewangan@nvidia.com> <20130917112444.GU21013@sirena.org.uk> <5238450F.6090303@nvidia.com>
In-Reply-To: <5238450F.6090303@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 September 2013 05:33 PM, Laxman Dewangan wrote:
> On Tuesday 17 September 2013 04:54 PM, Mark Brown wrote:
>> * PGP Signed by an unknown key
>>
>> On Tue, Sep 17, 2013 at 12:15:35PM +0530, Laxman Dewangan wrote:
>>
>>> +MFD driver adds following mfd devices with their compatible values:
>>> +as3722-gpio: The compatible value of this as3722 gpio driver is
>>> +         "ams,as3722-gpio";
>>> +as3722-regulator: The compatible value of this as3722 regulator 
>>> driver is
>>> +         "ams,as3722-regulator";
>>> +as3722-rtc: The compatible value of this as3722 rtc driver is
>>> +         "ams,as3722-rtc";
>>> +as3722-adc: The compatible value of this as3722 adc driver is
>>> +         "ams,as3722-adc";
>>> +as3722-power-off: he compatible value of this as3722 power off 
>>> driver is
>>> +         "ams,as3722-power-off".
>> Personally I find this to be exposing implementation details of Linux -
>> unless there is something reusable about the binding that'd allow it to
>> be used to describe the contents of the chip the subnodes really aren't
>> adding any information that wasn't present from just knowing the parent
>> chip.  If there were relocatable IPs it'd be a bit different.
>
> Ok, then can we fix the the sub node name and parse these when adding 
> mfd devices and set the pdev->dev.of_node of child devices.
> Like
> parent_node {
>     ...
>     child1_node {
>         ...
>     };
>
>     child1_node {
Sorry, just wanted to say child2_node here.

> ...
>     };
> };
>
>
> and fix the node name of child1 and child2 and have this as part of 
> mfd-cell's of_node_name.
> So when we add the mfd devices, we look for these fixed name and if 
> matches then set the dev->of_node for that child sub device.
>
> This will avoid the code for getting child node pointer from parent 
> node in each driver. We fix the child node name in any case.
>
>

