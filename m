Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3J3Da1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:30:27 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49478 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3J3DaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131024172734.GB2461@kartoffel>
References: <1382545733-8865-1-git-send-email-badarkhe.manish@gmail.com>
	<1382545733-8865-2-git-send-email-badarkhe.manish@gmail.com>
	<20131023164548.GB6042@kartoffel>
	<CAKDJKT4+ma+KdNX0uemZUQVKHp8giGUX8EgWkY40vYOR-KR0_A@mail.gmail.com>
	<20131024172734.GB2461@kartoffel>
Date: Wed, 30 Oct 2013 09:00:23 +0530
Message-ID: <CAKDJKT63gvGQAiKBopFtzmOSDNyfQ-UXmUi6yXKbjK5Zvwy1aw@mail.gmail.com>
Subject: Re: [PATCH V4 1/2] tps6507x-ts: Add DT support
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Apologize for my late reply.


On Thu, Oct 24, 2013 at 10:57 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Thu, Oct 24, 2013 at 06:05:53PM +0100, Manish Badarkhe wrote:
> > Hi Mark,
> >
> > Thank you for your reply.
> >
> > On Wed, Oct 23, 2013 at 10:15 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> >
> >     On Wed, Oct 23, 2013 at 05:28:52PM +0100, Manish Badarkhe wrote:
> >     > Add device tree based support for TI's tps6507x touchscreen.
> >     >
> >     > Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> >     > ---
> >     > Changes since V3:
> >     >  - Rebased on top of Dmitry's changes
> >     >  - Removed error handling for optional DT properties
> >     >
> >     > Changes since V2:
> >     >  - Removed unnecessary code.
> >     >  - Updated Documentation to provide proper names of
> >     >    devicetree properties.
> >     >
> >     > Changes since V1:
> >     >  - Updated documentation to specify tps6507x as multifunctional
> >     >    device.
> >     >  - return proper error value in absence of platform and DT
> >     >    data for touchscreen.
> >     >  - Updated commit message.
> >     >
> >     > :100755 100755 8fffa3c... e1b9cfd... M        Documentation/devicetree/
> >     bindings/mfd/tps6507x.txt
> >     > :100644 100644 db604e0... 0cf0eb1... M        drivers/input/touchscreen/
> >     tps6507x-ts.c
> >     >  Documentation/devicetree/bindings/mfd/tps6507x.txt |   24 ++++++-
> >     >  drivers/input/touchscreen/tps6507x-ts.c            |   72
> >     ++++++++++++--------
> >     >  2 files changed, 67 insertions(+), 29 deletions(-)
> >     >
> >     > diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/
> >     Documentation/devicetree/bindings/mfd/tps6507x.txt
> >     > index 8fffa3c..e1b9cfd 100755
> >     > --- a/Documentation/devicetree/bindings/mfd/tps6507x.txt
> >     > +++ b/Documentation/devicetree/bindings/mfd/tps6507x.txt
> >     > @@ -1,4 +1,8 @@
> >     > -TPS6507x Power Management Integrated Circuit
> >     > +TPS6507x Multifunctional Device.
> >     > +
> >     > +Features provided by TPS6507x:
> >     > +        1.Power Management Integrated Circuit.
> >     > +        2.Touch-Screen.
> >     >
> >     >  Required properties:
> >     >  - compatible: "ti,tps6507x"
> >     > @@ -23,6 +27,9 @@ Required properties:
> >     >         vindcdc1_2-supply: VDCDC1 and VDCDC2 input.
> >     >         vindcdc3-supply  : VDCDC3 input.
> >     >         vldo1_2-supply   : VLDO1 and VLDO2 input.
> >     > +- tsc: This node specifies touch screen data.
> >
> >     This is a node, but is listed un "Required properties". That seems odd.
> >
> >     When is it required?
> >
> >     Why is the data under the tsc subnode? Why not directly under the main
> >     node?
> >
> >
> > Yes, It seems odd to add a subnode properties here. I gone through other
> > documentation
> > for MFD devices and observed that separate documentation file is present for
> > sub node modules.
>
> I was trying to say that nodes != properties rather than that this should be
> split into separate files.
>

Ok, got it.I will modify documentation so that only properties comes
under "required
properties" section.

>
> >
> > TPS6507x is multifunctional device and having touch screen submodule. As it is
> > child node for
> > TPS6507x multifunctional device, I have created child node as "tsc".
> >
> >
> >
> >     > +     ti,poll-period : Time at which touch input is getting sampled in
> >     ms.
> >
> >     Is this for debounce? Other bindings have similar but differently named
> >     properties.
> >
> >
> > This is not debounce time. This time is required for input poll devices.
> >
> >
> >     Why is this necessary? Can the driver not choose a sane value?
> >
> >
> > poll-period is necessary to sample touch inputs. Driver will chose value
> > default poll
> > period if this value is not present. I was bit confused here, whether to add
> > this property
> > as optional or required. As with default period touch not achieve performance.
> > Can I make this property optional?
>
> Please elaborate. Why will the default period be sub-optimal? What's the
> tradeoff here?

Currently, default period and period passed from Device tree both
are same.I made an assumption here, if default period is less then
touch get sampled faster and report it to upper layer.As I am not I
will make this confirm with Texas instrument's engineers.

>
> >
> >
> >     > +     ti,min-pressure: Minimum pressure value to trigger touch.
> >
> >     What type are these? Single (u32) cells?
> >
> >     What units is ti,min-pressure in?
> >
> >
> > No, its a u16 cell. It is measured in ohm. Again default value for min-pressure
> > is available
> > in driver code. Can I make this property optional?
>
> Why is it a u16, it's very uncommon to have u16 properties.
>
> What _physical_ units is this in, and what order of magnitude? e.g. Pascals,
> millipascals.
>

I gone through data sheet but not able to find any units for this
pressure field.
As per data sheet, we read pressure values from two ADC result
registers and these two registers are 8 bit long and hence provide
totally 16 bit pressure value.

>
> >
> >
> >     >
> >     >  Regulator Optional properties:
> >     >  - defdcdc_default: It's property of DCDC2 and DCDC3 regulators.
> >     > @@ -30,6 +37,14 @@ Regulator Optional properties:
> >     >                       1: If defdcdc pin of DCDC2/DCDC3 is driven HIGH.
> >     >    If this property is not defined, it defaults to 0 (not enabled).
> >     >
> >     > +Touchscreen Optional properties:
> >     > +- ti,vendor : Touchscreen vendor id to populate
> >     > +           in sysclass interface.
> >     > +- ti,product: Touchscreen product id to populate
> >     > +           in sysclass interface.
> >     > +- ti,version: Touchscreen version id to populate
> >     > +           in sysclass interface.
> >
> >     Are these integers, strings, or something else?
> >
> >
> > These are unsigned short(u16) values.
>
> Why?
>

Not much sure why this field is u16. I just referred a platform
data which  mentioned field as u16 and accordingly add a DT
property. I am not seeing any harm to make this property u32.
I will make this property as u32.

>
>
>
> >
> >
> >     What values make sense?
> >
> >
> > These values are only to tell about chip details.
>
>
> That does not describe the set of valid values.
>
> Is ti,vendor = <4> valid? What does this mean?
>
> Is there some standard for assignment of vendor IDs that this follows?
>

As, these are numeric values, not sure about standard assignment
of these field. For DT properties, I used these field same as from
platform data of touch screen driver.
I will make sure about this Texas Instrument's engineers.

> >
> >
> >     What's the sysclass interface? That sounds like a Linux detail. The
> >     properties
> >     might be fine but the description shouldn't need to refer to Linux
> >     internals.
> >
> >
> > Okay, I will update description for these properties.
> >
> >
> >     > +
> >     >  Example:
> >     >
> >     >       pmu: tps6507x@48 {
> >     > @@ -88,4 +103,11 @@ Example:
> >     >                       };
> >     >               };
> >     >
> >     > +             tsc {
> >     > +                     ti,poll-period = <30>;
> >     > +                     ti,min-pressure = <0x30>;
> >     > +                     ti,vendor = <0>;
> >     > +                     ti,product = <65070>;
> >     > +                     ti,version = <0x100>;
> >     > +             };
> >     >       };
> >     > diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/
> >     touchscreen/tps6507x-ts.c
> >     > index db604e0..0cf0eb1 100644
> >     > --- a/drivers/input/touchscreen/tps6507x-ts.c
> >     > +++ b/drivers/input/touchscreen/tps6507x-ts.c
> >     > @@ -22,6 +22,8 @@
> >     >  #include <linux/mfd/tps6507x.h>
> >     >  #include <linux/input/tps6507x-ts.h>
> >     >  #include <linux/delay.h>
> >     > +#include <linux/of.h>
> >     > +#include <linux/of_device.h>
> >     >
> >     >  #define TSC_DEFAULT_POLL_PERIOD 30 /* ms */
> >     >  #define TPS_DEFAULT_MIN_PRESSURE 0x30
> >     > @@ -206,33 +208,54 @@ done:
> >     >       tps6507x_adc_standby(tsc);
> >     >  }
> >     >
> >     > +static void tsc_init_data(struct tps6507x_ts *tsc,
> >     > +             struct input_dev *input_dev)
> >     > +{
> >     > +     struct device_node *node = tsc->dev->of_node;
> >     > +     const struct tps6507x_board *tps_board =
> >     > +                     dev_get_platdata(tsc->dev);
> >     > +     const struct touchscreen_init_data *init_data = NULL;
> >     > +
> >     > +     if (node)
> >     > +             node = of_find_node_by_name(node, "tsc");
> >
> >     As of_find_node_by_name traverses the list of all nodes (not just
> >     children),
> >     this may match nodes other than what you expect.
> >
> >
> > I think, It traverse nodes from parent node (i.e. tps6507x) and find child.
> > Please correct me if I am wrong?
>
> No. As I said, it traverses the list of all nodes. Is there is no matching
> child, it will go on and possibly match a node that is not a direct child (e.g.
> a child of another node).
>
> Perhaps of_get_child_by_name is what you want.

Got it, I will change this to  "of_get_child_by_name".

>
> >
> >
> >
> >     > +     if (tps_board)
> >     > +             /*
> >     > +              * init_data points to array of touchscreen_init structure
> >     > +              * coming from the board-evm file.
> >     > +              */
> >     > +             init_data = tps_board->tps6507x_ts_init_data;
> >     > +
> >     > +     if (node == NULL || init_data == NULL) {
> >     > +             tsc->poll_dev->poll_interval = TSC_DEFAULT_POLL_PERIOD;
> >     > +             tsc->min_pressure = TPS_DEFAULT_MIN_PRESSURE;
> >     > +     } else if (init_data) {
> >     > +             tsc->poll_dev->poll_interval = init_data->poll_period;
> >     > +             tsc->min_pressure = init_data->min_pressure;
> >     > +             input_dev->id.vendor = init_data->vendor;
> >     > +             input_dev->id.product = init_data->product;
> >     > +             input_dev->id.version = init_data->version;
> >     > +     } else if (node) {
> >     > +             of_property_read_u32(node, "ti,poll-period",
> >     > +                             &tsc->poll_dev->poll_interval);
> >     > +             of_property_read_u16(node, "ti,min-pressure",
> >     > +                             &tsc->min_pressure);
> >
> >     You didn't mention these were 16-bit values in the binding.
> >
> >     As DTB is encoded big-endian, and you didn't use a /bits/ 16 declaration
> >     (making the property a u32 cell), won't this read 0 in all cases you have a
> >     value in the expected range (as in your example)?
> >
> >
> > I will mention these values as 16bit. values in binding.
>
> Please explain _why_ they are 16-bit values. Even if they are 16-bit it may
> make sense to have them as u32 values for general consistency and least
> surprise.

Similarly as above, I just referred a platform data which mentioned
this field as u16 and accordingly add a DT property for same.
I am not seeing any harm to make this property u32. I will make this
property u32.


Regards
Manish Badarkhe
