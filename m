Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaDRT2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:28:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35260 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754603AbaDRT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:28:33 -0400
Date: Fri, 18 Apr 2014 19:49:59 +0200
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-sunxi@googlegroups.com,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH 7/7] ARM: sun7i: cubietruck: enable
 bluetooth module
Message-ID: <20140418174959.GH4132@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-8-git-send-email-wens@csie.org>
 <20140415144215.GG3207@lukather>
 <CAGb2v643HyvFdhQ0znreB8ENXHWpcx6tFwdeU7VuU8KYWcT4ZA@mail.gmail.com>
 <20140416094428.GK3207@lukather>
 <CAGb2v67HzB22a3huRRZyufXkdTFE410MhXqAHyC-MmVo0-GCFA@mail.gmail.com>
 <534E8102.4070404@redhat.com>
 <534F862C.8010604@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cVp8NMj01v+Em8Se"
Content-Disposition: inline
In-Reply-To: <534F862C.8010604@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cVp8NMj01v+Em8Se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2014 at 09:43:40AM +0200, Arend van Spriel wrote:
> + linux-serial@vger.kernel.org
>=20
> On 16/04/14 15:09, Hans de Goede wrote:
> >Hi,
> >
> >On 04/16/2014 12:39 PM, Chen-Yu Tsai wrote:
> >>Hi,
> >>
> >>On Wed, Apr 16, 2014 at 5:44 PM, Maxime Ripard
> >><maxime.ripard@free-electrons.com> wrote:
> >>>Hi,
> >>>
> >>>Please try to keep me in CC, even though the ML doesn't make it easy..
> >>
> >>Sorry about that.
> >>
> >>>On Wed, Apr 16, 2014 at 12:06:59AM +0800, Chen-Yu Tsai wrote:
> >>>>>>@@ -139,4 +152,16 @@
> >>>>>>       reg_usb2_vbus: usb2-vbus {
> >>>>>>               status =3D "okay";
> >>>>>>       };
> >>>>>>+
> >>>>>>+     rfkill_bt {
> >>>>>>+             compatible =3D "rfkill-gpio";
> >>>>>>+             pinctrl-names =3D "default";
> >>>>>>+             pinctrl-0 =3D <&bt_pwr_pin_cubietruck>, <&clk_out_a_p=
ins_a>;
> >>>>>>+             clocks =3D <&clk_out_a>;
> >>>>>>+             clock-frequency =3D <32768>;
> >>>>>>+             gpios =3D <&pio 7 18 0>; /* PH18 */
> >>>>>>+             gpio-names =3D "reset";
> >>>>>>+             rfkill-name =3D "bt";
> >>>>>>+             rfkill-type =3D <2>;
> >>>>>>+     };
> >>>>>
> >>>>>Hmmm, I don't think that's actually right.
> >>>>>
> >>>>>If you have such a device, then I'd expect it to be represented as a
> >>>>>full device in the DT, probably with one part for the WiFi, one part
> >>>>>for the Bluetooth, and here the definition of the rfkill device that
> >>>>>controls it.
> >>>>
> >>>>The AP6210 is not one device, but 2 separate chips in one module. Each
> >>>>chip has its own controls and interface. They just so happen to share
> >>>>the same enclosure. Even 2-in-1 chips by Broadcom have separate contr=
ols
> >>>>and interfaces. The WiFi side is most likely connected via SDIO, while
> >>>>the Bluetooth side is connected to a UART, and optionally I2S for sou=
nd.
> >>>
> >>>It's even easier to represent then.
> >>>
> >>>>>But tying parts of the device to the rfkill that controls it, such as
> >>>>>the clocks, or the frequency it runs at seems just wrong.
> >>>>
> >>>>I understand where you're coming from. For devices on buses that requ=
ire
> >>>>drivers (such as USB, SDIO) these properties probably should be tied =
to
> >>>>the device node.
> >>>>
> >>>>For our use case here, which is a bluetooth chip connected on the UAR=
T,
> >>>>there is no in kernel representation or driver to tie them to. Same g=
oes
> >>>>for UART based GPS chips. They just so happen to require toggling a G=
PIO,
> >>>>and maybe enabling a specific clock, to get it running. Afterwards,
> >>>>accessing it is done solely from userspace. For our Broadcom chips, t=
he
> >>>>user has to upload its firmware first, then designate the tty as a Bl=
uetooth
> >>>>HCI using hciattach.
> >>>>
> >>>>We are using the rfkill device as a on-off switch.
> >>>
> >>>I understand your point, but the fact that it's implemented in
> >>>user-space, or that UART is not a bus (which probably should be), is
> >>>only a Linux specific story, and how it's implemented in Linux (even
> >>>if the whole rfkill node is another one, but let's stay on topic).
> >>
> >>I gave it some thought last night. You are right. My whole approach
> >>is wrong. But let's try to make it right.
> >>
> >>So considering the fact that it's primarily connected to a UART,
> >>maybe I should make it a sub-node to the UART node it's actually
> >>connected to? Something like:
> >>
> >>         uart2: serial@01c28800 {
> >>                 pinctrl-names =3D "default";
> >>                 pinctrl-0 =3D <&uart2_pins_a>;
> >>                 status =3D "okay";
> >>
> >>                 bt: bt_hci {
> >>                         compatible =3D "brcm,bcm20710";
> >>                         /* maybe add some generic compatible */
> >>                         pinctrl-names =3D "default";
> >>                         pinctrl-0 =3D <&clk_out_a_pins_a>,
> >><&bt_pwr_pin_cubietruck>;
> >>                         clocks =3D <&clk_out_a>;
> >>                         clock-frequency =3D <32768>;
> >>                         gpios =3D <&pio 7 18 0>; /* PH18 */
> >>                 };
> >>         };
> >>
> >>And let the uart core handle power sequencing for sub-nodes.
> >
> >Great, I missed this reply when I typed my mail I send a few minutes
> >ago. I agree that this approach is how thing should be.
>=20
> Regarding the device tree hierarchy this seems right, but powering
> the sub-nodes seems outside the realm of uart core.

Yet, a lot of devices are connected to an UART: GPS, BT chips, GSM
modems, even some odd PMICs, so UART acting like a real bus might make
sense.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cVp8NMj01v+Em8Se
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTUWXGAAoJEBx+YmzsjxAgc2EP/jNfZxEZ9Qr2rjo2mM00O31c
cgpKfqeIK5dltqGbRH+XsguhSHejHHeUb5D2sIir+Lw1NGKSSSmYo6NkfOR+ZjEq
Kll61JecGU9wCLxrGfYowzztskzIOWJyObV5So4js0/0vXrTEpDYrsCJyPUNqHLd
Byc8sAIB3B29Wd9cERxAfKL/4Gr06vZvj6VgNR4L5ib2+m2HzXyskEzvKWvWzBgP
pa90ilImsxFEU2gwslTt346GodkxI0LYncux6N5vbkSZVnsb24NBjNAdwyegahYt
epkWdErdDJl1+kVRZ1mnhJm9U57+Luv2a6ctiP/w7cQou6YPItcMyUydTHqgGC1d
vJ1HtEYSe5i1gQcCvtXUEas7RuCantM15DvbxQQNAww1D2+yGdtOoPHqCb5TvKiK
a4FN7c8jjDFnaUdUp/lwOYc5IMpelM7UL3d1WSB5whVlXDJHTl/MRs2LvrUnc5hs
PVW10WKKuh8XD/5MLbcFhG8d1WwJUQJxBnqRcY36yR5ohRq1fmT+NFHDu6eIyANP
Y1pPu2FxBYEkSQfoicqD+SOz0J/HQkRu+46MOYmk29eY70KZw09dJ0Vyml4f93I1
ZTWwUBJS41JiZQV2BT6blntiuxF2IPFAh1bQxD2WODvNdDzJyLHtb+A80a8kB3+m
yAJvn86vDRsJXSty4zJe
=dAfC
-----END PGP SIGNATURE-----

--cVp8NMj01v+Em8Se--
