Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3K1Jdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:33:36 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:52059 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3K1Jdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:33:31 -0500
Date: Thu, 28 Nov 2013 10:32:41 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: Alexandre Courbot <gnurou@gmail.com>, Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
Message-ID: <20131128093224.GA26634@ulmo.nvidia.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
 <52962214.9030203@nvidia.com>
 <CAAVeFuJiTg1j9ox6=rF00xSBiSmRSyvkGYWHSfmPAoo6JUQVfw@mail.gmail.com>
 <4501377.Eymj5teNBr@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <4501377.Eymj5teNBr@fb07-iapwap2>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 10:09:14AM +0100, Marc Dietrich wrote:
> Hi,
>=20
> Am Donnerstag, 28. November 2013, 11:47:34 schrieb Alexandre Courbot:
> > On Thu, Nov 28, 2013 at 1:47 AM, Rhyland Klein <rklein@nvidia.com> wrot=
e:
> > > On 11/26/2013 5:05 AM, Mika Westerberg wrote:
> > >> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > >>=20
> > >> This makes it possible to request the gpio descriptors in
> > >> rfkill_gpio driver regardless of the platform.
> > >>=20
> > >> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > >> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > >> Tested-by: Stephen Warren <swarren@nvidia.com>
> > >> ---
> > >>=20
> > >>  arch/arm/mach-tegra/board-paz00.c | 7 +++++++
> > >>  1 file changed, 7 insertions(+)
> > >>=20
> > >> diff --git a/arch/arm/mach-tegra/board-paz00.c
> > >> b/arch/arm/mach-tegra/board-paz00.c index 06f024070dab..a309795da665
> > >> 100644
> > >> --- a/arch/arm/mach-tegra/board-paz00.c
> > >> +++ b/arch/arm/mach-tegra/board-paz00.c
> > >> @@ -18,6 +18,7 @@
> > >>=20
> > >>   */
> > >> =20
> > >>  #include <linux/platform_device.h>
> > >>=20
> > >> +#include <linux/gpio/driver.h>
> > >>=20
> > >>  #include <linux/rfkill-gpio.h>
> > >>  #include "board.h"
> > >>=20
> > >> @@ -36,7 +37,13 @@ static struct platform_device wifi_rfkill_device =
=3D {
> > >>=20
> > >>       },
> > >> =20
> > >>  };
> > >>=20
> > >> +static struct gpiod_lookup wifi_gpio_lookup[] =3D {
> > >> +     GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio", NULL, 0, 0),
> > >> +     GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio", NULL, 1, 0),
> > >> +};
> > >=20
> > > I wouldn't think this table would match for the gpios as the driver
> > > currently is. From what I see, the driver calls into gpiod_get_index,
> > > which will try 1 of 3 ways of getting the gpios:
> > >=20
> > > of-enabled: of_find_gpio
> > >=20
> > >         - which I believe wouldn't work for paz00, since rfkill
> > >        =20
> > >           doesn't support dt?
> > >=20
> > > acpi: acpi_find_gpio
> > >=20
> > >         - I assume this does work, but I didn't dive into it
> > >=20
> > > gpiod lookup table: gpiod_find
> > >=20
> > >         - I think this is the path we expect to be taken, given the
> > >         addition of
> > >=20
> > > the lookup table here, but I don't think it would actually match.
> > > Looking at the code for gpiod_find, it seems like it would try to mat=
ch
> > > the con_id, but would fail. Patch 2/6 is passing the reset_name and
> > > shutdown_name for the con_ids, which isn't what is registered in this
> > > table.
> > >=20
> > > Shouldn't it look more like this?
> > >=20
> > > +static struct gpiod_lookup wifi_gpio_lookup[] =3D {
> > > +       GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio_reset", NULL, =
0,
> > > 0),
> > > +       GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio_shutdown", NUL=
L, 1,
> > > 0), +};
> >=20
> > The original GPIO lookup table specifies the device name
> > ("rfkill_gpio"), no con_id, and an index. gpiod_find() will ensure
> > that the device names match, skip the con_id (as it is null in the
> > table), and again require that the indexes are the same. So provided
> > the instanciated device's dev_name() is "rfkill_gpio" (which it seems
> > to be according to the driver - not sure if it could become
> > "rfkill_gpio.0"), then I'd say the GPIOs will match. The con_id passed
> > to gpiod_get() will only be used as a label for debugfs. I am not sure
> > where the "rfkill_gpio_reset" you mention comes from?
> >=20
> > One could wonder why the names of the GPIO are not hardcoded in the
> > driver instead of being defined as platform data, but that point could
> > be improved in a future patch.
> >=20
> > It is true however that the platform GPIO lookup mechanism is
> > confusing at best, on top of being inefficient (one big linked list).
> > I have a patch in the pipe that should improve both points by making
> > GPIO lookup tables defined per-device - don't hesitate to merge this
> > series first if it works though.
>=20
> I'll try to apply the patches and check on the actual hw. rfkill userspac=
e=20
> command should be able to enable/disable the gpio. No idea how it finds t=
he=20
> required gpio names.
>=20
> The real problem with the rfkill driver is that it does not support DT. A=
=20
> naive attempt to convert it was made some year ago, but got rejected beca=
use=20
> rfkill wasn't seen as isolated device which can be represented in the dev=
ice-
> tree. Also it can not be added under some existing device node (e.g. the =
wifi=20
> driver) because those devices sit normally on an "enumeratable" bus (e.g.=
 usb,=20
> pci), which is not listed in the device tree at all. This is why it still=
=20
> requires a board file and platform_data. I wish we could find a solution =
for=20
> this.

There is a solution at least for PCI. You can list PCI devices within
the device tree, which is really handy (required even) if for instance
one of the PCI devices is an SPI or I2C controller, each providing a bus
that cannot be probed. What you usually do is describe the PCI hierarchy
at least up to the controller and then list slaves as child nodes.

I'm not aware of anything similar for USB, but it should certainly be
possible to come up with a standard binding for the USB bus. It has a
topology that's similar enough to that of PCI so that the same general
rules could be applied.

If that's really the only thing that keeps rfkill from gaining DT
support then it's something worth tackling in my opinion.

Thierry

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlw22AAoJEN0jrNd/PrOh9qMP/0ynQXj2SPcgrfOuQ6OBiq0U
aHeMbH7AAaifzyS91Fig//gngbPGsl1Ry7OkvvNe3hGt6fv66OXHGw5V4LpBJQ4D
ioQEuCGHxeG3eCoZz5Ez4zQuUmeEl7UX87rM/Wcsl7sMkXouuZ2uIlQGX4QdveIA
JclK12esA1YifhUsr4yT9k7p4NJ1ENBK3yox7eXktlQV7wjO0QYLq740BVa4w3Yf
TsjIum9nPfCKdqtreJTehkU+gEHOAtSUDoAa59yjr0o7yAqplL5wtRl1MdL7aAn2
SWQkZci7rsHmA3vhnvGLgKqf0rfcVnnV7HSyWguuasZ45m9HI/NfxY7NQAn8pjZv
eDj/fypqpxJ7vaKXKsEzXNruOXsQiQ8a/qVEn9QRCXMlB2U0no+TTYeHnHxxl5u/
b2Nw1gQ0lZmGOILONY88+2Ae54cndH10rn83vs8/KFXhXjVkqOdxyUA9laJwbyua
qPjk1EijZVvCrwFtguOtpggI3FM4PpL0tXqo1wZFNMCZGJWxixtRNPPaTGMkJan0
x+enJBzmY1gLczHi4DzN3CxVqlN18GkrsUBKzCpIrjzmMU59OWJkzOLOeg79W791
TnUeyez8eY/xPI4bj0CVFtGcxcLsztMi55umOxpfbt/lfFURModqJBo+n7hm554C
An0n7pnVDiBbIJM/2Q+p
=tKjX
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
