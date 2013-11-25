Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3KYPb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:31:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60630 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409Ab3KYPbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:31:21 -0500
Date: Mon, 25 Nov 2013 15:31:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
Message-ID: <20131125153118.GG32081@e106331-lin.cambridge.arm.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1574695.YAEZXuUskK@amdc1227>
 <528E2B38.5050502@ti.com>
 <5333248.b0sPp1ZZXY@amdc1227>
 <528F4F1E.60903@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F4F1E.60903@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:33:34PM +0000, Eduardo Valentin wrote:
> 
> Hello Tomasz,
> 
> On 21-11-2013 12:32, Tomasz Figa wrote:
> > On Thursday 21 of November 2013 11:48:08 Eduardo Valentin wrote:
> >> On 21-11-2013 10:57, Tomasz Figa wrote:
> >>> On Friday 15 of November 2013 09:19:02 Eduardo Valentin wrote:
> >>>> Hello Tomasz,
> >>>>
> >>>> On 14-11-2013 09:40, Tomasz Figa wrote:
> >>>>> On Thursday 14 of November 2013 07:31:04 Eduardo Valentin wrote:
> >>>>>> On 13-11-2013 12:57, Tomasz Figa wrote:
> >>>>>>> Hi Eduardo,
> >>>>>>>
> >>>>>>
> >>>>>> Hello Tomaz
> >>>>>>
> >>>>>>> On Tuesday 12 of November 2013 15:46:04 Eduardo Valentin wrote:
> >>>>>>>> This patch introduces a device tree bindings for
> >>>>>>>> describing the hardware thermal behavior and limits.
> >>>>>>>> Also a parser to read and interpret the data and feed
> >>>>>>>> it in the thermal framework is presented.
> >>>>>>> [snip]
> >>>>>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>>>>>> new file mode 100644
> >>>>>>>> index 0000000..59f5bd2
> >>>>>>>> --- /dev/null
> >>>>>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>>>>>> @@ -0,0 +1,586 @@
> >>>>>>> [snip]
> >>>>>>>> +* Cooling device nodes
> >>>>>>>> +
> >>>>>>>> +Cooling devices are nodes providing control on power dissipation. There
> >>>>>>>> +are essentially two ways to provide control on power dissipation. First
> >>>>>>>> +is by means of regulating device performance, which is known as passive
> >>>>>>>> +cooling. A typical passive cooling is a CPU that has dynamic voltage and
> >>>>>>>> +frequency scaling (DVFS), and uses lower frequencies as cooling states.
> >>>>>>>> +Second is by means of activating devices in order to remove
> >>>>>>>> +the dissipated heat, which is known as active cooling, e.g. regulating
> >>>>>>>> +fan speeds. In both cases, cooling devices shall have a way to determine
> >>>>>>>> +the state of cooling in which the device is.
> >>>>>>>> +
> >>>>>>>> +Required properties:
> >>>>>>>> +- cooling-min-state:	An integer indicating the smallest
> >>>>>>>> +  Type: unsigned	cooling state accepted. Typically 0.
> >>>>>>>> +  Size: one cell
> >>>>>>>
> >>>>>>> Could you explain (just in a reply) what a cooling state is and what are
> >>>>>>> the min and max values used for?
> >>>>>>
> >>>>>> Cooling state is an unsigned integer which represents heat control that
> >>>>>> a cooling device implies.
> >>>>>
> >>>>> OK. So you have a cooling device and it can have multiple cooling states,
> >>>>> like a cooling fan that has multiple speed levels. Did I understand this
> >>>>> correctly?
> >>>>>
> >>>>> IMHO this should be also explained in the documentation above, possibly
> >>>>> with one or two examples.
> >>>>
> >>>>
> >>>> There are more than one example in this file. Even explaining why
> >>>> cooling min and max are used, and the difference of min and max
> >>>> properties that appear in cooling device and those present in a cooling
> >>>> specifier. Cooling devices and cooling state are described in the
> >>>> paragraph above.
> >>>
> >>> I mean, the definition I commented about is completely confusing. You
> >>> should rewrite it in a more readable way. For example, "Cooling state is
> >>> an unsigned integer which represents level of cooling performance of
> >>> a thermal device." would be much more meaningful, if I understood the
> >>> whole idea of "cooling state" correctly.
> >>
> >> Yeah, I see your point. But I avoided describing cooling state as a
> >> property, as you are requesting, because in fact it is not a property.
> >> Its min and max values are properties, as you can see in the document.
> >> Describing cooling state as a property in this document will confuse
> >> people, because it won't be used in any part of the hardware description.
> > 
> > Sorry, I'm not getting your point here. What kind of "property" are you
> > talking about? Is there anything wrong with my proposed alternative
> > description?
> 
> Again, I simply mean describing cooling state the way you are proposing
> may confuse (as in this discussing) that it is a device property, which
> is not in this binding.

I think all that Tomasz is arguing for is an inline definition of what a
"cooling state" is. I don't think that will lead to that much confusion.

How about something like:

Any cooling device has a range of cooling states (i.e. different levels
of heat dissipation). For example a fan's cooling states correspond to
the different fan speeds possible. Cooling states are referred to by
single unsigned integers, where larger numbers mean greate heat
dissipation. The precise set of cooling states associated with a device
(as referred to be the cooling-min-state and cooling-max-state
properties) should be defined in a particular device's binding.


> 
> > 
> >>
> >>>
> >>> By example I mean simply listing one or two possible practical meanings,
> >>> like "(e.g. speed level of a cooling fan, performance throttling level of
> >>> CPU)".
> >>
> >> Mark R. has already requested this example and I already wrote it. There
> >> is a comment in the CPU example session explaining exactly what you are
> >> asking. Have you missed that one?
> > 
> > No, I haven't. But a binding usage example is a separate thing from what
> > I mean. When you read some text from top to bottom, you would prefer
> > not to need to jump down and up to understand what you read. That's
> > why adding one additional sentence, just quickly showing the meaning
> > of something, is rather justified.
> 
> So, it is just a matter of taste on how you want the text organized?
> Again, the info is there.

I think a brief inline description would be helpful. I am happy for it
to be in a later amendment.

[...]

> > On a lot of mobile phones, there is also a low temperature trip point
> > (usually tens of degrees below zero) to shut down the phone when the
> > temperature falls down below its minimal operating temperature. Although,
> > one could use "critical" trip point for this, how would you distinguish
> > hot and cold critical points?
> > 
> 
> I think you already provided the answer.
> 
> > Similarly, there is often a threshold (also below 0C) under which battery
> > charging process should be disabled.
> > 
> > Does it mean that we also need "cold" and "freezing" trip point types?
> > 
> 
> What is the name of the board/phone/tablet/mobile device we are talking
> about?

I think if these are needed the set of types can be extended, no?

> 
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>> +	"hot":		A trip point to notify emergency
> >>>>>>>> +	"critical":	Hardware not reliable.
> >>>>>>>> +  Type: string
> >>>>>>>> +
> >>>>>>> [snip]
> >>>>>>>> +* Examples
> >>>>>>>> +
> >>>>>>>> +Below are several examples on how to use thermal data descriptors
> >>>>>>>> +using device tree bindings:
> >>>>>>>> +
> >>>>>>>> +(a) - CPU thermal zone
> >>>>>>>> +
> >>>>>>>> +The CPU thermal zone example below describes how to setup one thermal zone
> >>>>>>>> +using one single sensor as temperature source and many cooling devices and
> >>>>>>>> +power dissipation control sources.
> >>>>>>>> +
> >>>>>>>> +#include <dt-bindings/thermal/thermal.h>
> >>>>>>>> +
> >>>>>>>> +cpus {
> >>>>>>>> +	/*
> >>>>>>>> +	 * Here is an example of describing a cooling device for a DVFS
> >>>>>>>> +	 * capable CPU. The CPU node describes its four OPPs.
> >>>>>>>> +	 * The cooling states possible are 0..3, and they are
> >>>>>>>> +	 * used as OPP indexes. The minimum cooling state is 0, which means
> >>>>>>>> +	 * all four OPPs can be available to the system. The maximum
> >>>>>>>> +	 * cooling state is 3, which means only the lowest OPPs (198MHz@0.85V)
> >>>>>>>> +	 * can be available in the system.
> >>>>>>>> +	 */
> >>>>>>>> +	cpu0: cpu@0 {
> >>>>>>>> +		...
> >>>>>>>> +		operating-points = <
> >>>>>>>> +			/* kHz    uV */
> >>>>>>>> +			970000  1200000
> >>>>>>>> +			792000  1100000
> >>>>>>>> +			396000  950000
> >>>>>>>> +			198000  850000
> >>>>>>>> +		>;
> >>>>>>>> +		cooling-min-state = <0>;
> >>>>>>>> +		cooling-max-state = <3>;
> >>>>>>>> +		#cooling-cells = <2>; /* min followed by max */
> >>>>>>>
> >>>>>>> I believe you don't need the min- and max-state properties here then. Your
> >>>>>>> thermal core can simply query the cpufreq driver (which would be a cooling
> >>>>>>> device here) about the range of states it supports
> >>>>>>
> >>>>>> This binding is not supposed to be aware of cpufreq, which is Linux
> >>>>>> specific implementation.
> >>>>>
> >>>>> I didn't say anything about making the binding aware of cpufreq, but
> >>>>> instead about getting rid of redundancy of data, that can be provided
> >>>>> by respective drivers anyway.
> >>>>
> >>>> There are cases in which cooling devices don't need to use all states
> >>>> for cooling, because either lower states does not provide cooling
> >>>> effectiveness or higher states must be avoided at all. So, allowing
> >>>> drivers to report this thermal info is possible, but questionable
> >>>> design, as you would be spreading the thermal info. Besides, for the
> >>>> example I gave, the driver would need to know board specifics, as the
> >>>> range of states would vary anyway across board.
> >>>
> >>> One thing is the allowed range of cooling states supported by the
> >>> cooling device and another is the range of states that are usable on
> >>> given board. The former is a property of the cooling device that
> >>> in most cases is implied by its compatible string, so to eliminate the
> >>> bad data redundancy, you should not make the user respecify that. The
> >>> latter you have as a part of your cooling device specifier tuple.
> >>>
> >>
> >> So, I still don't understand what is wrong with the binding, as it is
> >> supposed to cover the situations you are talking about. I really don't
> >> see to where this discussion is leading to.
> > 
> > The binding is wrong in the aspect that you should not specify in device
> > tree any information that can be inferred by software, either by using
> > hardware identity or querying the hardware itself.
> > 

It's not quite a probable property though. It's more of a
system-specific recommendation. A system intended for use as an
always-on HTPC might recommend always having a quiet fan on at a low
speed rather than suddenly bringing it up at high speed when the board
gets hot (and making a lot of noise that spoils the experience).

I think the question is more is this appropriate for DT? I can't see a
better place to put it without having board files. It's also worth
noting that we can add the appropriate knobs to override this if
preferred.

> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>> Besides, the cpufreq layer is populated by data already specified in DT.
> >>>>>> .
> >>>>>>>
> >>>>>>>> +	};
> >>>>>>>> +	...
> >>>>>>>> +};
> >>>>>>>> +
> >>>>>>>> +&i2c1 {
> >>>>>>>> +	...
> >>>>>>>> +	/*
> >>>>>>>> +	 * A simple fan controller which supports 10 speeds of operation
> >>>>>>>> +	 * (represented as 0-9).
> >>>>>>>> +	 */
> >>>>>>>> +	fan0: fan@0x48 {
> >>>>>>>> +		...
> >>>>>>>> +		cooling-min-state = <0>;
> >>>>>>>> +		cooling-max-state = <9>;
> >>>>>>>
> >>>>>>> This is similar. The fan driver will probaby know about available
> >>>>>>> fan speed levels and be able to report the range of states to thermal
> >>>>>>> core.
> >>>>>>
> >>>>>> Then we loose also the flexibility to assign cooling states to trip
> >>>>>> points, as described in this binding.
> >>>>>
> >>>>> I don't think you got my point correctly.
> >>>>>
> >>>>> Let's say you have a CPU, which has 4 operating points. You don't need
> >>>>> to specify that min state is 0 and max state is 4, because it is implied
> >>>>> by the list of operating points.
> >>>>
> >>>> Please read my explanation above.
> >>>>
> >>>>>
> >>>>> Same goes for a fan controller that has, let's say, an 8-bit PWM duty
> >>>>> cycle register, which in turn allows 256 different speed states. This
> >>>>> implies that min state for it is 0 and max state 255 and you don't need
> >>>>> to specify this in DT.
> >>>>
> >>>> ditto.
> >>>>
> >>>>>
> >>>>> Now, both a CPU and fan controller will have their thermal drivers, which
> >>>>> can report to the thermal core what ranges of cooling states they support,
> >>>>> which again makes it wrong to specify such data in DT.
> >>>>
> >>>>
> >>>> Please also read the examples I gave in the thermal binding. There are
> >>>> case that the designer may want to assign a range of states to
> >>>> temperature trip points. This binding is flexible enough to cover for
> >>>> that situation. And without the representation of these limits it would
> >>>> be hard to read the binding. It is not redundant data, please check the
> >>>> documentation.
> >>>
> >>> I don't see any problem with just dropping the min and max properties.
> >>> All the use cases you listed above will still work, as you have the
> >>> cooling state limits included in cooling device specifier.
> >>
> >> Because it is not about making using cases to work, but describing the
> >> hardware thermal limits.
> > 
> > I'm not talking about user's use cases here. I mean the use cases that
> > you mentioned above ("There are case that the designer may want to assign
> > a range of states to temperature trip points."). This is possible without
> > those useless (and wrong) min and max properties of cooling devices.
> > 
> > By the way, half of the binding looks to me more like a description of
> > a single use case of particular board (users may want to have different
> > trip points, cooling state ranges and polling delays, depending on their
> > requirements) more than hardware thermal limits. However I'm not
> > complaining about this, because I believe we agreed on that DT can contain
> > safe default configuration values as well as pure hardware description,
> > assuming that these defaults can be changed by the user. Is it also the
> > case for these thermal bindings?
> 
> No.

I would expect that at some point someone is going to want to mess with
these values, and I they should be allowed to (within reason). While
it's likely you can under-cool a device, it's not so likely that you can
over-cool it...

However, I think that can change in future.

Thanks,
Mark.
