Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635Ab3GaRQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:16:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760492Ab3GaRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:16:44 -0400
Message-ID: <51F94677.80300@wwwdotorg.org>
Date: Wed, 31 Jul 2013 11:16:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: Nishanth Menon <nm@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
References: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>  <51F7BCEC.9080803@ti.com> <1375251767.32701.5.camel@bilhuang-vm1>
In-Reply-To: <1375251767.32701.5.camel@bilhuang-vm1>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 12:22 AM, Bill Huang wrote:
> On Tue, 2013-07-30 at 21:17 +0800, Nishanth Menon wrote:
>> On 07/30/2013 07:05 AM, Bill Huang wrote:
>>> Hook up "pm_power_off" to palmas power off routine if there is DT
>>> property "ti,system-power-controller" defined, so platform which is
>>> powered by this regulator can be powered off properly.
>>>
>>> Based on work by:
>>> Mallikarjun Kasoju <mkasoju@nvidia.com>
>>>
>>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>>> cc: Mallikarjun Kasoju <mkasoju@nvidia.com>
>>> ---
>>>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++++
>>>   drivers/mfd/palmas.c                               |   23 ++++++++++++++++++--
>>>   include/linux/mfd/palmas.h                         |    1 +
>> any reason why it wont fit in drivers/power/reset/ is'nt it the right 
>> place to add this?
>>>   3 files changed, 27 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>> index 30b0581..4adca2a 100644
>>> --- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>> +++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
>>> @@ -36,6 +36,9 @@ Optional nodes:
>>>   	       ti,smps-range - OTP has the wrong range set for the hardware so override
>>>   	       0 - low range, 1 - high range.
>>>
>>> +- ti,system-power-controller: Telling whether or not this pmic is controlling
>> controller or master?
> 
> We name it controller since it controls the system power of the
> platform, I'm not sure will it make more sense to be master? Or does it
> makes sense to other pmic which also control the system power (the same
> property are already used in pmic TPS6586x and TPS65910).

The property name quoted above is probably the best choice since it's
consistent with other properties that do the exact same thing in other
bindings.

