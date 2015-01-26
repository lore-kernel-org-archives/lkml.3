Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbbAZJf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:35:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbbAZJfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:35:22 -0500
Message-ID: <54C60A56.7010403@suse.de>
Date: Mon, 26 Jan 2015 10:35:18 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com> <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl> <54C5F89A.3090901@suse.de> <54C5F965.90100@monstr.eu> <54C5FBC3.7030903@suse.de>
In-Reply-To: <54C5FBC3.7030903@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IQ2PJjWJADvmgolNgg8stDx9uFR6W9Nb4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IQ2PJjWJADvmgolNgg8stDx9uFR6W9Nb4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 26.01.2015 um 09:33 schrieb Andreas F=E4rber:
> Am 26.01.2015 um 09:23 schrieb Michal Simek:
>> On 01/26/2015 09:19 AM, Andreas F=E4rber wrote:
>>> And if I apply it to my -next based tree, adding corresponding nodes =
to
>>> zynq-parallella.dts, I get repeatedly:
>>>
>>> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT
>>> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
>>> f090e100 op: f090e140
>>> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe defer=
ral
>>> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT
>>> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
>>> f0910100 op: f0910140
>>> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe defer=
ral
>>>
>>> Am I missing any other patches or config options?
>>> (I do notice that the pinctrl v3 patch that got merged has a trivial =
bug
>>> for usb0, for which I'll send a patch later on.)
>>
>> Why is it deferred? Is it because of pinmuxing stuff?
>=20
> No, happened without as well.
>=20
> Looking at a different place in dmesg, I spot this:
>=20
> [  +0,003988] usb_phy_generic phy0: GPIO lookup for consumer reset-gpio=
s
> [  +0,000012] usb_phy_generic phy0: using device tree for GPIO lookup
> [  +0,000015] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'=

> property
>  of node '/phy0[0]'
> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
> property
> of node '/phy0[0]'
> [  +0,000010] usb_phy_generic phy0: using lookup tables for GPIO lookup=

> [  +0,000153] usb_phy_generic phy0: lookup for GPIO reset-gpios failed
> [  +0,000012] usb_phy_generic phy0: Error requesting RESET GPIO
> [  +0,004360] usb_phy_generic: probe of phy0 failed with error -2
> [  +0,004991] usb_phy_generic phy1: GPIO lookup for consumer reset-gpio=
s
> [  +0,000012] usb_phy_generic phy1: using device tree for GPIO lookup
> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'=

> property
>  of node '/phy1[0]'
> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
> property of node '/phy1[0]'
> [  +0,000010] usb_phy_generic phy1: using lookup tables for GPIO lookup=

> [  +0,000012] usb_phy_generic phy1: lookup for GPIO reset-gpios failed
> [  +0,000011] usb_phy_generic phy1: Error requesting RESET GPIO
> [  +0,004337] usb_phy_generic: probe of phy1 failed with error -2
>=20
> So, I guess the chipidea driver is deferring because the phys want a
> property that neither me nor you are specifying? Would that be the two
> MDIO pins 52 and 53 that would need to be specified?

Erm, scratch that last question - wrong PHY. Trying it resolved the
above phy errors but not the original problem. And so does an empty one:

@@ -99,11 +100,13 @@

        usb_phy0: phy0 {
                compatible =3D "usb-nop-xceiv";
+               reset-gpios =3D <>;
                #phy-cells =3D <0>;
        };

        usb_phy1: phy1 {
                compatible =3D "usb-nop-xceiv";
+               reset-gpios =3D <>;
                #phy-cells =3D <0>;
        };
 };

In my manuals and notes I can't find any GPIO being used as reset for
the USB PHYs. Any thoughts appreciated.

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)


--IQ2PJjWJADvmgolNgg8stDx9uFR6W9Nb4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxgpWAAoJEPou0S0+fgE/OIQP/RI1BwNGStRF0jyuN5uS49HQ
k6iEaUprAuW7rSxxsN9bLlrYcjcov6YuiDkw+FT5DhA4+rPxJsfbr9HmWX//SGpE
/Jqk5BbCexZChBgHyRfDGDFwSH77EQcGh84Gz+/CqNyC1Z8/vmQdvegp+psv2Kji
pRK5lT2kUV2vK7ztACqZemzHCAourpxlMMhK+plgfA/T2rAZv5Y+0P73luJIc898
s8AeMPctMSUnOMlki5EQL8rtgpRCp0WsuGVL8oBkNMTdVmQiC5rlo/87ihdgxzta
BCxGLxk1SIbr6+b/4R4dYA692DA3zdSwls3eEoK+3cC/GCkzU0JUnUh+ROEMB1G1
ShZ8uPltxl6vr6bdfLD/3LM28f601ayKT9rO6dYd7lwA2i0sustSv8Mxb+YN92V0
EFVjPZsReD47GV8zAkWf8/1J/YYsVMRCSvzNy0Ucxeq/ZBvmZJXK/B7P59qsdtnU
iTdQh5B7dF1QRqniiTUxOPnmWWi3Ex09+IXpnmOQa/3clGKecuMXax6W0LHtvSkS
dWTfIFLDG1x67PRgVJEqhRaGJCKKIgQ2Nv+RtO3cvsrZB7a7icpffQs7ODdmOiyg
Breqj5KklmT9x7nIeazFFsbYCWj4D5XqzeEcnrESkD7Blf7n7+HgZ5qgowbJZIc2
wfeFwM8EwF1LnkdZtCzv
=ISKl
-----END PGP SIGNATURE-----

--IQ2PJjWJADvmgolNgg8stDx9uFR6W9Nb4--
