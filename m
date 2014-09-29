Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaI2NLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:11:10 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61338 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaI2NLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:11:08 -0400
Message-ID: <54295A2F.3070700@i2se.com>
Date: Mon, 29 Sep 2014 15:10:07 +0200
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com> <20140929110919.GB2432@leverpostej> <54294832.8000702@i2se.com> <20140929124137.GD2432@leverpostej>
In-Reply-To: <20140929124137.GD2432@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:F/LnK8d0M71UR7mfALFUVn1wAZ4XxqtF1/wQhGDPS+Q
 Zy2ku46qZMSYa90MhPX4lqLNK7v92PgDpZZLTXEucLfCuzE9JW
 BOSE8YekiMli3Bdi2fA5HCnqcpjl6NAdivCtTfZ+uwj9RVHwiS
 nRzO7R9LGEqyERSRXpdAh47vgLio8GCgZEwO19i0+5nSQE2LYx
 Umk8hLewY7rMak3Ff3gJv5OwivNqs0ggnbvOUSK8d98B1rOOXQ
 /2zJqrTrQ6ILbfyU04UkGvsjAAej8KxTMBJB0+la+sVRcrOz/D
 vltOM89wCC2Hx9lCGD4fH+/P61j8s1jHe4jV7w1nm78Ih+7AYa
 X9Vy0SiBVdJGPwlRc/pI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 29.09.2014 um 14:41 schrieb Mark Rutland:
> Well, the simple-bus will cause the children to be probed. But it looks
> like you care about properties of the parent. I don't think that
> simple-bus is appropriate because it's not being handled as a
> transparent bridge from the PoV of the children.

actually i need the address of the power status register. In this
version i get the base address from the parent node add an offset.

Do you prefer to define the address of the power status register like a
second address cell:

reg_vddd: regulator@80044040 {
	reg = <0x80044040 0x10
	       0x800440c0 0x01>;
        ...
};

or do i need special properties like this:

reg_vddd: regulator@80044040 {
	reg = <0x80044040 0x10>;
	fsl,mxs-status-reg = <0x800440c0>;
        ...
};

>> Do we need a extra driver?
> Perhaps, but it's relatively simple to match on a compatible string and
> probe children if you just wantto start small for now.

Okay. Would be great if someone has a good example. At first, i thought
of power/anatop.

>
>>>> +- #address-cells: Number of cells required to define regulator register,
>>>> +  must be 1
>>>> +- #size-cells: Number of cells required to define register size, must be 1
>>> Why must this be the case, given that the child node expects an absolute
>>> physical address?
>> I need a property to define the control register for the regulators
>> without defining vendor specific properties like "fsl,mxs-control-reg"
>> or something.
> You misunderstand me. I was querying the "must be 1" rather than the
> proeprties themselves.
>
>>> What's wrong with #address-cells = <2>, for example?
>> Nothing
> Then we shouldn't specify "must be 1", no?

Right, must be at least 1.

>>>> +- reg: Absolute physical address and size of the register set for the device
>>> Why is this here _and_ in the child node(s)?
>> The parent of the power node is also a simple bus. I use this to
>> calculate the power status register per offset.
>>
>>> What is the difference between this node and its children?
>> The parent node represent the power sub system and the regulators are
>> part of this sub system.
>>
>>> Can there be more than one sub-node?
>> In the i.MX28 are at least 4 voltage regulators, 1 current regulator and
>> many more. At first, the driver should implement only 3 voltage
>> regulators (vddd, vdda, vddio).
> Ok.
>
> I think you need a binding for the power subsystem, and a trivial driver
> that can match on that and probe the child regulators. Are there
> components other than voltage or current regulators in the sub system?

Yes, according to the reference manual there is a dc-dc converter, a
battery charger, battery monitor, ...

In short a lot of developing time ;-)

> Mark.

Best regards

Stefan

