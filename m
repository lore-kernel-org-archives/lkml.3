Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaAFSxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:53:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33273 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbaAFSxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:53:40 -0500
Message-ID: <52CAFB6D.8020603@ti.com>
Date: Mon, 6 Jan 2014 14:52:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Longnecker <mlongnecker@nvidia.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com> <52C5A344.2060908@nvidia.com>
In-Reply-To: <52C5A344.2060908@nvidia.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="PpAgImAWpbaifJV0ArdL7kVpnh5gADKWN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PpAgImAWpbaifJV0ArdL7kVpnh5gADKWN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02-01-2014 13:35, Matthew Longnecker wrote:
> Eduardo,

Hello Matthew,

>=20
> For the most part, this binding is really well thought out. It makes a
> lot of sense to me (as someone who has been working with thermal
> management in Linux/Android-based mobile devices for a few years).

No issues, I also have been there.

>=20
> However, I have one substantive criticism.
>=20
> On 11/12/2013 11:46 AM, Eduardo Valentin wrote:
>> +* Thermal zone nodes
>> +
>> +The thermal zone node is the node containing all the required info
>> +for describing a thermal zone, including its cooling device bindings.=

>> The
>> +thermal zone node must contain, apart from its own properties, one
>> sub-node
>> +containing trip nodes and one sub-node containing all the zone
>> cooling maps.
>> +
>> +Required properties:
> ...
>> +- thermal-sensors:    A list of thermal sensor phandles and sensor
>> specifier
>> +  Type: list of     used while monitoring the thermal zone.
>> +  phandles + sensor
>> +  specifier
> ...
>> +Optional property:
>> +- coefficients:        An array of integers (one signed cell) contain=
ing
>> +  Type: array        coefficients to compose a linear relation betwee=
n
>> +  Elem size: one cell    the sensors listed in the thermal-sensors
>> property.
>> +  Elem type: signed    Coefficients defaults to 1, in case this prope=
rty
>> +            is not specified. A simple linear polynomial is used:
>> +            Z =3D c0 * x0 + c1 + x1 + ... + c(n-1) * x(n-1) + cn.
>> +
>> +            The coefficients are ordered and they match with sensors
>> +            by means of sensor ID. Additional coefficients are
>> +            interpreted as constant offset.
>=20
>=20
> "coefficients" is a problematic way of describing the relationship
> between temperatures at various sensors and temperature at some other
> location. It would make sense if heat flowed infinitely quickly.
> However, in practice thermal capacitance means that we need to take int=
o
> account the _history_ of temperature at sensors in order to predict hea=
t
> coupled into a distant point.

I agree. But coefficients are targeting in fact the steady state cases.
As described in the DT binding documentation, the case of an offset due
to sensor location distance to hotspot is a perfect usage of this propert=
y.

The thermal capacitance behavior is described, so far, most based on the
requested time requirement for each zone. Of course, this point was a
major point for discussion during this thread. Hopefully I was able to
keep the minimal time behavior requirements in the DT definition.

>=20
> For example, assuming that handset enclosure starts at ~25C, the CPU
> could burst to 100C for many minutes before the handset enclosure
> reaches ~40C. However, at steady-state, the CPU might only be able to
> sustain 65C without pushing the enclosure above 40C.


Yeah, but here you are maybe confusing two different constraints, and
possibly the behavior of two different zones. The current binding do not
limit you in the usage of hierarchical description. Thus, you can and
should describe two different zones to cover for two different
constraints you have in your description, one to cover for your silicon
junction (>100C) and another to cover for your case / device skin
hotspot (<45C). And in each zone you may have different limits and
thermal capacitance requirements. Pay attention that it does not mean
that you CPU (cooling) device cannot appear in two different zone. Thus
its contribution to one zone may be different to the other (each zone
can assume different coefficients).

>=20
> I wouldn't be complaining except that you're proposing this as a DT
> definition. In this case, the binding you've proposed is poor
> abstraction of the hardware.

OK. The main reason I made this property optional is exactly because
different use case may require different usage of these relations. And
possibly people may have different experience and different solutions to
the same problem. But in the end what we want is to describe the
hardware (and possibly the physics) behind the use cases. And I do
believe we have been dealing with very similar cases here.

I don't think the property is a poor abstraction. Firstly because it is
not limiting you in anything. Secondly because you may be having a
different interpretation of it, as I explained above.

In fact the thermal behavior is much more dynamic than the steady state
situation. However, so far, I haven't seen a real case that we need to
describe these dynamics deeper in DT. Including for the example you gave
above. Dealing with the history can be derived by the OS based on the
already defined properties.

>=20
> thanks,

No problem, thanks for your contribution. Again, if we are not covering
your use cases properly, let's go through them and narrow a proper
solution down.

> Matt Longnecker
>=20
> p.s. I apologize for chiming in without having read the entire history
> of the patch set. Engineers on my team will be trying this out for Tegr=
a
> within the next few weeks.
>=20

OK.

>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--PpAgImAWpbaifJV0ArdL7kVpnh5gADKWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLK+20ACgkQCXcVR3XQvP1+3wEAlMc687ShyvsA7Dng9fKWkz8C
MBW9RCPV8QrGR1+PPJoBAOeqcN7lhfNc3o224D3X9pCV7FI+b0WQn9exHG/JgYrb
=Xf45
-----END PGP SIGNATURE-----

--PpAgImAWpbaifJV0ArdL7kVpnh5gADKWN--
