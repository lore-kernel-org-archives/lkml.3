Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3KAXpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 19:45:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3KAXpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 19:45:19 -0400
Date: Sat, 2 Nov 2013 10:45:05 +1100
From: NeilBrown <neilb@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
Message-ID: <20131102104505.34105cbb@notabene.brown>
In-Reply-To: <1383347425.28909.63.camel@pasglop>
References: <20131101145925.66e22f73@notabene.brown>
	<1383279744.28909.26.camel@pasglop>
	<1383280054.28909.30.camel@pasglop>
	<20131101160329.37f3707b@notabene.brown>
	<1383282516.28909.36.camel@pasglop>
	<20131101204749.GA19662@kroah.com>
	<1383347425.28909.63.camel@pasglop>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nUbqBAeyY5VVuLrRrnwTQm0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nUbqBAeyY5VVuLrRrnwTQm0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 02 Nov 2013 10:10:25 +1100 Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:

> On Fri, 2013-11-01 at 13:47 -0700, Greg Kroah-Hartman wrote:
>=20
> > > > On my device I seem to have some platform devices registered through
> > > > device-tree, and some registered through platform_device_add (e.g.
> > > > 'alarmtimer').  Guaranteeing they remain disjoint sets if the kerne=
l is
> > > > allowed to evolve independently of the devicetree might be tricky..=
..
> > > > Maybe we need "/sys/devices/platform" and "/sys/devices/dt_platform=
" ??
> > >=20
> > > No, I think device-tree created platform devices should go
> > > to /sys/devices/platform like the "classic" ones.
> > >=20
> > > The problem is really how to deal with potential name duplication. We
> > > could try to register, if we get -EEXIST (assuming sysfs returns the
> > > right stuff), try again with ".1" etc...
> >=20
> > How can there be device name collisions?  All platform devices _should_
> > be named uniquely, if not, you have bigger problems...
>=20
> The problem is how to create a unique name for a platform device created
> from a device-tree node.
>=20
> Device tree nodes aren't necessarily uniquely named. They are unique
> under a given parent but that hierarchy isn't preserved when creating
> corresponding platform devices (and it would be very tricky to do so).
>=20
> Currently, we simply append a number to the name when creating them,
> which is obtained from a global counter.
>=20
> Neil is unhappy about that because on his specific hardware, the device
> has a unique name and thus we introduce a naming difference between
> device-tree usage and old-style "hard coded" board file usage.

It occurs to me that a different approach could solve my problem.

My problem stems from the fact that the name of the device on the
platform-bus is used as the name of the device in the "backlight" class.

As Greg writes elsewhere, depending on names with /sys/devices is not
supported - we need to accept that bus-names might change.
However names in class devices tend to be a lot more stable.
Several devices allow these to be explicitly set.
 leds have 'label'
 regulators has "regulator-name"
 gpio-keys has 'label'.

I could just teach pwm_bl to allow a 'label' property which would be used in
place of the platform-bus device name when creating the class/backlight
device.

The maxim "you cannot trust names to remain stable in /sys/devices" can
justify both the movement of platform devices into /sys/devices/platform, a=
nd
the use of "label" rather than the device-name for creating the class devic=
e.

Does that sound convincing?

Thanks,
NeilBrown

>=20
> It would be nice if we could do something that only appends the "global
> number" at the end of the name if the name isn't already unique. Thus my
> proposal of trying first with the base name, and trying again if that
> returns -EEXIST in some kind of loop.
>=20
> Do you have a better idea ?
>=20
> Cheers,
> Ben.
>=20


--Sig_/nUbqBAeyY5VVuLrRrnwTQm0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnQ9Ajnsnt1WYoG5AQImjQ//VyKMMgl1op6yt7MsiAbhAGRQ8H0nBW75
xrLPEAeTAfHaVYyaqDD1RIXgM+YCGWEE9qQApu/9eXbb/exNzz+tYaGrT4h37rqq
VrLvOWIvkb8JV6WRJkyl+bBv0iPZka1CxR+bJjqxchzxWxjaqK1rYSYKLTazdBiw
QjWdAFGYK8iS/uVKqUo5brDbm5E4gMi30ul3kxRPhXIDnFoYu/Mwnqq8vRgnlAZU
DpLAnsEzNg+eeyBanIOotHspY0gNHmJO41mAZuPlmFhhmPIUvZ/SdRWIAixKev91
LPlsl9T7CdJVSPAr4nO2/pkcwhY4B3zuNJn0WCz9Z7giqCg9T/rBZ9KJeyzUAXaD
OwrasY50OKYhXlHE6jiXeTBUMDfrDt54JcvnJICGt5rUXPX12JRIdRyObmCvoXmE
Iwh29vLK1shn1mOy2snCpXow644meuSb1cQ8VlntpmIJmuZZSllWTXS4eeCbFNtt
JAuUjRDBmerXorjmJO+X0mpdmRIrM04ysXgspv0fv7ZiXwRViJVnLTqiUiK/WKM8
2J+xeBUuzOJ9i3kzVHSYrQ8w9Q6uvAm/G6GEO0uvFUlhUVZgxlFLcNDdAMJhcWaY
tZ+UWRTrJbdCNqOvPj5tbKqeH6FoV9Rai4GJnSxXdK2mqzlGJYdyL7M2x9Wpt0UH
SpcvQe9h71A=
=UYqN
-----END PGP SIGNATURE-----

--Sig_/nUbqBAeyY5VVuLrRrnwTQm0--
