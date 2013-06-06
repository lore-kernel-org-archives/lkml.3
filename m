Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3FFPxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:53:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47271 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3FFPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:53:47 -0400
Message-ID: <51B0B085.7000908@wwwdotorg.org>
Date: Thu, 06 Jun 2013 09:53:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "J, KEERTHY" <j-keerthy@ti.com>
CC: "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "Kristo, Tero" <t-kristo@ti.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v2] mfd: DT bindings for the palmas family MFD
References: <1370335309-6319-1-git-send-email-j-keerthy@ti.com> <51AF71CA.8060808@wwwdotorg.org> <DC88CAD03C0052499C1907B327FC63229EA0E9@DBDE04.ent.ti.com>
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EA0E9@DBDE04.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 09:34 PM, J, KEERTHY wrote:
> Hi Stephen,
> 
> Thanks for the quick review.
> 
> Stephen Warren wrote at Wednesday, June 05, 2013 10:44 PM:
>> On 06/04/2013 02:41 AM, J Keerthy wrote:
>>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>>
>>> Add the various binding files for the palmas family of chips. There is
>>> a top level MFD binding then a seperate binding for regulators IP
>> blocks on chips.
...
>> Oh, one question though: How does the regulator driver determine the
>> register address of the regulator sub-device within the overall PMIC?
>> Presumably if these are pluggable independent modules, that could
>> change depending on which overall chip the PMIC device is plugged into.
>> don't you need a reg property to specify that?
> 
> The variants have identical register addresses. These are not pluggable
> Independent modules. All the variants come with all the regulators
> Listed above in general. The driver today has a statically defined
> Array of all the above mentioned regulators with their addresses.
>  
> drivers/regulator/palmas-regulator.c
> 
> Line 38.

I meant the I2C address used to communicate with the regulator registers
really, and I suppose the base address of the regulator register block.

In the driver, I see this is handled by the top-level Palmas driver
creating a regmap object which the regulator driver used. This keeps the
regulator driver completely unaware of these issues, only the top-level
chip driver cares about this, which is fine.

While that justification is in terms of OS-specific code, the basic
argument can be applied to the HW itself (the top-level chip implies the
I2C address and any register offset), so this really is a HW-driven
argument, so I guess it's fine not having a reg property in the
top-level regulator node.

One question though: I wonder why if the HW IP blocks aren't completely
independent modules that can be mixed/matched together to form new
chips, there's even a need for a separate regulator node with its own
compatible value. Still, I suppose it's a valid way to construct the DT
either way, so it's fine.
