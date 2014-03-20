Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaCTFT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:19:26 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:24434
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbaCTFTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:19:23 -0400
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Henrik Rydberg" <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        "Mark Rutland" <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Budig <simon.budig@kernelconcepts.de>
Subject: RE: [PATCHv4 2/5] Input: edt-ft5x06: Add DT support
Thread-Topic: [PATCHv4 2/5] Input: edt-ft5x06: Add DT support
Thread-Index: AQHPQ3SIiQdBVrJHfUKTZpUIUin2yJroYfcAgAEM6iA=
Date: Thu, 20 Mar 2014 05:19:03 +0000
Message-ID: <c9718f7215eb41439606b0107a8e2a02@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
 <1395234563-11034-3-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1395234563-11034-3-git-send-email-LW@KARO-electronics.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(377454003)(97186001)(51856001)(19580405001)(19580395003)(83322001)(56776001)(50986001)(81686001)(2201001)(81816001)(85852003)(83072002)(74366001)(90146001)(56816005)(92566001)(74316001)(54356001)(80976001)(4396001)(53806001)(47446002)(74662001)(31966008)(97336001)(49866001)(74502001)(93136001)(47736001)(54316002)(47976001)(76786001)(76796001)(76576001)(76482001)(46102001)(85306002)(74706001)(2656002)(74876001)(77982001)(59766001)(69226001)(94946001)(81542001)(87936001)(66066001)(79102001)(86362001)(95666003)(94316002)(80022001)(87266001)(65816001)(63696002)(20776003)(95416001)(81342001)(33646001)(93516002)(1121002)(921003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB373;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:A8FBCAD2.A0C0B418.7DFB9B0F.C8D7DA72.2041D;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2K5JpeB019472

From: Lothar WaÃŸmann <LW@KARO-electronics.de>
Data: Wednesday, March 19, 2014 9:09 PM

>To: Dmitry Torokhov; Duan Fugang-B38611; Grant Likely; Henrik Rydberg; Ian
>Campbell; Jingoo Han; Kumar Gala; Mark Rutland; Pawel Moll; Rob Herring; Rob
>Landley; Sachin Kamat; devicetree@vger.kernel.org; linux-doc@vger.kernel.org;
>linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Simon Budig; Lothar
>WaÃŸmann
>Subject: [PATCHv4 2/5] Input: edt-ft5x06: Add DT support
>
>
>Signed-off-by: Lothar WaÃŸmann <LW@KARO-electronics.de>
>---
> .../bindings/input/touchscreen/edt-ft5x06.txt      |   41 ++++++
> drivers/input/touchscreen/edt-ft5x06.c             |  144 +++++++++++++++-----
> 2 files changed, 154 insertions(+), 31 deletions(-)  create mode 100644
>Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
>
>diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
>b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
>new file mode 100644
>index 0000000..e5adc76
>--- /dev/null
>+++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
>@@ -0,0 +1,41 @@
>+FocalTech EDT-FT5x06 Polytouch driver
>+=====================================
>+
>+Required properties:
>+ - compatible:  "edt,edt-ft5x06"
>+ - reg:         I2C slave address of the chip (0x38)
>+ - interrupt-parent: a phandle pointing to the interrupt controller
>+                     serving the interrupt for this chip
>+ - interrupts:       interrupt specification for this chip
>+
>+Optional properties:
>+ - reset-gpios: GPIO specification for the RESET input
>+ - wake-gpios:  GPIO specification for the WAKE input
>+
>+ - pinctrl-names: should be "default"
>+ - pinctrl-0:   a phandle pointing to the pin settings for the
>+                control gpios
>+
>+ - threshold:   allows setting the "click"-threshold in the range
>+                from 20 to 80.
>+
>+ - gain:        allows setting the sensitivity in the range from 0 to
>+                31. Note that lower values indicate higher
>+                sensitivity.
>+
>+ - offset:      allows setting the edge compensation in the range from
>+                0 to 31.
>+ - report_rate: allows setting the report rate in the range from 3 to
>+                14.
>+
>+Example:
>+	polytouch: edt-ft5x06@38 {
>+		compatible = "edt,edt-ft5x06";
>+		reg = <0x38>;
>+		pinctrl-names = "default";
>+		pinctrl-0 = <&edt_ft5x06_pins>;
>+		interrupt-parent = <&gpio2>;
>+		interrupts = <5 0>;
>+		reset-gpios = <&gpio2 6 1>;
>+		wake-gpios = <&gpio4 9 0>;
>+	};
>diff --git a/drivers/input/touchscreen/edt-ft5x06.c
>b/drivers/input/touchscreen/edt-ft5x06.c
>index 7b4470d..257a1c8 100644
>--- a/drivers/input/touchscreen/edt-ft5x06.c
>+++ b/drivers/input/touchscreen/edt-ft5x06.c
>@@ -33,6 +33,7 @@
> #include <linux/debugfs.h>
> #include <linux/slab.h>
> #include <linux/gpio.h>
>+#include <linux/of_gpio.h>
> #include <linux/input/mt.h>
> #include <linux/input/edt-ft5x06.h>
>
[...]
>+#ifdef CONFIG_OF
>+static int edt_ft5x06_i2c_ts_probe_dt(struct device *dev,
>+				struct edt_ft5x06_ts_data *tsdata)
>+{
>+	struct device_node *np = dev->of_node;
>+
>+	if (!np)
>+		return -ENODEV;
Don't need to check the device node valid. If the device node is not existed, the driver don't run probe.

>+
>+	/*
>+	 * irq_pin is not needed for DT setup.
>+	 * irq is associated via 'interrupts' property in DT
>+	 */
>+	tsdata->irq_pin = -EINVAL;
>+	tsdata->reset_pin = of_get_named_gpio(np, "reset-gpios", 0);
>+	tsdata->wake_pin = of_get_named_gpio(np, "wake-gpios", 0);
>+
>+	return 0;
>+}
>+#else
>+static inline int edt_ft5x06_i2c_ts_probe_dt(struct device *dev,
>+					struct edt_ft5x06_i2c_ts_data *tsdata) {
>+	return -ENODEV;
>+}
>+#endif
>+
> static int edt_ft5x06_ts_probe(struct i2c_client *client,
> 					 const struct i2c_device_id *id)
> {
>@@ -714,32 +775,40 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
>
> 	dev_dbg(&client->dev, "probing for EDT FT5x06 I2C\n");
>
>+	tsdata = devm_kzalloc(&client->dev, sizeof(*tsdata), GFP_KERNEL);
>+	if (!tsdata) {
>+		dev_err(&client->dev, "failed to allocate driver data.\n");
>+		return -ENOMEM;
>+	}
>+
> 	if (!pdata) {
>-		dev_err(&client->dev, "no platform data?\n");
>-		return -EINVAL;
>+		error = edt_ft5x06_i2c_ts_probe_dt(&client->dev, tsdata);
>+		if (error) {
>+			dev_err(&client->dev,
>+				"DT probe failed and no platform data present\n");
>+			return error;
>+		}
>+	} else {
>+		tsdata->reset_pin = pdata->reset_pin;
>+		tsdata->irq_pin = pdata->irq_pin;
>+		tsdata->wake_pin = -EINVAL;
> 	}
[...]

Thanks,
Andy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
