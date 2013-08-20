Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3HTGzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:55:38 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42874 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3HTGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8u1BEXMHHso80NdP4FX_au2mnUEtzqYyJXg_vA9JvSJbA@mail.gmail.com>
References: <1369126458-24872-1-git-send-email-manishv.b@ti.com>
	<1369126458-24872-2-git-send-email-manishv.b@ti.com>
	<CA+V-a8u1BEXMHHso80NdP4FX_au2mnUEtzqYyJXg_vA9JvSJbA@mail.gmail.com>
Date: Tue, 20 Aug 2013 12:25:32 +0530
Message-ID: <CAKDJKT45=BUcx5q8bHL=xzHQ0aAhE=cwGy4EK8MWRfpiKVzt0g@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] tps6507x-ts: Add DT support
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LDOC <linux-doc@vger.kernel.org>,
        device-tree <devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Tue, Aug 20, 2013 at 11:44 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Manish,
>
> Thanks for the patch.
>
> On Tue, May 21, 2013 at 2:24 PM, Vishwanathrao Badarkhe, Manish
> <manishv.b@ti.com> wrote:
>> Add device tree based support for TI's tps6507x touchscreen.
>>
>> Tested on da850-evm.
>>
>> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
>> ---
>> Changes since V2:
>>  - Removed unnecessary code.
>>  - Updated Documentation to provide proper names of
>>    devicetree properties.
>>
>> Changes since V1:
>>  - Updated documentation to specify tps6507x as multifunctional
>>    device.
>>  - return proper error value in absence of platform and DT
>>    data for touchscreen.
>>  - Updated commit message.
>>
>> :100755 100755 8fffa3c... 65ee2cd... M  Documentation/devicetree/bindings/mfd/tps6507x.txt
>> :100644 100644 65e0f9a... 89232ee... M  drivers/input/touchscreen/tps6507x-ts.c
>>  Documentation/devicetree/bindings/mfd/tps6507x.txt |   28 ++++++-
>>  drivers/input/touchscreen/tps6507x-ts.c            |   98 ++++++++++++++------
>>  2 files changed, 95 insertions(+), 31 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
>> index 8fffa3c..65ee2cd 100755
>> --- a/Documentation/devicetree/bindings/mfd/tps6507x.txt
>> +++ b/Documentation/devicetree/bindings/mfd/tps6507x.txt
>> @@ -1,4 +1,8 @@
>> -TPS6507x Power Management Integrated Circuit
>> +TPS6507x Multifunctional Device.
>> +
>> +Features provided by TPS6507x:
>> +        1.Power Management Integrated Circuit.
>> +        2.Touch-Screen.
>>
>>  Required properties:
>>  - compatible: "ti,tps6507x"
>> @@ -23,6 +27,12 @@ Required properties:
>>         vindcdc1_2-supply: VDCDC1 and VDCDC2 input.
>>         vindcdc3-supply  : VDCDC3 input.
>>         vldo1_2-supply   : VLDO1 and VLDO2 input.
>> +- tsc: This node specifies touch screen data.
>> +       ti,poll-period : Time at which touch input is getting sampled in ms.
>> +       ti,min-pressure: Minimum pressure value to trigger touch.
>> +       ti,vref        : voltage reference for ADC.
>> +                     0: Reference voltage for ADC is disabled.
>> +                     1: Reference voltage for ADC is enabled.
>>
>>  Regulator Optional properties:
>>  - defdcdc_default: It's property of DCDC2 and DCDC3 regulators.
>> @@ -30,6 +40,14 @@ Regulator Optional properties:
>>                         1: If defdcdc pin of DCDC2/DCDC3 is driven HIGH.
>>    If this property is not defined, it defaults to 0 (not enabled).
>>
>> +Touchscreen Optional properties:
>> +- ti,vendor : Touchscreen vendor id to populate
>> +             in sysclass interface.
>> +- ti,product: Touchscreen product id to populate
>> +             in sysclass interface.
>> +- ti,version: Touchscreen version id to populate
>> +             in sysclass interface.
>> +
>>  Example:
>>
>>         pmu: tps6507x@48 {
>> @@ -88,4 +106,12 @@ Example:
>>                         };
>>                 };
>>
>> +               tsc {
>> +                       ti,poll-period = <30>;
>> +                       ti,min-pressure = <0x30>;
>> +                       ti,vref = <0>;
>> +                       ti,vendor = <0>;
>> +                       ti,product = <65070>;
>> +                       ti,version = <0x100>;
>> +               };
>>         };
>> diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
>> index 65e0f9a..89232ee 100644
>> --- a/drivers/input/touchscreen/tps6507x-ts.c
>> +++ b/drivers/input/touchscreen/tps6507x-ts.c
>> @@ -21,6 +21,8 @@
>>  #include <linux/mfd/tps6507x.h>
>>  #include <linux/input/tps6507x-ts.h>
>>  #include <linux/delay.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>>
>>  #define TSC_DEFAULT_POLL_PERIOD 30 /* ms */
>>  #define TPS_DEFAULT_MIN_PRESSURE 0x30
>> @@ -231,36 +233,76 @@ done:
>>         ret = tps6507x_adc_standby(tsc);
>>  }
>>
>> +static int tsc_init_data(struct tps6507x_dev *tps6507x_dev,
>> +               struct input_dev *input_dev)
>> +{
>> +       struct device_node *node = tps6507x_dev->dev->of_node;
>> +       struct tps6507x_board *tps_board =
>> +               (struct tps6507x_board *)tps6507x_dev->dev->platform_data;
>> +       struct touchscreen_init_data *init_data = NULL;
>> +       int err;
>> +
>> +       if (node)
>> +               node = of_find_node_by_name(node, "tsc");
>> +       if (tps_board)
>> +               init_data = tps_board->tps6507x_ts_init_data;
>> +
>> +       if (node == NULL || init_data == NULL) {
>> +               err = -EINVAL;
>> +               goto error_ret;
>> +       } else if (init_data) {
>> +               tps6507x_dev->ts->poll_period = init_data->poll_period;
>> +               tps6507x_dev->ts->min_pressure = init_data->min_pressure;
>> +               tps6507x_dev->ts->vref = init_data->vref;
>> +               input_dev->id.vendor = init_data->vendor;
>> +               input_dev->id.product = init_data->product;
>> +               input_dev->id.version = init_data->version;
>> +       } else if (node) {
>> +               err = of_property_read_u32(node, "ti,poll-period",
>> +                                       (u32 *)&tps6507x_dev->ts->poll_period);
>> +               if (err < 0)
>> +                       goto error_ret;
>> +
>> +               err = of_property_read_u16(node, "ti,min-pressure",
>> +                                       &tps6507x_dev->ts->min_pressure);
>> +               if (err < 0)
>> +                       goto error_ret;
>> +
>> +               err = of_property_read_u32(node, "ti,vref",
>> +                                       &tps6507x_dev->ts->vref);
>> +               if (err < 0)
>> +                       goto error_ret;
>> +
>> +               err = of_property_read_u16(node, "ti,vendor",
>> +                                       &input_dev->id.vendor);
>> +               if (err < 0)
>> +                       goto error_ret;
>> +
>> +               err = of_property_read_u16(node, "ti,product",
>> +                                       &input_dev->id.product);
>> +               if (err < 0)
>> +                       goto error_ret;
>> +
>> +               err = of_property_read_u16(node, "ti,version",
>> +                                       &input_dev->id.version);
>> +               if (err < 0)
>> +                       goto error_ret;
>
> All the three above properties as per the documentation  above
> are optional, but the code here makes them required property.
> May be what you can do is if property is not defined make it as
> zero as per documentation.

I already taken care of this as per Dmitry's comment but not yet
posted patch series as
there is discussion going on populating child node's properties.


Regards
Manish Badarkhe
