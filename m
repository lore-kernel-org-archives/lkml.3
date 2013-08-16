Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3HPGkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 02:40:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36127 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3HPGkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 02:40:32 -0400
From: "Kozaruk, Oleksandr" <oleksandr.kozaruk@ti.com>
To: Jonathan Cameron <jic23@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "ch.naveen@samsung.com" <ch.naveen@samsung.com>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Kim, Milo" <Milo.Kim@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v8 0/2] TWL6030, TWL6032 GPADC driver
Thread-Topic: [PATCH v8 0/2] TWL6030, TWL6032 GPADC driver
Thread-Index: AQHOmZePlU54UJBg2Ui+gbUHbnKlYJmV+U4AgAAgbgCAAFPUAIAA9Q2L
Date: Fri, 16 Aug 2013 06:39:35 +0000
Message-ID: <2A7ABDFCE21540479A5AEB0244A684D5E3EE9C@DNCE04.ent.ti.com>
References: <1374758813-6539-1-git-send-email-oleksandr.kozaruk@ti.com>
 <20130815091216.GB28366@e106331-lin.cambridge.arm.com>
 <520CB566.2050201@kernel.org>
 <20130815125906.GA32421@e106331-lin.cambridge.arm.com>,<520D16EC.90604@kernel.org>
In-Reply-To: <520D16EC.90604@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.41]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On 08/15/13 13:59, Mark Rutland wrote:
>> On Thu, Aug 15, 2013 at 12:03:02PM +0100, Jonathan Cameron wrote:
>>>
>>>>> The changes to the original driver:
>>>>> - device tree adaptation;
>>>>
>>>> I couldn't see a binding document in this series or in mainline. Have I
>>>> looked in the wrong places?
>>>
>>> Nothing explicit supplied, but does it need one given it is doing only
>>> iio bindings (bindings/iio/iio-bindings.txt)
>>> plus twl child bindings
>>> (bindings/mfd/twl-family.txt)
>>
>> Every binding needs to be documented.
>>
>>>
>>> If it does, I guess absolutely everything does, then fair enough!
>>> I guess that would make sense as there is no way for someone writing
>>> a device tree to know that there is nothing else to be specified.
>>
>> Yup, that's why. Also, Linux isn't necessarily the only consumer, and
>> other consumers shouldn't need to read Linux code to figure out how a
>> particular binding is supposed to look.
>>
>Fair enough. Thanks for clearing that up.
>
>Oleksandr, could you send a follow up patch adding the required documentation?
>(mostly a cut and paste job from similar elements by the look of it).
>

Hello,

Is this good enough?

>From 211e81ff4a146d9ec27443696a429e795c58dc30 Mon Sep 17 00:00:00 2001
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Date: Thu, 15 Aug 2013 16:14:11 +0300
Subject: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC

Add required documentation for twl6030 GPADC device tree
bindings.

Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
---
 .../devicetree/bindings/iio/adc/twl6030-gpadc.txt          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt

diff --git a/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
new file mode 100644
index 0000000..6829420
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
@@ -0,0 +1,14 @@
+Texas Instruments twl6030/twl6032 GPADC device driver
+
+Required properties:
+       - compatible: must be "ti,twl6030-gpadc" for TWL6030 or
+         "ti,twl6032-gpadc" for TWL6032
+       - interrupts: interrupt number associated with it
+       - #io-channel-cells: must be <1> - multiple IIO outputs
+
+Example:
+       adc {
+               compatible = "ti,twl6030-gpadc";
+               interrupts = <3>;
+               #io-channel-cells = <1>;
+       };

-- 
1.8.1.2

