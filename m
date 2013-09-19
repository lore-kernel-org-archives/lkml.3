Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3ISIgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:36:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11625 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3ISIgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:36:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Sep 2013 01:32:52 -0700
Message-ID: <523ABC85.5030607@nvidia.com>
Date: Thu, 19 Sep 2013 14:27:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com> <20130919083050.GH16984@lee--X1>
In-Reply-To: <20130919083050.GH16984@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 September 2013 02:00 PM, Lee Jones wrote:
> On Thu, 19 Sep 2013, Laxman Dewangan wrote:
>
>> Multi Function Devices (MFDs) have multiple sub module whose driver is
>> developed in different sub-system like GPIO, regulators, RTC, clock etc.
>> The device tree of such device contains multiple sub-node which contains
>> the properties of these sub-modules.
>>
>> The sub module gets of_node handle either by the dev->of_node or by getting
>> the child node handle from parent DT handle by finding child name on parent's
>> of_node.
>>
>> To provide the of_node of sub-module directly, currently there is only one
>> approach:
>> - Add compatible value when defining the sub-module in mfd core and
>>    add this properties when adding DT.
>>
>> Introduce the of_node_name of each sub devices which is set when defining
>> the mfd_cells of the sub devices and get the handle of these child node
>> when adding the mfd_devices by getting the sub-node handle with matching
>> the node name getting the sub-node handle with matching the node name.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>> Creating this patch based on the discussion on patch
>> [PATCH 1/4] mfd: add support for AMS AS3722 PMIC
>> The discussion on above patch is not concluded and want to have
>> further discussion on this patch.
> I'm not entirely sure this is what Mark was saying. I think he was
> complaining about the existence of the sub-nodes rather than how the
> MFD Core assigns their of_node.

Yes, Mark is only saying that he is not comfortable with the compatible 
until it is ip based driver.
I wanted to continue the discussion to find out the acceptable way so 
that I can use this in as3722 driver.

I added the of_node_name because each sub-driver gets its sub node by 
finding child node name from parent and hence duplicated the code on 
each driver.


