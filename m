Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaDXBVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:21:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52068 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaDXBVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:21:11 -0400
Date: Wed, 23 Apr 2014 20:21:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
CC: <balbi@ti.com>, Nishanth Menon <nm@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, <marcel@holtmann.org>,
        <gustavo@padovan.org>, <johan.hedberg@gmail.com>, <jslaby@suse.cz>,
        <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140424012100.GB13374@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
 <1398265117-11793-10-git-send-email-balbi@ti.com>
 <5357DDA8.4040206@ti.com>
 <20140424084305.20c7f301@notabene.brown>
 <20140423230121.GC10924@saruman.home>
 <20140424101329.02e6a62f@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20140424101329.02e6a62f@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 24, 2014 at 10:13:29AM +1000, NeilBrown wrote:
> On Wed, 23 Apr 2014 18:01:21 -0500 Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >=20
> > On Thu, Apr 24, 2014 at 08:43:05AM +1000, NeilBrown wrote:
> > > On Wed, 23 Apr 2014 10:35:04 -0500 Nishanth Menon <nm@ti.com> wrote:
> > >=20
> > > > On 04/23/2014 09:58 AM, Felipe Balbi wrote:
> > > > > nobody passes a DTR_gpio to this driver, so
> > > > > this code is not necessary.
> > > > >=20
> > > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > > ---
> > > >=20
> > > > Niel,
> > > > this seems to revert the functionality introduced in
> > > > commit 9574f36fb801035f6ab0fbb1b53ce2c12c17d100
> > > > (OMAP/serial: Add support for driving a GPIO as DTR.)
> > > >=20
> > > > would you like to Ack this change?
> > >=20
> > > I have a couple of out-of-tree drivers that use this support.
> > >=20
> > > I hope to get back to working on that code one day and even get those=
 drivers
> > > upstream.  So I would really prefer this code to remain if it isn't c=
ausing
> > > any actual problems.
> >=20
> > it causes problem with DT (not really). That suport is only available on
> > legacy platform_data-based boot, it's not available on DT. I hear Tony
> > is pretty close to turning OMAP3 DT-only.
> >=20
> > > Of course, I can always re-submit it when I need it again, but that i=
t just
> > > extra work all around.
> >=20
> > I wonder how you will pass those attributes through DT considering they
> > are *really* SW configuration. Why can't you use the real DTR pin, btw ?
> >=20
>=20
> This myth that DT is only about hardware is probably one of the
> reasons that I haven't got these out-of-tree drivers upstream yet.

take that up with DT maintainers

> There is no "real" DTR pin.

heh, my bad... confused with RTS which is supported in this HW.

> When I open /dev/ttyWHATEVER, I need the driver for the device that is
> permanently connected to that serial port to be told that the serial-devi=
ce
> has been opened so that it can "power on" or "wake up" the device.
>=20
> I don't much care how that happens, or how I tell DT that it has to happe=
n.
> I just need it to happen.
>=20
> In discrete hardware devices, the DTR line is what you would use.  The RS=
232
> port would raise (or lower or whatever) DTR when /dev/ttyWHATEVER was ope=
n,
> and  the device that was plugged in would detect the level change and do
> stuff.
>=20
> But I don't have discrete hardware.  I have a bunch of stuff soldered ont=
o a
> board with ad-hoc connections chosen to make the life of the hardware bui=
lder
> easy rather than chosen to make the life of the software developer easy
> (which I think is the correct choice).
>=20
> So I need to tell DT "This device is plugged into this UART, and there is=
 no
> DTR line, but when the UARTs DTR line would be asserted (if it had one), =
then
> I need that regulator of there turned on". or maybe "I need to toggle this
> GPIO  with exactly this pattern, while watching that GPIO to see if it is
> working".
>=20
> So I thought:
>=20
>  1/ give the UART a "virtual" DTR so it could drive any GPIO
>  2/ create a "gpio-to-regulator" driver which presented as a (virtual) gp=
io
>     and responded to state changes on that GPIO by turning on or off the
>     regulator
>  3/ create a dedicated driver which knows how to toggle the magic GPIO wh=
ile
>     watching the other GPIO to convince the silly device to wakeup, or go=
 to
>     sleep, as required, and have this appear as a (virtual) GPIO.
>=20
> Then I can just tell DT that these (virtual) GPIOs are connected together,
> and it will all just work.  And it does.
>=20
> But given the whole "no no, DT is for describing hardware, and you are
> describing software" attitude,  it seems that I lost motivation for a whi=
le
> (that wasn't the only reason, but it didn't help).
>=20
> I have a patch which converts the OMAP serial driver to use DT to configu=
re
> these virtual DTR lines.  I'm very happy to submit that if there is some
> chance it might be accepted and will keep the current DTR code in place.

I have no problem either way, just that unused code doesn't have to be
sitting in the tree and I'm not entirely sure this GPIO should be
handled by omap-serial.c, perhaps something more generic inside
serial-core so other UART drivers can benefit from it.

> On the other hand, if you can point out to me what I'm missing, and how I=
 can
> solve my problem with any virtual GPIOs, I'm all ears.
>=20
> To make my problem simple and explicit:  I have a device attached to a UA=
RT
> which has a separate regulator.  The regulator should be powered on if and

So you're using DTR to power the GPIO and hoping that the regulator
stabilizes quickly enough so that by the time your open() finishes you
don't have to add nonsensical msleep() calls before writing to the
device. Sounds a bit fragile to me.

> only if the /dev/ttyXX interface to the UART is open.  The device is a
> bluetooth transceiver.

considering this is a BTUART device, why didn't you do this at the ldisc
level ? hci_uart_open() sounds like a good choice from a quick thinking.

--=20
balbi

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWGb8AAoJEIaOsuA1yqRENNUQAIGPo+rZyQHDJvv85rm7WE/K
P6+dbz5UN5dEIWvNNpY4mY8whp2EGz8yIdse4mVxes3BjThZlqY2e+NhxI82mG2j
DFzVf/ZvleJ4wQL8JZ6Q9kCJ6tmiBVgvN/FuXy2PN5q89B7fVVG7YKQz9nPIGan1
tlxh0MbFHsn0PGVbU3sryEz0M1jnJ4OTkrdgTQvC+CqqjElSjfj0IGESi85KtKn3
19j3p/07DNaJJR/59KDBrdKxJyzqvp3e9ypbLX7p61eOx0EcWLRD7f2U5Qp8CYT4
Fo+/pgqC6AD10E2LoFbFyispjOjkHX1d9TeOe6B5xD3bx+y0dOTb8m6ysHEMTv6M
eYmbUzlgge2SAqmrOeyGsviHG5gtrXYBJ7vS084cZtfh35Azhgqqp5gz8htrgFLX
eV48kWV2lh5lVyqEfY41YSy6W474Sf3cIMRF+mH8EQCrG9ZMH5UM22s+TEUZrElA
p55NBm2uCJJy38aPdkPBbYKrwS/IQ7ule+BVO7TwBQQ8l6unv3IkjIqzO+E1ylqU
5qzRCKnbgbq/d6S6QwHQaRFCflmVpm2j4ARjuAOBAEk5ZaS40DPknS8JwzcEbdmU
rsDWaTiJnpl04M6URT/Az59wSxujt1gVSp4OR2Hr52sGKpSclcgngj3XkIHHxZvI
vkiXxtGLDqfNlM3Iqh8J
=LPHB
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
