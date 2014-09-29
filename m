Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaI2Lxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:53:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:63166 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaI2Lxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:53:44 -0400
Message-ID: <54294832.8000702@i2se.com>
Date: Mon, 29 Sep 2014 13:53:22 +0200
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
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com> <20140929110919.GB2432@leverpostej>
In-Reply-To: <20140929110919.GB2432@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:K/wZJejKX1I0U03IfKYdL4xhRKitQT0byx5nU1qYUOg
 7CrJHnsM22tKc/5sxnGxhTDW8/Uuk7UuIzS2oKcXNAf6QLm+2G
 wQ27oD/JAj6e8JNAMOu6plYUeedzDebs/DrnRVuELTfvDKofxE
 o7A9H5N1lBxbmprgqn2prmvajs3Ip7zhffyb5B8hJ+vPCAWrVR
 oouvwVYcqUWYlVCeF0C/UbQIm4LR6t8oSGXU1ohpNf2raSbR6Q
 syGdJK7FYuc9ilWTUEpbfq8KXLluj53wDopUz/2LqNK7BjL0TI
 siJgkJf26nB53MFNhiHVg3lnjh17xBKTQV6d14rr6rAbK8lRRQ
 MQXCtxOpIr+0QuSF+l6w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am 29.09.2014 um 13:09 schrieb Mark Rutland:
> On Sat, Sep 27, 2014 at 01:59:47AM +0100, Stefan Wahren wrote:
>> This patch adds the Device tree bindings for the Freescale MXS
>> on-chip regulators.
>>
>> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
>> ---
>>  .../bindings/regulator/mxs-regulator.txt           |   36 ++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt
>>
>> diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
>> new file mode 100644
>> index 0000000..e3133a4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
>> @@ -0,0 +1,36 @@
>> +MXS regulators
>> +
>> +Required node properties:
>> +- compatible: Should be "simple-bus"
> This does not look like an appropriate use of simple-bus.
>
> Why do you want the parent node to be a simple-bus?

the current parent node in imx28.dtsi looks like a placeholder for the
power sub system:

power: power@80044000 {
	reg = <0x80044000 0x2000>;
	status = "disabled";
};

I want to trigger the probing of the child nodes (regulators) without
writing a driver for the complete power sub system. The simple-bus
avoids that.

Do we need a extra driver?

>
>> +- #address-cells: Number of cells required to define regulator register,
>> +  must be 1
>> +- #size-cells: Number of cells required to define register size, must be 1
> Why must this be the case, given that the child node expects an absolute
> physical address?

I need a property to define the control register for the regulators
without defining vendor specific properties like "fsl,mxs-control-reg"
or something.

> What's wrong with #address-cells = <2>, for example?

Nothing

>
>> +- reg: Absolute physical address and size of the register set for the device
> Why is this here _and_ in the child node(s)?

The parent of the power node is also a simple bus. I use this to
calculate the power status register per offset.

> What is the difference between this node and its children?

The parent node represent the power sub system and the regulators are
part of this sub system.

> Can there be more than one sub-node?

In the i.MX28 are at least 4 voltage regulators, 1 current regulator and
many more. At first, the driver should implement only 3 voltage
regulators (vddd, vdda, vddio).

> Mark.
>

Best regards

Stefan
