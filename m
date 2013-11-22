Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3KVMe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:34:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45997 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KVMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:34:56 -0500
Message-ID: <528F4F1E.60903@ti.com>
Date: Fri, 22 Nov 2013 08:33:34 -0400
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
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1574695.YAEZXuUskK@amdc1227> <528E2B38.5050502@ti.com> <5333248.b0sPp1ZZXY@amdc1227>
In-Reply-To: <5333248.b0sPp1ZZXY@amdc1227>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="e8cxxkH2sKJV4Xtl5JwleMpncKxdhcJhT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e8cxxkH2sKJV4Xtl5JwleMpncKxdhcJhT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Hello Tomasz,

On 21-11-2013 12:32, Tomasz Figa wrote:
> On Thursday 21 of November 2013 11:48:08 Eduardo Valentin wrote:
>> On 21-11-2013 10:57, Tomasz Figa wrote:
>>> On Friday 15 of November 2013 09:19:02 Eduardo Valentin wrote:
>>>> Hello Tomasz,
>>>>
>>>> On 14-11-2013 09:40, Tomasz Figa wrote:
>>>>> On Thursday 14 of November 2013 07:31:04 Eduardo Valentin wrote:
>>>>>> On 13-11-2013 12:57, Tomasz Figa wrote:
>>>>>>> Hi Eduardo,
>>>>>>>
>>>>>>
>>>>>> Hello Tomaz
>>>>>>
>>>>>>> On Tuesday 12 of November 2013 15:46:04 Eduardo Valentin wrote:
>>>>>>>> This patch introduces a device tree bindings for
>>>>>>>> describing the hardware thermal behavior and limits.
>>>>>>>> Also a parser to read and interpret the data and feed
>>>>>>>> it in the thermal framework is presented.
>>>>>>> [snip]
>>>>>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.t=
xt b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>>>> new file mode 100644
>>>>>>>> index 0000000..59f5bd2
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>>>> @@ -0,0 +1,586 @@
>>>>>>> [snip]
>>>>>>>> +* Cooling device nodes
>>>>>>>> +
>>>>>>>> +Cooling devices are nodes providing control on power dissipatio=
n. There
>>>>>>>> +are essentially two ways to provide control on power dissipatio=
n. First
>>>>>>>> +is by means of regulating device performance, which is known as=
 passive
>>>>>>>> +cooling. A typical passive cooling is a CPU that has dynamic vo=
ltage and
>>>>>>>> +frequency scaling (DVFS), and uses lower frequencies as cooling=
 states.
>>>>>>>> +Second is by means of activating devices in order to remove
>>>>>>>> +the dissipated heat, which is known as active cooling, e.g. reg=
ulating
>>>>>>>> +fan speeds. In both cases, cooling devices shall have a way to =
determine
>>>>>>>> +the state of cooling in which the device is.
>>>>>>>> +
>>>>>>>> +Required properties:
>>>>>>>> +- cooling-min-state:	An integer indicating the smallest
>>>>>>>> +  Type: unsigned	cooling state accepted. Typically 0.
>>>>>>>> +  Size: one cell
>>>>>>>
>>>>>>> Could you explain (just in a reply) what a cooling state is and w=
hat are
>>>>>>> the min and max values used for?
>>>>>>
>>>>>> Cooling state is an unsigned integer which represents heat control=
 that
>>>>>> a cooling device implies.
>>>>>
>>>>> OK. So you have a cooling device and it can have multiple cooling s=
tates,
>>>>> like a cooling fan that has multiple speed levels. Did I understand=
 this
>>>>> correctly?
>>>>>
>>>>> IMHO this should be also explained in the documentation above, poss=
ibly
>>>>> with one or two examples.
>>>>
>>>>
>>>> There are more than one example in this file. Even explaining why
>>>> cooling min and max are used, and the difference of min and max
>>>> properties that appear in cooling device and those present in a cool=
ing
>>>> specifier. Cooling devices and cooling state are described in the
>>>> paragraph above.
>>>
>>> I mean, the definition I commented about is completely confusing. You=

>>> should rewrite it in a more readable way. For example, "Cooling state=
 is
>>> an unsigned integer which represents level of cooling performance of
>>> a thermal device." would be much more meaningful, if I understood the=

>>> whole idea of "cooling state" correctly.
>>
>> Yeah, I see your point. But I avoided describing cooling state as a
>> property, as you are requesting, because in fact it is not a property.=

>> Its min and max values are properties, as you can see in the document.=

>> Describing cooling state as a property in this document will confuse
>> people, because it won't be used in any part of the hardware descripti=
on.
>=20
> Sorry, I'm not getting your point here. What kind of "property" are you=

> talking about? Is there anything wrong with my proposed alternative
> description?

Again, I simply mean describing cooling state the way you are proposing
may confuse (as in this discussing) that it is a device property, which
is not in this binding.

>=20
>>
>>>
>>> By example I mean simply listing one or two possible practical meanin=
gs,
>>> like "(e.g. speed level of a cooling fan, performance throttling leve=
l of
>>> CPU)".
>>
>> Mark R. has already requested this example and I already wrote it. The=
re
>> is a comment in the CPU example session explaining exactly what you ar=
e
>> asking. Have you missed that one?
>=20
> No, I haven't. But a binding usage example is a separate thing from wha=
t
> I mean. When you read some text from top to bottom, you would prefer
> not to need to jump down and up to understand what you read. That's
> why adding one additional sentence, just quickly showing the meaning
> of something, is rather justified.

So, it is just a matter of taste on how you want the text organized?
Again, the info is there.

>=20
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>>> +
>>>>>>>> +- cooling-max-state:	An integer indicating the largest
>>>>>>>> +  Type: unsigned	cooling state accepted.
>>>>>>>> +  Size: one cell
>>>>>>>> +
>>>>>>>> +- #cooling-cells:	Used to provide cooling device specific infor=
mation
>>>>>>>> +  Type: unsigned	while referring to it. Must be at least 2, in =
order
>>>>>>>> +  Size: one cell      	to specify minimum and maximum cooling s=
tate used
>>>>>>>> +			in the reference. The first cell is the minimum
>>>>>>>> +			cooling state requested and the second cell is
>>>>>>>> +			the maximum cooling state requested in the reference.
>>>>>>>> +			See Cooling device maps section below for more details
>>>>>>>> +			on how consumers refer to cooling devices.
>>>>>>>> +
>>>>>>>> +* Trip points
>>>>>>>> +
>>>>>>>> +The trip node is a node to describe a point in the temperature =
domain
>>>>>>>> +in which the system takes an action. This node describes just t=
he point,
>>>>>>>> +not the action.
>>>>>>>> +
>>>>>>>> +Required properties:
>>>>>>>> +- temperature:		An integer indicating the trip temperature leve=
l,
>>>>>>>> +  Type: signed		in millicelsius.
>>>>>>>> +  Size: one cell
>>>>>>>> +
>>>>>>>> +- hysteresis:		A low hysteresis value on temperature property (=
above).
>>>>>>>> +  Type: unsigned	This is a relative value, in millicelsius.
>>>>>>>> +  Size: one cell
>>>>>>>
>>>>>>> What about replacing temperature and hysteresis with a single tem=
perature
>>>>>>> property that can be either one cell for 0 hysteresis or two cell=
s to
>>>>>>> specify lower and upper range of temperatures?
>>>>>>
>>>>>> What is the problem with using two properties? I think we loose
>>>>>> representation by gluing two properties into one just because one =
cell.
>>>>>
>>>>> Ranges is the representation widely used in other bindings. In addi=
tion
>>>>
>>>> Well that sentence is arguable. It is not like all properties in DT =
are
>>>> standardized as ranges, is it?
>>>
>>> No, they are not, but property range is a common concept of represent=
ing
>>> range of some values.
>>>
>>> Anyway, I won't insist on this, as it's just a minor detail. However =
I'd
>>> like to see comments from more people on this.
>>>
>>>>
>>>>> I believe a range is more representative - when reading a DTS you d=
on't
>>>>> need to think whether the hysteresis is in temperature units, perce=
nts or
>>>>> something else and also is less ambiguous, because you have clearly=

>>>>> defined lower and upper bounds in one place.
>>>>
>>>> It is the other way around. For a person designing a thermal
>>>> representation for a specific board it is intuitive to think about
>>>> hysteresis in this case. It is a better representation because we ar=
e
>>>> really talking about a hysteresis here in order to give some room fo=
r
>>>> the system to react on temporary temperature transitions around that=

>>>> point. It is possible to use ranges as you are suggesting, but it
>>>> becomes confusing.
>>>>
>>>
>>> Probably it depends on what you are used to. I'd like to see opinion
>>> of more people on this.
>>>
>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>>> +
>>>>>>>> +- type:			a string containing the trip type. Supported values a=
re:
>>>>>>>> +	"active":	A trip point to enable active cooling
>>>>>>>> +	"passive":	A trip point to enable passive cooling
>>>>>>>
>>>>>>> The two above seem to be implying action, as opposed to the gener=
al
>>>>>>> comment about trip points.
>>>>>>
>>>>>> They do not imply action, they specify type of trip.
>>>>>
>>>>> For me "A trip point to enable active cooling" means that when this=
 trip
>>>>> point is crossed, active cooling must be enabled. What is it if not=

>>>>> implying action?
>>>>
>>>> But within a board there could be more than one active cooling actio=
ns
>>>> that could be done, it is not a 1 to 1 relation. Same thing applies =
to
>>>> passive cooling. The binding does not imply a specific action. Just =
the
>>>> trip type.
>>>
>>> I'd prefer the "active" and "passive" states to be renamed an their
>>> descriptions rephrased. In general, the idea of having just four trip=

>>> point types seems like bound to a single specific hardware platform.
>>>
>>
>> Not it is in fact not. These concepts are derived from an specificatio=
n
>> that is there for decades actually, ACPI. I am not reinventing the whe=
el
>> here. There are several platforms based on that specification. The
>> concepts have been reused on top of non-ACPI platforms too.
>=20
> Well, ACPI seems to be designed primarily with PC-class hardware in min=
d,
> such as desktops and notebooks, not small mobile devices, such as mobil=
e
> phones and it should not be considered as a reference design, especiall=
y
> on such hardware, which it was not designed for.

Looks like you missed my point. Let me try, again, to help you
understand. This binding is based on description and modeling that has
worked and discussed already, on different platforms.

Besides, I don't think the discussion is about  applicability of ACPI on
mobile device or not. Besides, because it has been designed to a
population of devices it does not imply part of it is not applicable to
other. Just look to how linux ARM based PM support has evolved last
years and you understand what I mean.

>=20
>>
>>> That's a wild guess, but maybe having an unsigned integer to represen=
t
>>> trip point "attention level" would be a better idea?
>>
>> It would be less representative and not standardized. Do you have a
>> class of boards, or at least a single board that is using the proposed=

>> standard?
>=20
> Well, I don't have any particular board in mind, but an use case instea=
d.

I see. How about if we spend our time on practical cases? Oh I see now,
maybe this is the main reason why this discussion is already taking too
long. Seriously, although I enjoy discussing hypothetical scenarios or
non-existing hardware or  hardware from the future, the proposal of this
patch series is, if it is not clear to you: (a) be based on existing
problems (b) make sure we continue the support of existing hardware.
Once more, I am not reinventing the wheel.

Please, bring the hardware specification or board description so we can
be pragmatic. Even if it is not launched you can still describe the
scenario. But please, don't waste our time on some non-existing
problem/scenario.

> On a lot of mobile phones, there is also a low temperature trip point
> (usually tens of degrees below zero) to shut down the phone when the
> temperature falls down below its minimal operating temperature. Althoug=
h,
> one could use "critical" trip point for this, how would you distinguish=

> hot and cold critical points?
>=20

I think you already provided the answer.

> Similarly, there is often a threshold (also below 0C) under which batte=
ry
> charging process should be disabled.
>=20
> Does it mean that we also need "cold" and "freezing" trip point types?
>=20

What is the name of the board/phone/tablet/mobile device we are talking
about?

>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>>> +	"hot":		A trip point to notify emergency
>>>>>>>> +	"critical":	Hardware not reliable.
>>>>>>>> +  Type: string
>>>>>>>> +
>>>>>>> [snip]
>>>>>>>> +* Examples
>>>>>>>> +
>>>>>>>> +Below are several examples on how to use thermal data descripto=
rs
>>>>>>>> +using device tree bindings:
>>>>>>>> +
>>>>>>>> +(a) - CPU thermal zone
>>>>>>>> +
>>>>>>>> +The CPU thermal zone example below describes how to setup one t=
hermal zone
>>>>>>>> +using one single sensor as temperature source and many cooling =
devices and
>>>>>>>> +power dissipation control sources.
>>>>>>>> +
>>>>>>>> +#include <dt-bindings/thermal/thermal.h>
>>>>>>>> +
>>>>>>>> +cpus {
>>>>>>>> +	/*
>>>>>>>> +	 * Here is an example of describing a cooling device for a DVF=
S
>>>>>>>> +	 * capable CPU. The CPU node describes its four OPPs.
>>>>>>>> +	 * The cooling states possible are 0..3, and they are
>>>>>>>> +	 * used as OPP indexes. The minimum cooling state is 0, which =
means
>>>>>>>> +	 * all four OPPs can be available to the system. The maximum
>>>>>>>> +	 * cooling state is 3, which means only the lowest OPPs (198MH=
z@0.85V)
>>>>>>>> +	 * can be available in the system.
>>>>>>>> +	 */
>>>>>>>> +	cpu0: cpu@0 {
>>>>>>>> +		...
>>>>>>>> +		operating-points =3D <
>>>>>>>> +			/* kHz    uV */
>>>>>>>> +			970000  1200000
>>>>>>>> +			792000  1100000
>>>>>>>> +			396000  950000
>>>>>>>> +			198000  850000
>>>>>>>> +		>;
>>>>>>>> +		cooling-min-state =3D <0>;
>>>>>>>> +		cooling-max-state =3D <3>;
>>>>>>>> +		#cooling-cells =3D <2>; /* min followed by max */
>>>>>>>
>>>>>>> I believe you don't need the min- and max-state properties here t=
hen. Your
>>>>>>> thermal core can simply query the cpufreq driver (which would be =
a cooling
>>>>>>> device here) about the range of states it supports
>>>>>>
>>>>>> This binding is not supposed to be aware of cpufreq, which is Linu=
x
>>>>>> specific implementation.
>>>>>
>>>>> I didn't say anything about making the binding aware of cpufreq, bu=
t
>>>>> instead about getting rid of redundancy of data, that can be provid=
ed
>>>>> by respective drivers anyway.
>>>>
>>>> There are cases in which cooling devices don't need to use all state=
s
>>>> for cooling, because either lower states does not provide cooling
>>>> effectiveness or higher states must be avoided at all. So, allowing
>>>> drivers to report this thermal info is possible, but questionable
>>>> design, as you would be spreading the thermal info. Besides, for the=

>>>> example I gave, the driver would need to know board specifics, as th=
e
>>>> range of states would vary anyway across board.
>>>
>>> One thing is the allowed range of cooling states supported by the
>>> cooling device and another is the range of states that are usable on
>>> given board. The former is a property of the cooling device that
>>> in most cases is implied by its compatible string, so to eliminate th=
e
>>> bad data redundancy, you should not make the user respecify that. The=

>>> latter you have as a part of your cooling device specifier tuple.
>>>
>>
>> So, I still don't understand what is wrong with the binding, as it is
>> supposed to cover the situations you are talking about. I really don't=

>> see to where this discussion is leading to.
>=20
> The binding is wrong in the aspect that you should not specify in devic=
e
> tree any information that can be inferred by software, either by using
> hardware identity or querying the hardware itself.
>=20



You miss the point that we are talking about thermal limits, not
hardware functionality.



>>
>>> As an example of this, see PWM, GPIO or IRQ bindings. You don't have
>>> {pwm-channel,pwm-duty,interrupt,gpio}-{min,max} properties, because t=
his
>>> is not needed by respective PWM, GPIO or IRQ drivers, as they already=

>>> know these parameters.
>>
>> Which are completely different devices and concepts.
>=20
> Not in the aspect I'm talking about, especially PWM duty cycle.
>=20

ditto.


>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> Besides, the cpufreq layer is populated by data already specified =
in DT.
>>>>>> .
>>>>>>>
>>>>>>>> +	};
>>>>>>>> +	...
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +&i2c1 {
>>>>>>>> +	...
>>>>>>>> +	/*
>>>>>>>> +	 * A simple fan controller which supports 10 speeds of operati=
on
>>>>>>>> +	 * (represented as 0-9).
>>>>>>>> +	 */
>>>>>>>> +	fan0: fan@0x48 {
>>>>>>>> +		...
>>>>>>>> +		cooling-min-state =3D <0>;
>>>>>>>> +		cooling-max-state =3D <9>;
>>>>>>>
>>>>>>> This is similar. The fan driver will probaby know about available=

>>>>>>> fan speed levels and be able to report the range of states to the=
rmal
>>>>>>> core.
>>>>>>
>>>>>> Then we loose also the flexibility to assign cooling states to tri=
p
>>>>>> points, as described in this binding.
>>>>>
>>>>> I don't think you got my point correctly.
>>>>>
>>>>> Let's say you have a CPU, which has 4 operating points. You don't n=
eed
>>>>> to specify that min state is 0 and max state is 4, because it is im=
plied
>>>>> by the list of operating points.
>>>>
>>>> Please read my explanation above.
>>>>
>>>>>
>>>>> Same goes for a fan controller that has, let's say, an 8-bit PWM du=
ty
>>>>> cycle register, which in turn allows 256 different speed states. Th=
is
>>>>> implies that min state for it is 0 and max state 255 and you don't =
need
>>>>> to specify this in DT.
>>>>
>>>> ditto.
>>>>
>>>>>
>>>>> Now, both a CPU and fan controller will have their thermal drivers,=
 which
>>>>> can report to the thermal core what ranges of cooling states they s=
upport,
>>>>> which again makes it wrong to specify such data in DT.
>>>>
>>>>
>>>> Please also read the examples I gave in the thermal binding. There a=
re
>>>> case that the designer may want to assign a range of states to
>>>> temperature trip points. This binding is flexible enough to cover fo=
r
>>>> that situation. And without the representation of these limits it wo=
uld
>>>> be hard to read the binding. It is not redundant data, please check =
the
>>>> documentation.
>>>
>>> I don't see any problem with just dropping the min and max properties=
=2E
>>> All the use cases you listed above will still work, as you have the
>>> cooling state limits included in cooling device specifier.
>>
>> Because it is not about making using cases to work, but describing the=

>> hardware thermal limits.
>=20
> I'm not talking about user's use cases here. I mean the use cases that
> you mentioned above ("There are case that the designer may want to assi=
gn
> a range of states to temperature trip points."). This is possible witho=
ut
> those useless (and wrong) min and max properties of cooling devices.
>=20
> By the way, half of the binding looks to me more like a description of
> a single use case of particular board (users may want to have different=

> trip points, cooling state ranges and polling delays, depending on thei=
r
> requirements) more than hardware thermal limits. However I'm not
> complaining about this, because I believe we agreed on that DT can cont=
ain
> safe default configuration values as well as pure hardware description,=

> assuming that these defaults can be changed by the user. Is it also the=

> case for these thermal bindings?

No.

>=20
> Best regards,
> Tomasz
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--e8cxxkH2sKJV4Xtl5JwleMpncKxdhcJhT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKPTx4ACgkQCXcVR3XQvP0IKgEA3Ei51n5ppoV8r9KhtdKYd5ei
KRIaO21/AcE627Csjp4BAIawA1wpY1EOlkNd+CDKFhgZmDocMSH8Y9ffHi77b+Mt
=zb/t
-----END PGP SIGNATURE-----

--e8cxxkH2sKJV4Xtl5JwleMpncKxdhcJhT--
