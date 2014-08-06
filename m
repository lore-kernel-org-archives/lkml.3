Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaHFN4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:56:10 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:54995
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbaHFN4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:56:08 -0400
From: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] Thermal: imx: add i.mx6sx thermal support
Thread-Topic: [PATCH V3] Thermal: imx: add i.mx6sx thermal support
Thread-Index: AQHPsXnNYrfvsjTMKEaTnc6NXQi/hpvDmWDX
Date: Wed, 6 Aug 2014 13:56:04 +0000
Message-ID: <BB5DFDE4-B15E-445C-A406-A4EB0AE962F6@freescale.com>
References: <1407309129-5562-1-git-send-email-b20788@freescale.com>,<CAC-25o8BiKHYAD6=_5xAP5L310bH_GjwVQpqBYC7UydvbaxeqQ@mail.gmail.com>
In-Reply-To: <CAC-25o8BiKHYAD6=_5xAP5L310bH_GjwVQpqBYC7UydvbaxeqQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [139.227.112.148]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199002)(51704005)(377454003)(24454002)(76104003)(377424004)(43784003)(45984002)(54356999)(21056001)(81542001)(76176999)(36756003)(50986999)(82746002)(99396002)(76482001)(83716003)(101416001)(1411001)(19580405001)(83322001)(19580395003)(77982001)(33656002)(81342001)(79102001)(80022001)(575784001)(66066001)(92726001)(46102001)(83072002)(20776003)(85852003)(64706001)(92566001)(86362001)(2351001)(107046002)(77096002)(2656002)(95666004)(85306004)(105586002)(106116001)(4396001)(87936001)(106356001)(74502001)(31966008)(110136001)(74662001)(104396001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0628;H:BN1PR0301MB0628.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s76DuHUk011484

Hi, Eduardo
        Thanks again for review, please see below in lines:

Sent from my iPad

ÔÚ 2014-8-6£¬21:24£¬"edubezval@gmail.com" <edubezval@gmail.com> Ğ´µÀ£º

> Hello Anson,
> 
> On Wed, Aug 6, 2014 at 3:12 AM, Anson Huang <b20788@freescale.com> wrote:
>> i.MX6SX has some new features of thermal interrupt function,
>> there are LOW, HIGH and PANIC irq for thermal sensor, so add
>> platform data to separate different thermal version;
>> 
>> The reset value of LOW ALARM is 0 which means the highest
>> temp, so the LOW ALARM will be triggered once irq is enabled,
>> so we need to correct it before enabling thermal irq;
>> 
>> Enable PANIC ALARM as critical trip point, it will trigger
>> system reset via SRC module once PANIC IRQ is triggered, it
>> is pure hardware function, so use it instead of software
>> reset by cooling device.
> 
> So far the patch is pretty much better now. Unfortunately, I do not
> have a way to test it. Can you please check if some workmate of yours
> can do a testing on both hardwares and send his/her tested-by?
> 
I have tested it on i.MX6Q, i.MX6SL and i.MX6SX before sending the
patch out for review, but if it has to be someone else to test this patch,
I can try to ask someone else to help test it and send the tested-by later.
Do you think it is necessary, as I saw other team members are so busy
With their tasks, let me know if you think we must add a tested-by, thanks.
> 
> 
>> 
>> Signed-off-by: Anson Huang <b20788@freescale.com>
>> ---
>> .../devicetree/bindings/thermal/imx-thermal.txt    |    5 +-
>> drivers/thermal/imx_thermal.c                      |   91 +++++++++++++++++---
>> 2 files changed, 82 insertions(+), 14 deletions(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/thermal/imx-thermal.txt b/Documentation/devicetree/bindings/thermal/imx-thermal.txt
>> index 1f0f672..3c67bd5 100644
>> --- a/Documentation/devicetree/bindings/thermal/imx-thermal.txt
>> +++ b/Documentation/devicetree/bindings/thermal/imx-thermal.txt
>> @@ -1,7 +1,10 @@
>> * Temperature Monitor (TEMPMON) on Freescale i.MX SoCs
>> 
>> Required properties:
>> -- compatible : "fsl,imx6q-thermal"
>> +- compatible : "fsl,imx6q-tempmon" for i.MX6Q, "fsl,imx6sx-tempmon" for i.MX6SX.
>> +  i.MX6SX has two more IRQs than i.MX6Q, one is IRQ_LOW and the other is IRQ_PANIC,
>> +  when temperature is below than low threshold, IRQ_LOW will be triggered, when temperature
>> +  is higher than panic threshold, system will auto reboot by SRC module.
>> - fsl,tempmon : phandle pointer to system controller that contains TEMPMON
>>   control registers, e.g. ANATOP on imx6q.
>> - fsl,tempmon-data : phandle pointer to fuse controller that contains TEMPMON
>> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
>> index 2c516f2..461bf3d 100644
>> --- a/drivers/thermal/imx_thermal.c
>> +++ b/drivers/thermal/imx_thermal.c
>> @@ -19,6 +19,7 @@
>> #include <linux/mfd/syscon.h>
>> #include <linux/module.h>
>> #include <linux/of.h>
>> +#include <linux/of_device.h>
>> #include <linux/platform_device.h>
>> #include <linux/regmap.h>
>> #include <linux/slab.h>
>> @@ -31,6 +32,11 @@
>> 
>> #define MISC0                          0x0150
>> #define MISC0_REFTOP_SELBIASOFF                (1 << 3)
>> +#define MISC1                          0x0160
>> +#define MISC1_IRQ_TEMPHIGH             (1 << 29)
>> +/* Below LOW and PANIC bits are only for TEMPMON_IMX6SX */
>> +#define MISC1_IRQ_TEMPLOW              (1 << 28)
>> +#define MISC1_IRQ_TEMPPANIC            (1 << 27)
>> 
>> #define TEMPSENSE0                     0x0180
>> #define TEMPSENSE0_ALARM_VALUE_SHIFT   20
>> @@ -43,6 +49,12 @@
>> 
>> #define TEMPSENSE1                     0x0190
>> #define TEMPSENSE1_MEASURE_FREQ                0xffff
>> +/* Below TEMPSENSE2 is only for TEMPMON_IMX6SX */
>> +#define TEMPSENSE2                     0x0290
>> +#define TEMPSENSE2_LOW_VALUE_SHIFT     0
>> +#define TEMPSENSE2_LOW_VALUE_MASK      0xfff
>> +#define TEMPSENSE2_PANIC_VALUE_SHIFT   16
>> +#define TEMPSENSE2_PANIC_VALUE_MASK    0xfff0000
>> 
>> #define OCOTP_ANA1                     0x04e0
>> 
>> @@ -66,6 +78,21 @@ enum imx_thermal_trip {
>> #define FACTOR1                                15976
>> #define FACTOR2                                4297157
>> 
>> +#define TEMPMON_IMX6Q                  1
>> +#define TEMPMON_IMX6SX                 2
>> +
>> +struct thermal_soc_data {
>> +       u32 version;
>> +};
>> +
>> +static struct thermal_soc_data thermal_imx6q_data = {
>> +       .version = TEMPMON_IMX6Q,
>> +};
>> +
>> +static struct thermal_soc_data thermal_imx6sx_data = {
>> +       .version = TEMPMON_IMX6SX,
>> +};
>> +
>> struct imx_thermal_data {
>>        struct thermal_zone_device *tz;
>>        struct thermal_cooling_device *cdev;
>> @@ -79,8 +106,21 @@ struct imx_thermal_data {
>>        bool irq_enabled;
>>        int irq;
>>        struct clk *thermal_clk;
>> +       const struct thermal_soc_data *socdata;
>> };
>> 
>> +static void imx_set_panic_temp(struct imx_thermal_data *data,
>> +                              signed long panic_temp)
>> +{
>> +       struct regmap *map = data->tempmon;
>> +       int critical_value;
>> +
>> +       critical_value = (data->c2 - panic_temp) / data->c1;
>> +       regmap_write(map, TEMPSENSE2 + REG_CLR, TEMPSENSE2_PANIC_VALUE_MASK);
>> +       regmap_write(map, TEMPSENSE2 + REG_SET, critical_value <<
>> +                       TEMPSENSE2_PANIC_VALUE_SHIFT);
>> +}
>> +
>> static void imx_set_alarm_temp(struct imx_thermal_data *data,
>>                               signed long alarm_temp)
>> {
>> @@ -142,13 +182,17 @@ static int imx_get_temp(struct thermal_zone_device *tz, unsigned long *temp)
>>        /* See imx_get_sensor_data() for formula derivation */
>>        *temp = data->c2 - n_meas * data->c1;
>> 
>> -       /* Update alarm value to next higher trip point */
>> -       if (data->alarm_temp == data->temp_passive && *temp >= data->temp_passive)
>> -               imx_set_alarm_temp(data, data->temp_critical);
>> -       if (data->alarm_temp == data->temp_critical && *temp < data->temp_passive) {
>> -               imx_set_alarm_temp(data, data->temp_passive);
>> -               dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
>> -                       data->alarm_temp / 1000);
>> +       /* Update alarm value to next higher trip point for TEMPMON_IMX6Q */
>> +       if (data->socdata->version == TEMPMON_IMX6Q) {
>> +               if (data->alarm_temp == data->temp_passive &&
>> +                       *temp >= data->temp_passive)
>> +                       imx_set_alarm_temp(data, data->temp_critical);
>> +               if (data->alarm_temp == data->temp_critical &&
>> +                       *temp < data->temp_passive) {
>> +                       imx_set_alarm_temp(data, data->temp_passive);
>> +                       dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
>> +                               data->alarm_temp / 1000);
>> +               }
>>        }
>> 
>>        if (*temp != data->last_temp) {
>> @@ -398,8 +442,17 @@ static irqreturn_t imx_thermal_alarm_irq_thread(int irq, void *dev)
>>        return IRQ_HANDLED;
>> }
>> 
>> +static const struct of_device_id of_imx_thermal_match[] = {
>> +       { .compatible = "fsl,imx6q-tempmon", .data = &thermal_imx6q_data, },
>> +       { .compatible = "fsl,imx6sx-tempmon", .data = &thermal_imx6sx_data, },
>> +       { /* end */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
>> +
>> static int imx_thermal_probe(struct platform_device *pdev)
>> {
>> +       const struct of_device_id *of_id =
>> +               of_match_device(of_imx_thermal_match, &pdev->dev);
>>        struct imx_thermal_data *data;
>>        struct cpumask clip_cpus;
>>        struct regmap *map;
>> @@ -418,6 +471,20 @@ static int imx_thermal_probe(struct platform_device *pdev)
>>        }
>>        data->tempmon = map;
>> 
>> +       data->socdata = of_id->data;
>> +
>> +       /* make sure the IRQ flag is clear before enabling irq on i.MX6SX */
>> +       if (data->socdata->version == TEMPMON_IMX6SX) {
> 
> A general question on the patch strategy. You have chosen to split the
> features per chip version. While this strategy is straight forward,
> and one would even say very natural, I would say it is not very
> scalable. In case your next chip versions have an overlap in features
> with the existing ones, you will make your code a nightmare of ifs per
> chip version. One suggestion is, that I have experienced to work with
> TI and Samsung chips, to split the code per feature, not per chip
> version.
> 
> In chis case, you will have a .supports or .features bitfield instead
> of a .version. Then you would check if particular feature is present
> in the chip you are dealing with, instead of asking for chip version.
> What do you think?

Thank you very much for sharing experience on such scenario. I think
either way is OK for this case, as this new feature on i.MX6SX is an pure
improvement on this thermal IP based on our suggestion to hardware design
team,I believe all the next chips will
reuse i.MX6SX's thermal IP, but NOT select some overlap features on
i.MX6SX and i.MX6Q. That is why I named it as a V1 and V2 for this
thermal sensor IP before. Do you think it is OK to just leave it using version,
or if you think it is better to use the way you recommended, I can try it, but
to be honest, I think using version should be OK for this case.
> 
>> +               regmap_write(map, MISC1 + REG_CLR, MISC1_IRQ_TEMPHIGH |
>> +                       MISC1_IRQ_TEMPLOW | MISC1_IRQ_TEMPPANIC);
>> +               /*
>> +                * reset value of LOW ALARM is incorrect, set it to lowest
>> +                * value to avoid false trigger of low alarm.
>> +                */
>> +               regmap_write(map, TEMPSENSE2 + REG_SET,
>> +                       TEMPSENSE2_LOW_VALUE_MASK);
>> +       }
>> +
>>        data->irq = platform_get_irq(pdev, 0);
>>        if (data->irq < 0)
>>                return data->irq;
>> @@ -489,6 +556,10 @@ static int imx_thermal_probe(struct platform_device *pdev)
>>        measure_freq = DIV_ROUND_UP(32768, 10); /* 10 Hz */
>>        regmap_write(map, TEMPSENSE1 + REG_SET, measure_freq);
>>        imx_set_alarm_temp(data, data->temp_passive);
>> +
>> +       if (data->socdata->version == TEMPMON_IMX6SX)
>> +               imx_set_panic_temp(data, data->temp_critical);
>> +
>>        regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
>>        regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
>> 
>> @@ -550,12 +621,6 @@ static int imx_thermal_resume(struct device *dev)
>> static SIMPLE_DEV_PM_OPS(imx_thermal_pm_ops,
>>                         imx_thermal_suspend, imx_thermal_resume);
>> 
>> -static const struct of_device_id of_imx_thermal_match[] = {
>> -       { .compatible = "fsl,imx6q-tempmon", },
>> -       { /* end */ }
>> -};
>> -MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
>> -
>> static struct platform_driver imx_thermal = {
>>        .driver = {
>>                .name   = "imx_thermal",
>> --
>> 1.7.9.5
>> 
> 
> 
> 
> -- 
> Eduardo Bezerra Valentin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
