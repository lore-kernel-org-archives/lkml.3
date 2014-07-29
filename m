Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaG2KXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:23:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49666 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaG2KXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:23:49 -0400
Date: Tue, 29 Jul 2014 12:23:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: caesar <caesar.wang@rock-chips.com>, Doug Anderson <dianders@chromium.org>,
        linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
Message-ID: <20140729102341.GC21182@ulmo.nvidia.com>
References: <1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>
 <20140721085001.GG8843@ulmo>
 <53CD0E82.6030901@rock-chips.com>
 <20140721132723.GH15238@ulmo>
 <53D23192.4000908@rock-chips.com>
 <CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>
 <53D50601.1020106@rock-chips.com>
 <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>
 <53D631B6.1050603@rock-chips.com>
 <CAOesGMgPDOQ0Z5b+d8nCiT4q_OGcYfv0zCb1naZVAqapaOtnPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <CAOesGMgPDOQ0Z5b+d8nCiT4q_OGcYfv0zCb1naZVAqapaOtnPw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 09:58:22AM -0700, Olof Johansson wrote:
> On Mon, Jul 28, 2014 at 4:19 AM, caesar <caesar.wang@rock-chips.com> wrot=
e:
> > Doug,
> > =E5=9C=A8 2014=E5=B9=B407=E6=9C=8828=E6=97=A5 12:01, Doug Anderson =E5=
=86=99=E9=81=93:
> >
> >> Caesar,
> >>
> >> On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com>
> >> wrote:
> >>>
> >>> /*I think will be show the faill log:->
> >>>
> >>> * rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
> >>> 0xff9301a0-0xff93019f]
> >>> */
> >>>
> >>> pc->base =3D devm_ioremap_resource(dev, regs);
> >>
> >> Did you actually code this up and try it and get this error?
> >
> > Yeah.
> >
> >> I hadn't
> >> tried it but I researched other dts files and it looked as if there
> >> was one example that was doing this.  ...but perhaps it wasn't
> >> actually doing the ioremap_resource on both ranges.
> >>
> >> I'd imagine that this is _probably_ equivalent to what Thierry was
> >> suggesting, so if it didn't work then maybe Thierry's won't work
> >> either?
> >>
> >> I don't have any other great suggestions other than doing two memory
> >> ranges for lcdc:
> >>
> >>           lcdc@ff930000 {
> >>                   compatible =3D "rockchip,rk3288-lcdc";
> >>                   reg =3D <0xff930000 0x1a0>, <0xff9301b0 0xfe50>;
> >>                   ...
> >>           };
> >>           pwm@ff9301a0 {
> >>                   compatible =3D "rockchip,vop-pwm";
> >>                   reg =3D <0xff9301a0 0x10>;
> >>                   ...
> >>           };
> >>
> >> ...but I am certainly nowhere near an expert on this stuff...
> >>
> >> -Doug
> >>
> >>
> >>
> > I has solve in lcdc driver,but I always feel awkward. I think a good wa=
y to
> > solve in pwm driver.
> > Unfortunately that  so far ,I have not a good idle in pwm driver.
> >
> > Maybe,I  let do it that way in lcdc driver.
>=20
> I think there's an easier way to do this, by not focusing _too_ much
> on the device tree:
>=20
> * Define a platform_data structure for the PWM driver, which contains
> readl/writel accessors as well as the device type (i.e. what you use
> the compatible field and the lookup table for today).
> * Populate the platform_device in the clcd driver, and register that
> * Make the PWM driver probe as a regular platform device if pdata is pass=
ed
> * Make a readl/writel wrapper that either falls back to native
> readl/writel when there aren't any passed in, or make the DT code fill
> in the pdata with the native versions in that case.

That's one option, but it isn't going to work if you ever want to refer
to the PWM subdevice by phandle, since no phandle will exist.

Thierry

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT13YtAAoJEN0jrNd/PrOhkdYP/17OSUnlTMEdfHEShU4RTJhz
J0yg0MiC/3Cx2QLC2YD3uwHvJJJ+fPPLkC7QD9D8evbC+7lSOZ6VzBrJz71edzZO
24Nn+aM79dPaBlFmMGEXbaKBbQFYp63Glo0D5256WJg9xTARF8X1ncbfhYwV9ft9
xM83GB+fPgGARYGvXv89Ex/luGnhe4j/5bWieXqj8IULPnBSXu4/8cDlRaUYlqP1
Tlc3MB9l1IiRZZsSgCAw2YwTHrDDrNmcphQFSfyujwqbiWMiJbAj8led9AxIGYC+
8pYLgoxDJm/Y2E3oH1aCoNa5pKEtUMPhZYr6NOVALEOSfFdG+1JyAXUO5mbT4/Mk
4tDaEBk96RQqEn7WOEqhQStrzqQwDONCnxp90M8E1dr2RXMbXmqDrgX87okNDYYY
TCoO9yuXEZspauhxrprdasE4ZBmWS63SV8zMJyFGV+8xtFBtKcBQ6/IxuCRDRD5J
s5MY55iXMbG30pAGilHPFJkqXuw8j80/LrgBQrrpmmPBD1rh/MsLWzP/x2zUCdpE
3PkhLSqw0MLJXz5Ak8uP1B0dxxZYN3AyONGuwnj5sznDc26STiHN6cn7mE5OHQ4O
d7KXLlOxFbIxhck4qkeNon5/cJNJmpPUgEF2bJBxvBQe6VppcU4HkkkM4sHgNIGI
5b1zPBu6oeLapmutkdKf
=o9Ez
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
