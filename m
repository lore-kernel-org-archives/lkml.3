Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3ISMHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:07:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9292 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3ISMH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:07:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Sep 2013 05:04:04 -0700
Message-ID: <523AEE07.9090405@nvidia.com>
Date: Thu, 19 Sep 2013 17:58:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com> <20130919083050.GH16984@lee--X1> <20130919115501.GM21013@sirena.org.uk> <20130919120051.GG22389@lee--X1>
In-Reply-To: <20130919120051.GG22389@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 September 2013 05:30 PM, Lee Jones wrote:
> On Thu, 19 Sep 2013, Mark Brown wrote:
>
>> On Thu, Sep 19, 2013 at 09:30:50AM +0100, Lee Jones wrote:
>>
>>> I'm not entirely sure this is what Mark was saying. I think he was
>>> complaining about the existence of the sub-nodes rather than how the
>>> MFD Core assigns their of_node. My take is that the chip is really a
>>> single device which provides different bits of functionality. To break
>>> that functionality up and disperse the drivers into various subsystems
>>> is a Linuxisum. By providing each functional block with its own node
>>> you're describing how we do things in Linux, rather than specifying a
>>> single node for the AS3722 which would probably be the norm.
>> Yes, that's exactly what I was thinking of.
>>
>>> Do the sub-nodes have their own properties? If so, it would be worth
>>> breaking them up as other OSes could reuse the specifics. If they do,
>>> then you need so put them in the binding. If they don't, then you do
>>> not require sub-nodes. The MFD core will ensure the sub-devices are
>>> probed and there is no requirement for the of_node to be assigned.
>> You do see some reusable IP blocks (like the regualtors on the wm831x
>> PMICs for example, they're repeated blocks) which can be reused but
>> generally they have a register base as part of the binding.  Personally
>> if it's just a property or two I'd probably just put them on the root
>> node for the device.
> Agreed. Besides, there doesn't seem to be *any* sub-device properties
> defined in the binding document. So what are you trying to achieve
> with the child nodes?
>

I wanted to have the DT like:

as3722 {
                 compatible = "ams,as3722";
                 reg = <0x40>;

                 #interrupt-controller;
                 .....


                 regulators {
                             ldo1-in-supply = <..>;
                             ....
                             sd0 {
                                     regulator-name = "vdd-cpu";
                                     .....
                             };
                             sd1 {
                                     regulator-name = "vdd-ddr";
                                     .....
                             };
                             ....
             };
};



And regulator driver should get the regulator node by their 
pdev->dev.of_node.
Currently, in most of driver, we are having the code on regulator driver 
to get "regulators" node from parent node which I want to avoid.





