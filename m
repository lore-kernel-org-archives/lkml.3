Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3GENVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:21:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51708 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab3GENVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:21:39 -0400
Date: Fri, 5 Jul 2013 16:21:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: James Hogan <james.hogan@imgtec.com>
CC: Luciano Coelho <coelho@ti.com>, Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [RFC] clk: add flags to distinguish xtal clocks
Message-ID: <20130705132107.GL19262@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372971912-10877-1-git-send-email-coelho@ti.com>
 <CAAG0J98UL5sLTmRx1o8XnbK8qWv_qNi9+zwuyPBbbYExPSbw8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L/bWm/e7/ricERqM"
Content-Disposition: inline
In-Reply-To: <CAAG0J98UL5sLTmRx1o8XnbK8qWv_qNi9+zwuyPBbbYExPSbw8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--L/bWm/e7/ricERqM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 05, 2013 at 02:12:08PM +0100, James Hogan wrote:
> On 4 July 2013 22:05, Luciano Coelho <coelho@ti.com> wrote:
> > Add a flag that indicate whether the clock is a crystal or not.  Since
> > no clocks set this flag right now, include an additional flag that
> > indicates whether the type is set or not.  If the CLK_IS_TYPE_DEFINED
> > flag is not set, the value of the CLK_IS_TYPE_XTAL flag is undefined.
> > This ensures backwards compatibility.
> >
> > Additionally, parse a new device tree binding in clk-fixed-rate to set
> > this flag.
> >
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >
> > I'm not  familiar with the common clock framework and I'm not
> > entirely sure the flags can be used in such a way, but to me it looks
> > reasonable, since some clock consumers may need to know what type of
> > clock is being provided.
> >
> > Specifically, the wl12xx firmware needs to know if the clock is XTAL
> > or not to handle the stabilization and boosts properly.
> >
> > My main idea is that I need to pass this information in the device
> > tree definition of the clocks, so that the driver can pass this
> > information on to the firmware.
> >
> > Please let me know if this looks ok or not.  If not, please let me
> > know if you have any other ideas on how to solve my problem (of
> > knowing whether the clock attached to the WiLink chip is XTAL or not).
>=20
> The TZ1090 SoC has something that sounds possibly similar, where some
> of the XTAL pads have a bypass bit, which according to the hardware
> engineer I asked should be enabled when you want to use the
> corresponding XTAL pads as a clock input pad rather than an
> oscillator. I was considering extending clk-fixed-rate (via a wrapper
> driver) to parse a custom DT property and a register address / bit
> number and set the bypass bit as appropriate itself.
>=20
> So I was wondering, is there a particular reason you don't have a DT
> property on the node for the device that needs to know what type of
> clock it is, rather than the clock node itself? That way you're not
> depending directly on the generic common clock framework to be able to
> tell you such electrical details.

three things here:

1) you end up with several devices implementing the clock type
attribute.

2) the type is a property of the clock itself

3) At least WiLink, can work with both types of clocks.

considering those, I really think this should belong to the clock node.
Otherwise Imagine how your DT would look like:

clock {
	compatible =3D "fixed-rate";
	...
};

wilink {
	clocks =3D &clock;
	wilink,btw-this-time-we-are-using-xtal;
	...
};

where you could:

clock {
	compatible =3D "fixed-rate";
	clock-type =3D "xtal";
	...
};

wilink {
	clocks =3D &clock;
	...
};

second option looks a lot cleaner to me.

--=20
balbi

--L/bWm/e7/ricERqM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1shDAAoJEIaOsuA1yqRE90gP/im9frnNcuJo+U84DNOKSGDR
09/8LLS/wcmE8EGtJJ9fAehtWkqpaYZYcvr1QJK5nBW1JHgY9Uq/xkLVeSHCXb/5
GZVo0ERYtQHX7kl8j7XiqrZe1qL3YhMFyezHM/vQrVW5TXRyRoiQY3h6SLKsCmBi
6YNWgDI6fXoTR+nAp8lmiZB5kKUXIMpFRReJxrEV+61vDwOHyV5B3K8ZIFQ1z/6G
hpwz9ToTBWzLLIcZgtiRvFzxV+4+9/hyMcFJ2e+HoX1AwiLaRcF3FLqSPY/929Ul
N6V8rd0HEEAJxuJKH/R4XGWNgX+QgAmdWe604KWWVNgQeAKIdSi6nmUy3TQvbWR8
8mXxiLtSwsenVYSFTQyY3zqMIccjXAHW8M4tS5TiXsff5Wxk5ALxP+atOniNW37K
87Y6MivqU7v6ot6ccvAdrAHfbJMxjuaQaCui36yCucE2859MboS7muIWd0tp0iSe
nwfAiEpja+wF8ezHnJNBttVnOyLtmsaYy0bxkkqxBUkd8UmrA2Nhvyc1ag8JRlUi
SFtFmg/H+Fk/B3m7p99727HM0Q+rYSBZjv/fKDR8hrGry8VTi8OptKTy7wgBsfxT
jBXChuPPD1EujJPEwi6jAQ4td9N06yw/MHqAITKfcUQ9m3I/WpQJr0YQifXH5YHy
DyH6bb49haHpq72s2g51
=bkkc
-----END PGP SIGNATURE-----

--L/bWm/e7/ricERqM--
