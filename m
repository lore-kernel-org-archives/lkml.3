Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3KUQcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:32:32 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24874 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3KUQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:32:29 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-ee-528e359b6be3
From: Tomasz Figa <t.figa@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, swarren@wwwdotorg.org,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        rob.herring@calxeda.com, linux@roeck-us.net, rui.zhang@intel.com,
        wni@nvidia.com, grant.likely@linaro.org, durgadoss.r@intel.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
Date: Thu, 21 Nov 2013 17:32:14 +0100
Message-id: <5333248.b0sPp1ZZXY@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <528E2B38.5050502@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1574695.YAEZXuUskK@amdc1227> <528E2B38.5050502@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xy7qzTfuCDJ79V7GYf+Qcq0XfzyvM
	Fmv2/2SyOPBnB6PFm94OFovLu+awWXzuPcJo8WThGSaLO9P2slksvX6RyWLC9LUsFodXHGCy
	ePKwj83i1cE2FotVu/4wWhw41czsIOCxZt4aRo8Fn6+we7yePIHRY+esu+wei/e8ZPK4c20P
	m8eDibvZPHqb37F57PzewO5x/MZ2Jo/Pm+Q8Ns4NDeCJ4rJJSc3JLEst0rdL4Mr4cvoCU8H5
	dsaKF/fFGhhfZ3UxcnJICJhI7Hn7nh3CFpO4cG89G4gtJLCUUWLt/sIuRi4gu4tJYmb3ckaQ
	BJuAmsTnhkdgRSICehI3XjxhArGZBf4wSRxf7AxiCws4SUw+2AYWZxFQlVgxtQWsnldAU+L6
	7S0sIDa/gLrEu21PwWpEBdwkpv84yAxicwLNP7N7MjPE4kZGifbdR5ggmgUlfky+xwKxTF5i
	3/6prBC2lsT6nceZJjAKzkJSNgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525i
	hETnlx2Mi49ZHWIU4GBU4uHteNwTJMSaWFZcmXuIUYKDWUmE96t6X5AQb0piZVVqUX58UWlO
	avEhRiYOTqkGxvSujevuakz5n/nkZOsheWGB0/auuu/SWAT1l9Z6bLl099WWk0unsuWqVaws
	uRyeapdd2HXV696Lzx84WK2OKTX1bjMvsN4z803kFLa9oTPvMaQWr/PbO8dsft/DA+bhuhpl
	jwRfnvA49udLh5ya8AP3Mv6F4k1zwqwsuO/nazr4FU9VVjvJrMRSnJFoqMVcVJwIAHyUHLes	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 of November 2013 11:48:08 Eduardo Valentin wrote:
> On 21-11-2013 10:57, Tomasz Figa wrote:
> > On Friday 15 of November 2013 09:19:02 Eduardo Valentin wrote:
> >> Hello Tomasz,
> >>
> >> On 14-11-2013 09:40, Tomasz Figa wrote:
> >>> On Thursday 14 of November 2013 07:31:04 Eduardo Valentin wrote:
> >>>> On 13-11-2013 12:57, Tomasz Figa wrote:
> >>>>> Hi Eduardo,
> >>>>>
> >>>>
> >>>> Hello Tomaz
> >>>>
> >>>>> On Tuesday 12 of November 2013 15:46:04 Eduardo Valentin wrote:
> >>>>>> This patch introduces a device tree bindings for
> >>>>>> describing the hardware thermal behavior and limits.
> >>>>>> Also a parser to read and interpret the data and feed
> >>>>>> it in the thermal framework is presented.
> >>>>> [snip]
> >>>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>>>> new file mode 100644
> >>>>>> index 0000000..59f5bd2
> >>>>>> --- /dev/null
> >>>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>>>> @@ -0,0 +1,586 @@
> >>>>> [snip]
> >>>>>> +* Cooling device nodes
> >>>>>> +
> >>>>>> +Cooling devices are nodes providing control on power dissipation. There
> >>>>>> +are essentially two ways to provide control on power dissipation. First
> >>>>>> +is by means of regulating device performance, which is known as passive
> >>>>>> +cooling. A typical passive cooling is a CPU that has dynamic voltage and
> >>>>>> +frequency scaling (DVFS), and uses lower frequencies as cooling states.
> >>>>>> +Second is by means of activating devices in order to remove
> >>>>>> +the dissipated heat, which is known as active cooling, e.g. regulating
> >>>>>> +fan speeds. In both cases, cooling devices shall have a way to determine
> >>>>>> +the state of cooling in which the device is.
> >>>>>> +
> >>>>>> +Required properties:
> >>>>>> +- cooling-min-state:	An integer indicating the smallest
> >>>>>> +  Type: unsigned	cooling state accepted. Typically 0.
> >>>>>> +  Size: one cell
> >>>>>
> >>>>> Could you explain (just in a reply) what a cooling state is and what are
> >>>>> the min and max values used for?
> >>>>
> >>>> Cooling state is an unsigned integer which represents heat control that
> >>>> a cooling device implies.
> >>>
> >>> OK. So you have a cooling device and it can have multiple cooling states,
> >>> like a cooling fan that has multiple speed levels. Did I understand this
> >>> correctly?
> >>>
> >>> IMHO this should be also explained in the documentation above, possibly
> >>> with one or two examples.
> >>
> >>
> >> There are more than one example in this file. Even explaining why
> >> cooling min and max are used, and the difference of min and max
> >> properties that appear in cooling device and those present in a cooling
> >> specifier. Cooling devices and cooling state are described in the
> >> paragraph above.
> > 
> > I mean, the definition I commented about is completely confusing. You
> > should rewrite it in a more readable way. For example, "Cooling state is
> > an unsigned integer which represents level of cooling performance of
> > a thermal device." would be much more meaningful, if I understood the
> > whole idea of "cooling state" correctly.
> 
> Yeah, I see your point. But I avoided describing cooling state as a
> property, as you are requesting, because in fact it is not a property.
> Its min and max values are properties, as you can see in the document.
> Describing cooling state as a property in this document will confuse
> people, because it won't be used in any part of the hardware description.

Sorry, I'm not getting your point here. What kind of "property" are you
talking about? Is there anything wrong with my proposed alternative
description?

> 
> > 
> > By example I mean simply listing one or two possible practical meanings,
> > like "(e.g. speed level of a cooling fan, performance throttling level of
> > CPU)".
> 
> Mark R. has already requested this example and I already wrote it. There
> is a comment in the CPU example session explaining exactly what you are
> asking. Have you missed that one?

No, I haven't. But a binding usage example is a separate thing from what
I mean. When you read some text from top to bottom, you would prefer
not to need to jump down and up to understand what you read. That's
why adding one additional sentence, just quickly showing the meaning
of something, is rather justified.

> 
> > 
> >>
> >>>
> >>>>
> >>>>>
> >>>>>> +
> >>>>>> +- cooling-max-state:	An integer indicating the largest
> >>>>>> +  Type: unsigned	cooling state accepted.
> >>>>>> +  Size: one cell
> >>>>>> +
> >>>>>> +- #cooling-cells:	Used to provide cooling device specific information
> >>>>>> +  Type: unsigned	while referring to it. Must be at least 2, in order
> >>>>>> +  Size: one cell      	to specify minimum and maximum cooling state used
> >>>>>> +			in the reference. The first cell is the minimum
> >>>>>> +			cooling state requested and the second cell is
> >>>>>> +			the maximum cooling state requested in the reference.
> >>>>>> +			See Cooling device maps section below for more details
> >>>>>> +			on how consumers refer to cooling devices.
> >>>>>> +
> >>>>>> +* Trip points
> >>>>>> +
> >>>>>> +The trip node is a node to describe a point in the temperature domain
> >>>>>> +in which the system takes an action. This node describes just the point,
> >>>>>> +not the action.
> >>>>>> +
> >>>>>> +Required properties:
> >>>>>> +- temperature:		An integer indicating the trip temperature level,
> >>>>>> +  Type: signed		in millicelsius.
> >>>>>> +  Size: one cell
> >>>>>> +
> >>>>>> +- hysteresis:		A low hysteresis value on temperature property (above).
> >>>>>> +  Type: unsigned	This is a relative value, in millicelsius.
> >>>>>> +  Size: one cell
> >>>>>
> >>>>> What about replacing temperature and hysteresis with a single temperature
> >>>>> property that can be either one cell for 0 hysteresis or two cells to
> >>>>> specify lower and upper range of temperatures?
> >>>>
> >>>> What is the problem with using two properties? I think we loose
> >>>> representation by gluing two properties into one just because one cell.
> >>>
> >>> Ranges is the representation widely used in other bindings. In addition
> >>
> >> Well that sentence is arguable. It is not like all properties in DT are
> >> standardized as ranges, is it?
> > 
> > No, they are not, but property range is a common concept of representing
> > range of some values.
> > 
> > Anyway, I won't insist on this, as it's just a minor detail. However I'd
> > like to see comments from more people on this.
> > 
> >>
> >>> I believe a range is more representative - when reading a DTS you don't
> >>> need to think whether the hysteresis is in temperature units, percents or
> >>> something else and also is less ambiguous, because you have clearly
> >>> defined lower and upper bounds in one place.
> >>
> >> It is the other way around. For a person designing a thermal
> >> representation for a specific board it is intuitive to think about
> >> hysteresis in this case. It is a better representation because we are
> >> really talking about a hysteresis here in order to give some room for
> >> the system to react on temporary temperature transitions around that
> >> point. It is possible to use ranges as you are suggesting, but it
> >> becomes confusing.
> >>
> > 
> > Probably it depends on what you are used to. I'd like to see opinion
> > of more people on this.
> > 
> >>
> >>>
> >>>>
> >>>>>
> >>>>>> +
> >>>>>> +- type:			a string containing the trip type. Supported values are:
> >>>>>> +	"active":	A trip point to enable active cooling
> >>>>>> +	"passive":	A trip point to enable passive cooling
> >>>>>
> >>>>> The two above seem to be implying action, as opposed to the general
> >>>>> comment about trip points.
> >>>>
> >>>> They do not imply action, they specify type of trip.
> >>>
> >>> For me "A trip point to enable active cooling" means that when this trip
> >>> point is crossed, active cooling must be enabled. What is it if not
> >>> implying action?
> >>
> >> But within a board there could be more than one active cooling actions
> >> that could be done, it is not a 1 to 1 relation. Same thing applies to
> >> passive cooling. The binding does not imply a specific action. Just the
> >> trip type.
> > 
> > I'd prefer the "active" and "passive" states to be renamed an their
> > descriptions rephrased. In general, the idea of having just four trip
> > point types seems like bound to a single specific hardware platform.
> > 
> 
> Not it is in fact not. These concepts are derived from an specification
> that is there for decades actually, ACPI. I am not reinventing the wheel
> here. There are several platforms based on that specification. The
> concepts have been reused on top of non-ACPI platforms too.

Well, ACPI seems to be designed primarily with PC-class hardware in mind,
such as desktops and notebooks, not small mobile devices, such as mobile
phones and it should not be considered as a reference design, especially
on such hardware, which it was not designed for.

> 
> > That's a wild guess, but maybe having an unsigned integer to represent
> > trip point "attention level" would be a better idea?
> 
> It would be less representative and not standardized. Do you have a
> class of boards, or at least a single board that is using the proposed
> standard?

Well, I don't have any particular board in mind, but an use case instead.
On a lot of mobile phones, there is also a low temperature trip point
(usually tens of degrees below zero) to shut down the phone when the
temperature falls down below its minimal operating temperature. Although,
one could use "critical" trip point for this, how would you distinguish
hot and cold critical points?

Similarly, there is often a threshold (also below 0C) under which battery
charging process should be disabled.

Does it mean that we also need "cold" and "freezing" trip point types?

> 
> > 
> >>
> >>>
> >>>>
> >>>>>
> >>>>>> +	"hot":		A trip point to notify emergency
> >>>>>> +	"critical":	Hardware not reliable.
> >>>>>> +  Type: string
> >>>>>> +
> >>>>> [snip]
> >>>>>> +* Examples
> >>>>>> +
> >>>>>> +Below are several examples on how to use thermal data descriptors
> >>>>>> +using device tree bindings:
> >>>>>> +
> >>>>>> +(a) - CPU thermal zone
> >>>>>> +
> >>>>>> +The CPU thermal zone example below describes how to setup one thermal zone
> >>>>>> +using one single sensor as temperature source and many cooling devices and
> >>>>>> +power dissipation control sources.
> >>>>>> +
> >>>>>> +#include <dt-bindings/thermal/thermal.h>
> >>>>>> +
> >>>>>> +cpus {
> >>>>>> +	/*
> >>>>>> +	 * Here is an example of describing a cooling device for a DVFS
> >>>>>> +	 * capable CPU. The CPU node describes its four OPPs.
> >>>>>> +	 * The cooling states possible are 0..3, and they are
> >>>>>> +	 * used as OPP indexes. The minimum cooling state is 0, which means
> >>>>>> +	 * all four OPPs can be available to the system. The maximum
> >>>>>> +	 * cooling state is 3, which means only the lowest OPPs (198MHz@0.85V)
> >>>>>> +	 * can be available in the system.
> >>>>>> +	 */
> >>>>>> +	cpu0: cpu@0 {
> >>>>>> +		...
> >>>>>> +		operating-points = <
> >>>>>> +			/* kHz    uV */
> >>>>>> +			970000  1200000
> >>>>>> +			792000  1100000
> >>>>>> +			396000  950000
> >>>>>> +			198000  850000
> >>>>>> +		>;
> >>>>>> +		cooling-min-state = <0>;
> >>>>>> +		cooling-max-state = <3>;
> >>>>>> +		#cooling-cells = <2>; /* min followed by max */
> >>>>>
> >>>>> I believe you don't need the min- and max-state properties here then. Your
> >>>>> thermal core can simply query the cpufreq driver (which would be a cooling
> >>>>> device here) about the range of states it supports
> >>>>
> >>>> This binding is not supposed to be aware of cpufreq, which is Linux
> >>>> specific implementation.
> >>>
> >>> I didn't say anything about making the binding aware of cpufreq, but
> >>> instead about getting rid of redundancy of data, that can be provided
> >>> by respective drivers anyway.
> >>
> >> There are cases in which cooling devices don't need to use all states
> >> for cooling, because either lower states does not provide cooling
> >> effectiveness or higher states must be avoided at all. So, allowing
> >> drivers to report this thermal info is possible, but questionable
> >> design, as you would be spreading the thermal info. Besides, for the
> >> example I gave, the driver would need to know board specifics, as the
> >> range of states would vary anyway across board.
> > 
> > One thing is the allowed range of cooling states supported by the
> > cooling device and another is the range of states that are usable on
> > given board. The former is a property of the cooling device that
> > in most cases is implied by its compatible string, so to eliminate the
> > bad data redundancy, you should not make the user respecify that. The
> > latter you have as a part of your cooling device specifier tuple.
> > 
> 
> So, I still don't understand what is wrong with the binding, as it is
> supposed to cover the situations you are talking about. I really don't
> see to where this discussion is leading to.

The binding is wrong in the aspect that you should not specify in device
tree any information that can be inferred by software, either by using
hardware identity or querying the hardware itself.

> 
> > As an example of this, see PWM, GPIO or IRQ bindings. You don't have
> > {pwm-channel,pwm-duty,interrupt,gpio}-{min,max} properties, because this
> > is not needed by respective PWM, GPIO or IRQ drivers, as they already
> > know these parameters.
> 
> Which are completely different devices and concepts.

Not in the aspect I'm talking about, especially PWM duty cycle.

> 
> > 
> >>
> >>>
> >>>>
> >>>> Besides, the cpufreq layer is populated by data already specified in DT.
> >>>> .
> >>>>>
> >>>>>> +	};
> >>>>>> +	...
> >>>>>> +};
> >>>>>> +
> >>>>>> +&i2c1 {
> >>>>>> +	...
> >>>>>> +	/*
> >>>>>> +	 * A simple fan controller which supports 10 speeds of operation
> >>>>>> +	 * (represented as 0-9).
> >>>>>> +	 */
> >>>>>> +	fan0: fan@0x48 {
> >>>>>> +		...
> >>>>>> +		cooling-min-state = <0>;
> >>>>>> +		cooling-max-state = <9>;
> >>>>>
> >>>>> This is similar. The fan driver will probaby know about available
> >>>>> fan speed levels and be able to report the range of states to thermal
> >>>>> core.
> >>>>
> >>>> Then we loose also the flexibility to assign cooling states to trip
> >>>> points, as described in this binding.
> >>>
> >>> I don't think you got my point correctly.
> >>>
> >>> Let's say you have a CPU, which has 4 operating points. You don't need
> >>> to specify that min state is 0 and max state is 4, because it is implied
> >>> by the list of operating points.
> >>
> >> Please read my explanation above.
> >>
> >>>
> >>> Same goes for a fan controller that has, let's say, an 8-bit PWM duty
> >>> cycle register, which in turn allows 256 different speed states. This
> >>> implies that min state for it is 0 and max state 255 and you don't need
> >>> to specify this in DT.
> >>
> >> ditto.
> >>
> >>>
> >>> Now, both a CPU and fan controller will have their thermal drivers, which
> >>> can report to the thermal core what ranges of cooling states they support,
> >>> which again makes it wrong to specify such data in DT.
> >>
> >>
> >> Please also read the examples I gave in the thermal binding. There are
> >> case that the designer may want to assign a range of states to
> >> temperature trip points. This binding is flexible enough to cover for
> >> that situation. And without the representation of these limits it would
> >> be hard to read the binding. It is not redundant data, please check the
> >> documentation.
> > 
> > I don't see any problem with just dropping the min and max properties.
> > All the use cases you listed above will still work, as you have the
> > cooling state limits included in cooling device specifier.
> 
> Because it is not about making using cases to work, but describing the
> hardware thermal limits.

I'm not talking about user's use cases here. I mean the use cases that
you mentioned above ("There are case that the designer may want to assign
a range of states to temperature trip points."). This is possible without
those useless (and wrong) min and max properties of cooling devices.

By the way, half of the binding looks to me more like a description of
a single use case of particular board (users may want to have different
trip points, cooling state ranges and polling delays, depending on their
requirements) more than hardware thermal limits. However I'm not
complaining about this, because I believe we agreed on that DT can contain
safe default configuration values as well as pure hardware description,
assuming that these defaults can be changed by the user. Is it also the
case for these thermal bindings?

Best regards,
Tomasz

