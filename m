Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3KUPtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:49:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46292 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3KUPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:49:31 -0500
Message-ID: <528E2B38.5050502@ti.com>
Date: Thu, 21 Nov 2013 11:48:08 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <25668725.sMcoUCgCKk@flatron> <52861F46.8020900@ti.com> <1574695.YAEZXuUskK@amdc1227>
In-Reply-To: <1574695.YAEZXuUskK@amdc1227>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="hX73ngiJ47FExMbsGoi3e5vIiBdj8RJFJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hX73ngiJ47FExMbsGoi3e5vIiBdj8RJFJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21-11-2013 10:57, Tomasz Figa wrote:
> On Friday 15 of November 2013 09:19:02 Eduardo Valentin wrote:
>> Hello Tomasz,
>>
>> On 14-11-2013 09:40, Tomasz Figa wrote:
>>> On Thursday 14 of November 2013 07:31:04 Eduardo Valentin wrote:
>>>> On 13-11-2013 12:57, Tomasz Figa wrote:
>>>>> Hi Eduardo,
>>>>>
>>>>
>>>> Hello Tomaz
>>>>
>>>>> On Tuesday 12 of November 2013 15:46:04 Eduardo Valentin wrote:
>>>>>> This patch introduces a device tree bindings for
>>>>>> describing the hardware thermal behavior and limits.
>>>>>> Also a parser to read and interpret the data and feed
>>>>>> it in the thermal framework is presented.
>>>>> [snip]
>>>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt=
 b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>> new file mode 100644
>>>>>> index 0000000..59f5bd2
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>> @@ -0,0 +1,586 @@
>>>>> [snip]
>>>>>> +* Cooling device nodes
>>>>>> +
>>>>>> +Cooling devices are nodes providing control on power dissipation.=
 There
>>>>>> +are essentially two ways to provide control on power dissipation.=
 First
>>>>>> +is by means of regulating device performance, which is known as p=
assive
>>>>>> +cooling. A typical passive cooling is a CPU that has dynamic volt=
age and
>>>>>> +frequency scaling (DVFS), and uses lower frequencies as cooling s=
tates.
>>>>>> +Second is by means of activating devices in order to remove
>>>>>> +the dissipated heat, which is known as active cooling, e.g. regul=
ating
>>>>>> +fan speeds. In both cases, cooling devices shall have a way to de=
termine
>>>>>> +the state of cooling in which the device is.
>>>>>> +
>>>>>> +Required properties:
>>>>>> +- cooling-min-state:	An integer indicating the smallest
>>>>>> +  Type: unsigned	cooling state accepted. Typically 0.
>>>>>> +  Size: one cell
>>>>>
>>>>> Could you explain (just in a reply) what a cooling state is and wha=
t are
>>>>> the min and max values used for?
>>>>
>>>> Cooling state is an unsigned integer which represents heat control t=
hat
>>>> a cooling device implies.
>>>
>>> OK. So you have a cooling device and it can have multiple cooling sta=
tes,
>>> like a cooling fan that has multiple speed levels. Did I understand t=
his
>>> correctly?
>>>
>>> IMHO this should be also explained in the documentation above, possib=
ly
>>> with one or two examples.
>>
>>
>> There are more than one example in this file. Even explaining why
>> cooling min and max are used, and the difference of min and max
>> properties that appear in cooling device and those present in a coolin=
g
>> specifier. Cooling devices and cooling state are described in the
>> paragraph above.
>=20
> I mean, the definition I commented about is completely confusing. You
> should rewrite it in a more readable way. For example, "Cooling state i=
s
> an unsigned integer which represents level of cooling performance of
> a thermal device." would be much more meaningful, if I understood the
> whole idea of "cooling state" correctly.

Yeah, I see your point. But I avoided describing cooling state as a
property, as you are requesting, because in fact it is not a property.
Its min and max values are properties, as you can see in the document.
Describing cooling state as a property in this document will confuse
people, because it won't be used in any part of the hardware description.=


>=20
> By example I mean simply listing one or two possible practical meanings=
,
> like "(e.g. speed level of a cooling fan, performance throttling level =
of
> CPU)".

Mark R. has already requested this example and I already wrote it. There
is a comment in the CPU example session explaining exactly what you are
asking. Have you missed that one?

>=20
>>
>>>
>>>>
>>>>>
>>>>>> +
>>>>>> +- cooling-max-state:	An integer indicating the largest
>>>>>> +  Type: unsigned	cooling state accepted.
>>>>>> +  Size: one cell
>>>>>> +
>>>>>> +- #cooling-cells:	Used to provide cooling device specific informa=
tion
>>>>>> +  Type: unsigned	while referring to it. Must be at least 2, in or=
der
>>>>>> +  Size: one cell      	to specify minimum and maximum cooling sta=
te used
>>>>>> +			in the reference. The first cell is the minimum
>>>>>> +			cooling state requested and the second cell is
>>>>>> +			the maximum cooling state requested in the reference.
>>>>>> +			See Cooling device maps section below for more details
>>>>>> +			on how consumers refer to cooling devices.
>>>>>> +
>>>>>> +* Trip points
>>>>>> +
>>>>>> +The trip node is a node to describe a point in the temperature do=
main
>>>>>> +in which the system takes an action. This node describes just the=
 point,
>>>>>> +not the action.
>>>>>> +
>>>>>> +Required properties:
>>>>>> +- temperature:		An integer indicating the trip temperature level,=

>>>>>> +  Type: signed		in millicelsius.
>>>>>> +  Size: one cell
>>>>>> +
>>>>>> +- hysteresis:		A low hysteresis value on temperature property (ab=
ove).
>>>>>> +  Type: unsigned	This is a relative value, in millicelsius.
>>>>>> +  Size: one cell
>>>>>
>>>>> What about replacing temperature and hysteresis with a single tempe=
rature
>>>>> property that can be either one cell for 0 hysteresis or two cells =
to
>>>>> specify lower and upper range of temperatures?
>>>>
>>>> What is the problem with using two properties? I think we loose
>>>> representation by gluing two properties into one just because one ce=
ll.
>>>
>>> Ranges is the representation widely used in other bindings. In additi=
on
>>
>> Well that sentence is arguable. It is not like all properties in DT ar=
e
>> standardized as ranges, is it?
>=20
> No, they are not, but property range is a common concept of representin=
g
> range of some values.
>=20
> Anyway, I won't insist on this, as it's just a minor detail. However I'=
d
> like to see comments from more people on this.
>=20
>>
>>> I believe a range is more representative - when reading a DTS you don=
't
>>> need to think whether the hysteresis is in temperature units, percent=
s or
>>> something else and also is less ambiguous, because you have clearly
>>> defined lower and upper bounds in one place.
>>
>> It is the other way around. For a person designing a thermal
>> representation for a specific board it is intuitive to think about
>> hysteresis in this case. It is a better representation because we are
>> really talking about a hysteresis here in order to give some room for
>> the system to react on temporary temperature transitions around that
>> point. It is possible to use ranges as you are suggesting, but it
>> becomes confusing.
>>
>=20
> Probably it depends on what you are used to. I'd like to see opinion
> of more people on this.
>=20
>>
>>>
>>>>
>>>>>
>>>>>> +
>>>>>> +- type:			a string containing the trip type. Supported values are=
:
>>>>>> +	"active":	A trip point to enable active cooling
>>>>>> +	"passive":	A trip point to enable passive cooling
>>>>>
>>>>> The two above seem to be implying action, as opposed to the general=

>>>>> comment about trip points.
>>>>
>>>> They do not imply action, they specify type of trip.
>>>
>>> For me "A trip point to enable active cooling" means that when this t=
rip
>>> point is crossed, active cooling must be enabled. What is it if not
>>> implying action?
>>
>> But within a board there could be more than one active cooling actions=

>> that could be done, it is not a 1 to 1 relation. Same thing applies to=

>> passive cooling. The binding does not imply a specific action. Just th=
e
>> trip type.
>=20
> I'd prefer the "active" and "passive" states to be renamed an their
> descriptions rephrased. In general, the idea of having just four trip
> point types seems like bound to a single specific hardware platform.
>=20

Not it is in fact not. These concepts are derived from an specification
that is there for decades actually, ACPI. I am not reinventing the wheel
here. There are several platforms based on that specification. The
concepts have been reused on top of non-ACPI platforms too.

> That's a wild guess, but maybe having an unsigned integer to represent
> trip point "attention level" would be a better idea?

It would be less representative and not standardized. Do you have a
class of boards, or at least a single board that is using the proposed
standard?

>=20
>>
>>>
>>>>
>>>>>
>>>>>> +	"hot":		A trip point to notify emergency
>>>>>> +	"critical":	Hardware not reliable.
>>>>>> +  Type: string
>>>>>> +
>>>>> [snip]
>>>>>> +* Examples
>>>>>> +
>>>>>> +Below are several examples on how to use thermal data descriptors=

>>>>>> +using device tree bindings:
>>>>>> +
>>>>>> +(a) - CPU thermal zone
>>>>>> +
>>>>>> +The CPU thermal zone example below describes how to setup one the=
rmal zone
>>>>>> +using one single sensor as temperature source and many cooling de=
vices and
>>>>>> +power dissipation control sources.
>>>>>> +
>>>>>> +#include <dt-bindings/thermal/thermal.h>
>>>>>> +
>>>>>> +cpus {
>>>>>> +	/*
>>>>>> +	 * Here is an example of describing a cooling device for a DVFS
>>>>>> +	 * capable CPU. The CPU node describes its four OPPs.
>>>>>> +	 * The cooling states possible are 0..3, and they are
>>>>>> +	 * used as OPP indexes. The minimum cooling state is 0, which me=
ans
>>>>>> +	 * all four OPPs can be available to the system. The maximum
>>>>>> +	 * cooling state is 3, which means only the lowest OPPs (198MHz@=
0.85V)
>>>>>> +	 * can be available in the system.
>>>>>> +	 */
>>>>>> +	cpu0: cpu@0 {
>>>>>> +		...
>>>>>> +		operating-points =3D <
>>>>>> +			/* kHz    uV */
>>>>>> +			970000  1200000
>>>>>> +			792000  1100000
>>>>>> +			396000  950000
>>>>>> +			198000  850000
>>>>>> +		>;
>>>>>> +		cooling-min-state =3D <0>;
>>>>>> +		cooling-max-state =3D <3>;
>>>>>> +		#cooling-cells =3D <2>; /* min followed by max */
>>>>>
>>>>> I believe you don't need the min- and max-state properties here the=
n. Your
>>>>> thermal core can simply query the cpufreq driver (which would be a =
cooling
>>>>> device here) about the range of states it supports
>>>>
>>>> This binding is not supposed to be aware of cpufreq, which is Linux
>>>> specific implementation.
>>>
>>> I didn't say anything about making the binding aware of cpufreq, but
>>> instead about getting rid of redundancy of data, that can be provided=

>>> by respective drivers anyway.
>>
>> There are cases in which cooling devices don't need to use all states
>> for cooling, because either lower states does not provide cooling
>> effectiveness or higher states must be avoided at all. So, allowing
>> drivers to report this thermal info is possible, but questionable
>> design, as you would be spreading the thermal info. Besides, for the
>> example I gave, the driver would need to know board specifics, as the
>> range of states would vary anyway across board.
>=20
> One thing is the allowed range of cooling states supported by the
> cooling device and another is the range of states that are usable on
> given board. The former is a property of the cooling device that
> in most cases is implied by its compatible string, so to eliminate the
> bad data redundancy, you should not make the user respecify that. The
> latter you have as a part of your cooling device specifier tuple.
>=20

So, I still don't understand what is wrong with the binding, as it is
supposed to cover the situations you are talking about. I really don't
see to where this discussion is leading to.

> As an example of this, see PWM, GPIO or IRQ bindings. You don't have
> {pwm-channel,pwm-duty,interrupt,gpio}-{min,max} properties, because thi=
s
> is not needed by respective PWM, GPIO or IRQ drivers, as they already
> know these parameters.

Which are completely different devices and concepts.

>=20
>>
>>>
>>>>
>>>> Besides, the cpufreq layer is populated by data already specified in=
 DT.
>>>> .
>>>>>
>>>>>> +	};
>>>>>> +	...
>>>>>> +};
>>>>>> +
>>>>>> +&i2c1 {
>>>>>> +	...
>>>>>> +	/*
>>>>>> +	 * A simple fan controller which supports 10 speeds of operation=

>>>>>> +	 * (represented as 0-9).
>>>>>> +	 */
>>>>>> +	fan0: fan@0x48 {
>>>>>> +		...
>>>>>> +		cooling-min-state =3D <0>;
>>>>>> +		cooling-max-state =3D <9>;
>>>>>
>>>>> This is similar. The fan driver will probaby know about available
>>>>> fan speed levels and be able to report the range of states to therm=
al
>>>>> core.
>>>>
>>>> Then we loose also the flexibility to assign cooling states to trip
>>>> points, as described in this binding.
>>>
>>> I don't think you got my point correctly.
>>>
>>> Let's say you have a CPU, which has 4 operating points. You don't nee=
d
>>> to specify that min state is 0 and max state is 4, because it is impl=
ied
>>> by the list of operating points.
>>
>> Please read my explanation above.
>>
>>>
>>> Same goes for a fan controller that has, let's say, an 8-bit PWM duty=

>>> cycle register, which in turn allows 256 different speed states. This=

>>> implies that min state for it is 0 and max state 255 and you don't ne=
ed
>>> to specify this in DT.
>>
>> ditto.
>>
>>>
>>> Now, both a CPU and fan controller will have their thermal drivers, w=
hich
>>> can report to the thermal core what ranges of cooling states they sup=
port,
>>> which again makes it wrong to specify such data in DT.
>>
>>
>> Please also read the examples I gave in the thermal binding. There are=

>> case that the designer may want to assign a range of states to
>> temperature trip points. This binding is flexible enough to cover for
>> that situation. And without the representation of these limits it woul=
d
>> be hard to read the binding. It is not redundant data, please check th=
e
>> documentation.
>=20
> I don't see any problem with just dropping the min and max properties.
> All the use cases you listed above will still work, as you have the
> cooling state limits included in cooling device specifier.

Because it is not about making using cases to work, but describing the
hardware thermal limits.

>=20
> Best regards,
> Tomasz
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--hX73ngiJ47FExMbsGoi3e5vIiBdj8RJFJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKOKzgACgkQCXcVR3XQvP0fOgEA4dm5abqh2kG3VSXwPoYXG3ON
cgFlaQFaGmL9ByAyuhgA/3+kj19NKEApF4VUYpsxAN3JJ2MH/TloBlujFLW82R7Q
=ul3m
-----END PGP SIGNATURE-----

--hX73ngiJ47FExMbsGoi3e5vIiBdj8RJFJ--
