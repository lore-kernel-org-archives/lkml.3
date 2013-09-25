Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3IYOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:25:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49856 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab3IYOZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:25:18 -0400
Message-ID: <5242F1FB.6060308@ti.com>
Date: Wed, 25 Sep 2013 10:23:55 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Hongbo Zhang <hongbo.zhang@freescale.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>, "joe@perches.com" <joe@perches.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv6 02/16] drivers: thermal: introduce device tree parser
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com> <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com> <20130923104003.GA16069@e106331-lin.cambridge.arm.com> <5241492C.9020201@freescale.com> <5241B4BF.900@ti.com> <5242771E.4080202@freescale.com>
In-Reply-To: <5242771E.4080202@freescale.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="JDPdr7VbUO8uV32IO2FGPRJ5hRjBwVupX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JDPdr7VbUO8uV32IO2FGPRJ5hRjBwVupX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-09-2013 01:39, Hongbo Zhang wrote:
> On 09/24/2013 11:50 PM, Eduardo Valentin wrote:
>> Zhang,
>>
>> I appreciate your interest. I am replying a couple of your comments.
>> Please also check my answers to Mark's queries on other email thread.
> When I replied to Mark yesterday, I missed your mail replying him alrea=
dy.
> I should check that mail and reply it for further concerns.
>> On 24-09-2013 04:11, Hongbo Zhang wrote:
>>> On 09/23/2013 06:40 PM, Mark Rutland wrote:
>>>> Hi Eduardo,
>>>>
>>>> Apologies for having taken so long to get back you on this.
>>>>
>>>> I have several comments on the binding and the way it's parsed.
>>>>
>>>> On Wed, Sep 18, 2013 at 10:35:36PM +0100, Eduardo Valentin wrote:
>>>>> This patch introduces a device tree bindings for
>>>>> describing the hardware thermal behavior and limits.
>>>>> Also a parser to read and interpret the data and feed
>>>>> it in the thermal framework is presented.
>>>>>
>>>>> This patch introduces a thermal data parser for device
>>>>> tree. The parsed data is used to build thermal zones
>>>>> and thermal binding parameters. The output data
>>>>> can then be used to deploy thermal policies.
>>>>>
>>>>> This patch adds also documentation regarding this
>>>>> API and how to define tree nodes to use
>>>>> this infrastructure.
>>>>>
>>>>> Note that, in order to be able to have control
>>>>> on the sensor registration on the DT thermal zone,
>>>>> it was required to allow changing the thermal zone
>>>>> .get_temp callback. For this reason, this patch
>>>>> also removes the 'const' modifier from the .ops
>>>>> field of thermal zone devices.
>>>>>
>>>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>>>> Cc: linux-pm@vger.kernel.org
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>>> ---
>>>>>    .../devicetree/bindings/thermal/thermal.txt        | 498
>>>>> +++++++++++++
>>>>>    drivers/thermal/Kconfig                            |  13 +
>>>>>    drivers/thermal/Makefile                           |   1 +
>>>>>    drivers/thermal/of-thermal.c                       | 775
>>>>> +++++++++++++++++++++
>>>>>    drivers/thermal/thermal_core.c                     |   9 +-
>>>>>    drivers/thermal/thermal_core.h                     |   9 +
>>>>>    include/dt-bindings/thermal/thermal.h              |  27 +
>>>>>    include/linux/thermal.h                            |  28 +-
>>>>>    8 files changed, 1357 insertions(+), 3 deletions(-)
>>>>>    create mode 100644
>>>>> Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>    create mode 100644 drivers/thermal/of-thermal.c
>>>>>    create mode 100644 include/dt-bindings/thermal/thermal.h
>>>>>
>>>>> ---
>>>>>
>>>>> Hello all,
>>>>>
>>>>> Thanks Joe Perches for the effort of reviewing this code, I really
>>>>> appreciate it.
>>>>>
>>>>> Here is a version with a refactored init function without leaks in
>>>>> the failure
>>>>> patch. I also added a couple of comments to better understand the
>>>>> intention of
>>>>> that function. Besides, when there are no memory available, the
>>>>> function
>>>>> rolls back what ever thermal zones have been added.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Eduardo
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>> b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>> new file mode 100644
>>>>> index 0000000..6664533
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>> @@ -0,0 +1,498 @@
>>>>> +* Thermal Framework Device Tree descriptor
>>>>> +
>>>>> +Generic binding to provide a way of defining hardware thermal
>>>>> +structure using device tree. A thermal structure includes thermal
>>>>> +zones and their components, such as trip points, polling intervals=
,
>>>>> +sensors and cooling devices binding descriptors.
>>>>> +
>>>>> +The target of device tree thermal descriptors is to describe only
>>>>> +the hardware thermal aspects, not how the system must control or
>>>>> which
>>>>> +algorithm or policy must be taken in place.
>>>>> +
>>>>> +There are five types of nodes involved to describe thermal binding=
s:
>>>>> +- sensors: used to describe the device source of temperature sensi=
ng;
>>>>> +- cooling devices: used to describe devices source of power
>>>>> dissipation control;
>>>>> +- trip points: used to describe points in temperature domain
>>>>> defined to
>>>>> +make the system aware of hardware limits;
>>>>> +- cooling attachments: used to describe links between trip points =
and
>>>>> +cooling devices;
>>>> I think "attachments" sounds a bit odd, though I don't have a better=

>>>> naming suggestion.
>>> "map" or "mapping" is better?
>> Well,  yeah, that could work.
> :)
>>>>> +- thermal zones: used to describe thermal data within the hardware=
;
>>>>> +
>>>>> +It follows a description of each type of these device tree nodes.
>>>>> +
>>>>> +* Sensor devices
>>>>> +
>>>>> +Sensor devices are nodes providing temperature sensing capabilitie=
s
>>>>> on thermal
>>>>> +zones. Typical devices are I2C ADC converters and bandgaps. Theses=

>>>>> are nodes
>>>>> +providing temperature data to thermal zones. Temperature sensor
>>>>> devices may
>>>>> +control one or more internal sensors.
>>>>> +
>>>>> +Required property:
>>>>> +- #sensor-cells:       Used to provide sensor device specific
>>>>> information
>>>>> +                       while referring to it. Must be at least 1, =
in
>>>>> order
>>>>> +                       to identify uniquely the sensor instances
>>>>> within
>>>>> +                       the IC. See thermal zone binding for more
>>>>> details
>>>>> +                       on how consumers refer to sensor devices.
>>>> I don't see why this needs to be at least one cell -- if an IC only =
has
>>>> one temperature sensor it should be fine for this to be zero and
>>>> have no
>>>> ambiguity.
>>>>
>>>> It may make sense to call these thermal sensor devices, there are
>>>> plenty
>>>> of other sensors we might want to describe in the dt for other
>>>> purposes,
>>>> and we can impose some consistency if we remove the ambiguity.
>>>>
>>>>> +
>>>>> +* Cooling device nodes
>>>>> +
>>>>> +Cooling devices are nodes providing control on power dissipation.
>>>>> There
>>>>> +are essentially two ways to provide control on power dissipation.
>>>>> First
>>>>> +is by means of regulating device performance, which is known as
>>>>> passive
>>>>> +cooling. Second is by means of activating devices in order to remo=
ve
>>>>> +the dissipated heat, which is known as active cooling, e.g.
>>>>> regulating
>>>>> +fan speeds. In both cases, cooling devices shall have a way to
>>>>> determine
>>>>> +the level of cooling.
>>>>> +
>>>>> +Required property:
>>>>> +- cooling-min-level:   A unsigned integer indicating the smallest
>>>>> +                       cooling level accepted. Typically 0.
>>>>> +- cooling-max-level:   An unsigned integer indicating the largest
>>>>> +                       cooling level accepted.
>>>> I'm not sure what a "cooling level" means. It seems a bit abstract. =
Is
>>>> this binding specific?
>>> It means cooling ability of a cooling device, such as speed of a fan.=

>>> But it is better to use cooling-min/max-state I think, because the
>>> thermal management code is using "cooling state", concepts in dt and =
c
>>> should be identical.
>> I think the idea is just to be clear. Just because the thermal
>> management implementation uses a terminology, it does not necessarily
>> mean it is best fit for describing in device tree bindings. But I dont=

>> really have strong opinion on level or state at this point.
>>
>>>> How does this relate to cooling-cells? These seem to be a fixed size=
=2E
>>> I also think cooling-cells is redundant.
>> Cooling cells is not redundant, please check my explanation on the oth=
er
>> thread. It is required to determine which level/states are used while
>> binding.
>>
> OK
>=20
>>>>> +- #cooling-cells:      Used to provide cooling device specific
>>>>> information
>>>>> +                       while referring to it. Must be at least 2, =
in
>>>>> order
>>>>> +                       to specify minimum and maximum cooling leve=
l
>>>>> used
>>>>> +                       in the reference. See Cooling device
>>>>> attachments section
>>>>> +                       below for more details on how consumers
>>>>> refer to
>>>>> +                       cooling devices.
>>>> Are these cooling cells always expected to cover min and max, and ar=
e
>>>> min and max always expected to take the same number of cells? The ab=
ove
>>>> cooling-*-level properties imply they each take up one cell.
>>>>
>>>> Does #cooling-cells =3D <3> make sense?. If this covers additional
>>>> information (e.g. which fan on a multi-fan controller), how does the=
 OS
>>>> determine which cells are min and max, and how do these relate to
>>>> cooling-level-min and cooling-level-max?
>>>>
>>>>> +
>>>>> +* Trip points
>>>>> +
>>>>> +The trip node is a node to describe a point in the temperature dom=
ain
>>>>> +in which the system takes an action. This node describes just the
>>>>> point,
>>>>> +not the action.
>>>> I'm still not sure on this, as it sounds like embedding policy into =
the
>>>> DT, rather than a description of the hardware. I realise we need to
>>>> prevent devices burning out, so describing the max acceptable
>>>> temperature and possibly a preferred range makes sense, but do we ne=
ed
>>>> this level of flexibility? Maybe we do.
>>>>
>>> Putting platform data into dt is acceptable, right?
>>> In a narrow sense, trip points are platform data, but in a broad sens=
e,
>>> both trip point itself and its corresponding cooling device are all
>>> platform data.
>>>
>> I think Mark needs to elaborate a bit more to clarify why he sees this=

>> as embedding policy into DT. And I believe it is fine to pass platform=

>> data, as long as it represents hardware and it is  not representing
>> policy.
>>
>>>>> +
>>>>> +Required properties:
>>>>> +- temperature:         the trip temperature level, in milliCelsius=
=2E
>>>> Preferably, s/milliCelsius/millicelsius/ over the document.
>>>>
>>>> Given that we have signed values elsewhere, is this signed or unsign=
ed?
>>>>
>>>>> +- hysteresis:          a (low) hysteresis value on 'temperature'.
>>>>> This is a
>>>>> +                       relative value, in milliCelsius.
>>>>> +- type:                        the trip type. Here is the type
>>>>> mapping:
>>>>> +       THERMAL_TRIP_ACTIVE     0:      A trip point to enable acti=
ve
>>>>> cooling
>>>>> +       THERMAL_TRIP_PASSIVE    1:      A trip point to enable
>>>>> passive cooling
>>>>> +       THERMAL_TRIP_HOT        2:      A trip point to notify
>>>>> emergency
>>>>> +       THERMAL_TRIP_CRITICAL   3:      Hardware not reliable.
>>>>> +
>>>>> +Refer to include/dt-bindings/thermal/thermal.h for definition of
>>>>> these consts.
>>>> Why not use a string for this? We do so for other type parameters in=

>>>> other bindings (see dr_mode in
>>>> Documentation/devicetree/bindings/usb/generic.txt, phy-mode for
>>>> ethernet
>>>> PHYs, etc).
>>>>
>>>>> +
>>>>> +* Cooling device attachments
>>>>> +
>>>>> +The cooling device attachments node is a node to describe how
>>>>> cooling devices
>>>>> +get assigned to trip points of the zone. The cooling devices are
>>>>> expected
>>>>> +to be loaded in the target system.
>>>>> +
>>>>> +Required properties:
>>>>> +- cooling-device:      A phandle of a cooling device with its
>>>>> parameters,
>>>>> +                       referring to which cooling device is used i=
n
>>>>> this
>>>>> +                       binding. The required parameters are: the
>>>>> minimum
>>>>> +                       cooling level and the maximum cooling level=

>>>>> used
>>>>> +                       in this attach.
>>>> Might this be a list in general? The code doesn't have to support th=
at
>>>> yet.
>>>>
>>>> It would be nice to have a name for the cells after a phandle which
>>>> describe the cooling device's configuration. You've called them
>>>> parameters here, but it probably makes sense to call them a
>>>> cooling-specifier (following clock-specifier and interrupt-specifier=
).
>>>>
>>>>> +- trip:                        A phandle of a trip point node with=
in
>>>>> the same thermal
>>>>> +                       zone.
>>>>> +
>>>>> +Optional property:
>>>>> +- contribution:                The cooling contribution to the
>>>>> thermal zone of the
>>>>> +                       referred cooling device at the referred tri=
p
>>>>> point.
>>>>> +                       The contribution is a value from 0 to 100.
>>>>> The sum
>>>>> +                       of all cooling contributions within a therm=
al
>>>>> zone
>>>>> +                       must never exceed 100.
>>>> This is a bit arbitrary. Couldn't we sum all contributions to find t=
he
>>>> total automatically, so this could be a simpler ratio?
>>>>
>>>>> +
>>>>> +Note: Using the THERMAL_NO_LIMIT (-1L) constant in the
>>>>> cooling-device phandle
>>>>> +limit parameters means:
>>>>> +(i)   - minimum level allowed for minimum cooling level used in th=
e
>>>>> reference.
>>>>> +(ii)  - maximum level allowed for maximum cooling level used in th=
e
>>>>> reference.
>>>>> +Refer to include/dt-bindings/thermal/thermal.h for definition of
>>>>> this constant.
>>>>> +
>>>>> +* Thermal zones
>>>>> +
>>>>> +The thermal-zone node is the node containing all the required info=

>>>>> +for describing a thermal zone, including its cdev bindings. The
>>>>> thermal_zone
>>>>> +node must contain, apart from its own properties, one node contain=
ing
>>>>> +trip nodes and one node containing all the zone cooling attachment=
s.
>>>> s/cdev/cooling device/ ?
>>>>
>>>>> +
>>>>> +Required properties:
>>>>> +- passive-delay:       The maximum number of milliseconds to wait
>>>>> between polls
>>>>> +                       when performing passive cooling.
>>>>> +- polling-delay:       The maximum number of milliseconds to wait
>>>>> between polls
>>>>> +                       when checking this thermal zone.
>>>> How about polling-delay-passive, polling-delay-active? I'm still not=

>>>>
>>>>> +- sensors:             A list of sensor phandles and their
>>>>> parameters. The
>>>>> +                       required parameter is the sensor id, in
>>>>> order to
>>>>> +                       identify internal sensors when the sensor I=
C
>>>>> features
>>>>> +                       several sensing units.
>>>> As mentioned above, I'm not sure you even need that one cell.
>>>>
>>>> - sensors:                A list of sensor phandle +
>>>> thermal-sensor-specifier
>>>>                             cells describing the sensors monitoring =
the
>>>> thermal
>>>>                zone.
>>>>
>>>>> +- trips:               A sub-node containing several trip point
>>>>> nodes required
>>>>> +                       to describe the thermal zone.
>>>>> +- cooling-attachments  A sub-node containing several cooling devic=
e
>>>>> attaches
>>>>> +                       nodes, used to describe the relation betwee=
n
>>>>> trips
>>>>> +                       and cooling devices.
>>>>> +
>>>>> +Optional property:
>>>>> +- coefficients:                An array of integers (one signed
>>>>> cell) containing
>>>>> +                       coefficients to compose a linear relation
>>>>> between
>>>>> +                       the sensors described in the sensors proper=
ty.
>>>>> +                       Coefficients defaults to 1, in case this
>>>>> property
>>>>> +                       is not specified. A simple linear polynomia=
l
>>>>> is used:
>>>>> +                       Z =3D c0 * x0 + c1 + x1 + ... + c(n-1) * x(=
n-1)
>>>>> + cn.
>>>>> +
>>>>> +                       The coefficients are ordered and they match=

>>>>> with sensors
>>>>> +                       by means of sensor ID. Additional
>>>>> coefficients are
>>>>> +                       interpreted as constant offsets.
>>>> What is the end result of this? Presumably this is meant to result
>>>> in an
>>>> estimate of the average temperature of the thermal zone, rather than=
 an
>>>> arbitrary value? This should be mentioned.
>>>>
>>>> This doesn't seem to be used the in the code below...
>>>>
>>>>> +
>>>>> +Note: The delay properties are bound to the maximum dT/dt
>>>>> (temperature
>>>>> +derivative over time) in two situations for a thermal zone:
>>>>> +(i)  - when active cooling is activated (passive-delay); and
>>>>> +(ii) - when the zone just needs to be monitored (polling-delay).
>>>>> +The maximum dT/dt is highly bound to hardware power consumption an=
d
>>>>> dissipation
>>>>> +capability.
>>>> I'm not sure what you mean by this, could you elaborate?
>>>>
>>>> I guess you mean that the delays should be chosen to account for sai=
d
>>>> max dT/dt, such that a device can't unexpectedly cross several trip
>>>> boundaries between polls?
>>>>
>>>>> +
>>>>> +* Examples
>>>>> +
>>>>> +Below are several examples on how to use thermal data descriptors
>>>>> +using device tree bindings:
>>>>> +
>>>>> +(a) - CPU thermal zone
>>>>> +
>>>>> +The CPU thermal zone example below describes how to setup one
>>>>> thermal zone
>>>>> +using one single sensor as temperature source and many cooling
>>>>> devices and
>>>>> +power dissipation control sources.
>>>>> +
>>>>> +#include <dt-bindings/thermal/thermal.h>
>>>>> +
>>>>> +cpus {
>>>>> +       cpu0: cpu@0 {
>>>>> +               ...
>>>>> +               cooling-min-level =3D <0>;
>>>>> +               cooling-max-level =3D <3>;
>>>>> +               #cooling-cells =3D <2>; /* min followed by max */
>>>>> +       };
>>>> What do those min and max mean in this context? What do the values i=
n
>>>> the range [0,3] correspond to?
>>>>
>>>> I'm not sure it makes sense to describe passive cooling in this way =
--
>>>> the precise way an OS does less work on a device is fundamentally ti=
ed
>>>> to the design of the OS (it might be able to rate-limit requests, it=

>>>> might be able to clock the device down, it might only be able to tur=
n
>>>> the device off).
>>>>
>>>> I'm not sure there is anything we can describe for passive cooling
>>>> (beyond the thermal limits the OS should attempt to stick to).
>>>>
>>>>> +       ...
>>>>> +};
>>>>> +
>>>>> +&i2c1 {
>>>>> +       ...
>>>>> +       fan0: fan@0x48 {
>>>>> +               ...
>>>>> +               cooling-min-level =3D <0>;
>>>>> +               cooling-max-level =3D <9>;
>>>>> +               #cooling-cells =3D <2>; /* min followed by max */
>>>>> +       };
>>>> What do min and max mean here for the fan?
>>>>
>>> It means the speed level of a fan. Even if a fan can run at a continu=
ous
>>> speed range, but when it is controlled under thermal management
>>> framework, it can only run at discrete speeds.
>>
>> Please, an important point here, this is not about thermal framework
>> requirement. But how we describe hardware. As you mentioned, even if
>> there are fan devices out there that uses continuous speed range, ther=
e
>> other devices, even fan devices or cpu frequency steps for instance,
>> that are discrete. Again, *this is not a thermal framework requirement=
*.
>>
>>>>> +};
>>>>> +
>>>>> +bandgap0: bandgap@0x0000ED00 {
>>>>> +       ...
>>>>> +       #sensor-cells =3D <1>;
>>>>> +};
>>>>> +
>>>>> +cpu-thermal: cpu-thermal {
>>>> How do the thermal zones get probed?
>>>>
>>>>> +       passive-delay =3D <250>; /* milliseconds */
>>>>> +       polling-delay =3D <1000>; /* milliseconds */
>>>>> +
>>>>> +               /* sensor       ID */
>>>>> +        sensors =3D <&bandgap0     0>;
>>>>> +
>>>>> +        trips {
>>>>> +                cpu-alert0: cpu-alert {
>>>>> +                        temperature =3D <90000>; /* milliCelsius *=
/
>>>>> +                        hysteresis =3D <2000>; /* milliCelsius */
>>>>> +                        type =3D <THERMAL_TRIP_ACTIVE>;
>>>>> +                };
>>>>> +                cpu-alert1: cpu-alert {
>>>>> +                        temperature =3D <100000>; /* milliCelsius =
*/
>>>>> +                        hysteresis =3D <2000>; /* milliCelsius */
>>>>> +                        type =3D <THERMAL_TRIP_PASSIVE>;
>>>>> +                };
>>>>> +                cpu-crit: cpu-crit {
>>>>> +                        temperature =3D <125000>; /* milliCelsius =
*/
>>>>> +                        hysteresis =3D <2000>; /* milliCelsius */
>>>>> +                        type =3D <THERMAL_TRIP_CRITICAL>;
>>>>> +                };
>>>>> +        };
>>>>> +
>>>>> +       cooling-attachments {
>>>>> +               attach0 {
>>>>> +                       trip =3D <&cpu-alert0>;
>>>>> +                       cooling-device =3D <&fan0 THERMAL_NO_LIMITS=
 4>;
>>>>> +               };
>>>>> +               attach1 {
>>>>> +                       trip =3D <&cpu-alert1>;
>>>>> +                       cooling-device =3D <&fan0 5 THERMAL_NO_LIMI=
TS>;
>>>>> +               };
>>>>> +               attach2 {
>>>>> +                       trip =3D <&cpu-alert1>;
>>>>> +                       cooling-device =3D
>>>>> +                               <&cpu0 THERMAL_NO_LIMITS
>>>>> THERMAL_NO_LIMITS>;
>>>>> +               };
>>>>> +       };
>>>> Was there a good reason for splitting trips and attachment?
>>> This is for adding/removing cooling device dynamically.
>> Well not really. I don't think this would prevent us of representing i=
t
>> inside the trip point. It is, as I replied to Mark, because I wanted t=
o
>> keep the flexibility to allow describing better properties related to
>> the cooling device while associated to a trip point alone, e.g.
>> 'contribution'.
>=20
> Understand your purpose and explanation.
> But this can also really help to add/remove cooling device freely, ther=
e
> were already drivers with separated files of thermal zone and cooling
> device.

Right. The idea is of course to probe cooling devices independently from
thermal zone devices, and also from thermal sensor devices. With this
series we will achieve that state.

Currently, thermal drivers have several responsibilities: control the
sensor, report the thermal zone requirements and probe cooling devices.

On top of this series, using device tree, cooling devices are supposed
to be probed based on their nodes. I have started to do this with the
cpufreq cooling device. And it is usable already. Thermal zone devices
will be probed by the of-thermal.c code. And thermal sensors will be
probed by their own driver, but they need to be registered to a thermal
zone, so that the zone gets enabled.

However, the specific point we are talking about, is more about how the
zone gets connected to the cooling device. But the probing of this
cooling device is not triggered by the node above, which is just
describing the connection. As I mentioned, the cooling device needs to
be probed based on the node that this connection points to, by means of
a phandle.

Just like regulators, or dma, or interrupts are mapped. Here the thermal
zone is a consumer, in a way, of the cooling device and of the sensor
device.

I hope this is clear in the documentation I am writing. Please let me
know if not.

>=20
>>>>> +};
>>>>> +
>>>>> +In the example above, the ADC sensor at address 0x0000ED00 is used=

>>>>> to monitor
>>>>> +the zone 'cpu-thermal' using its the sensor 0. The fan0, a fan
>>>>> device controlled
>>>>> +via I2C bus 1, at adress 0x48, is used to remove the heat out of t=
he
>>>>> thermal
>>>>> +zone 'cpu-thermal' using its cooling levels from its minimum to 4,=

>>>>> when it
>>>>> +reaches trip point 'cpu-alert0' at 90C, as an example of active
>>>>> cooling. The
>>>>> +same cooling device is used at 'cpu-alert1', but from 5 to its
>>>>> maximum level.
>>>>> +The cpu@0 device is also linked to the same thermal zone,
>>>>> 'cpu-thermal', as a
>>>>> +passive cooling device, using all its cooling levels at trip point=

>>>>> 'cpu-alert1',
>>>>> +which is a trip point at 100C.
>>>>> +
>>>
>>>
>>>
>>>
>>
>=20
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--JDPdr7VbUO8uV32IO2FGPRJ5hRjBwVupX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJC8gAACgkQCXcVR3XQvP3o0AEApdzsbrTyO04fU0Z/865Ol+mx
N4f3PiuTEWKtFk6HvU0BAKjGBrdZDTkcEjrkv8In8H+IBRR7c8y21ZCgC1AKaMy0
=Ddzb
-----END PGP SIGNATURE-----

--JDPdr7VbUO8uV32IO2FGPRJ5hRjBwVupX--
