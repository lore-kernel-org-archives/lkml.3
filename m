Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaEZWgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:36:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:54320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaEZWgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:36:35 -0400
Date: Tue, 27 May 2014 00:36:30 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Message-ID: <20140526223630.GA32691@earth.universe>
References: <CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>
 <20140516105814.3EA3FC403C2@trevor.secretlab.ca>
 <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
 <20140520055026.E3A98C412DA@trevor.secretlab.ca>
 <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
 <20140526104824.63F13C42129@trevor.secretlab.ca>
 <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
 <20140526112348.907B7C421A5@trevor.secretlab.ca>
 <A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
 <20140526213303.C1C73C40E11@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20140526213303.C1C73C40E11@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 26, 2014 at 10:33:03PM +0100, Grant Likely wrote:
> After thinking about it more, I think it is very likely that removing
> all the overlays is the correct thing to do in the kexec use-case. When
> kexec-ing, it makes sense that we'd want the exact same behaviour from
> the kexec'ed kernel. That means we want the device drivers to do the
> same thing including loading whatever overlays they depend on.
>=20
> If the flattened tree was left applied, then the behaviour becomes
> different.
>=20
> I say always remove the overlays unless explicitly told not to, but I'm
> struggling to come up with use cases where keeping them applied is
> desirable.

I would assume, that I want them applied in most cases. DT describes
the hardware. If I kexec into a new kernel I change software, not
hardware.

Maybe I'm missing the main purpose of the feature. I currently see
two useful usecases for DT overlays:

1. The dtb the kernel is booted with cannot be changed for some
   reason, but the board has additional hardware attached (e.g.
   the user added a sensor on the i2c bus)
2. The hardware is changed on the fly (e.g. the user flashed the
   FPGA part of a zynq processor), sensors on i2c bus, ...

In both cases the kernel should be booted with the additional
overlay information IMHO. Though for the second case it should
be possible to remove the "programmed" hardware information
somehow.

-- Sebastian

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTg8HuAAoJENju1/PIO/qaNmgP/jnomQAKsCJ1AIRJLvOXnMRq
tQRkJ1pWWW46W3t+dPbmyifRKuT7VL0ylZwSOySoQ/MG/Lw5VhSy4HkYVLc18gfh
dookRIUMrmoKOmjzG31ykCMU8397lofN1Ry0PKWB1p5LzvuhM4KBvqH5L2DLk7c2
9kCz8vsenmFwKyjWnO31EGtf1fNrufK2NMQVIooh0dvClqcQVuFXR287t8LWd+ep
L4Avbfk9KVpeWC7ES7/MsHiwqIjn3EFqzc52vijaQ/J5TOw4ySgH1nFc+wzU7ae3
vyoRmQ/yPYN7By1NGSqWTy0uMMD/4DR52kP4qsUn8VWGcIWoXfMmRpeZzctyAujS
MsWkG5ZzdA7POBGD+YTyzvg/JeIsY0+InRjV9bq1bsZmK58y2Go+IOFRQK7n4wwZ
wCx2yfeziAGy8EM0ZxlAfu9US6pfhVp5qsy6IcKdqHu5YP5CB/btyd0AmZ1+uDw2
LdHTo4TszXbAUHRkQWML9GQE65n7s5CNXcOxdlLpYtKg++UfAIAoip3qVpGY1coX
TTuIdlNYDqrL+1/YAa5pRvE5+FndL82WZR9eqBadOuJOO7QdIHUXw0VnKcAmHBsE
2u9mDqPjKeNLjLeGxutoYRu9u3bRip6QPtjR1iYDgizzPnsSd4JA/0yCmLLAcdPD
0/8ZCeNCV2m+BzagEEBJ
=yR8R
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
