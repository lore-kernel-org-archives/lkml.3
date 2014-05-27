Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaE0Ac0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:32:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:56326 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaE0AcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:32:25 -0400
Date: Tue, 27 May 2014 02:32:20 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
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
Message-ID: <20140527003219.GD32691@earth.universe>
References: <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
 <20140520055026.E3A98C412DA@trevor.secretlab.ca>
 <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
 <20140526104824.63F13C42129@trevor.secretlab.ca>
 <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
 <20140526112348.907B7C421A5@trevor.secretlab.ca>
 <A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
 <20140526213303.C1C73C40E11@trevor.secretlab.ca>
 <20140526223630.GA32691@earth.universe>
 <5383D174.8070304@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <5383D174.8070304@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 04:42:44PM -0700, Guenter Roeck wrote:
> On 05/26/2014 03:36 PM, Sebastian Reichel wrote:
> >On Mon, May 26, 2014 at 10:33:03PM +0100, Grant Likely wrote:
> >>After thinking about it more, I think it is very likely that removing
> >>all the overlays is the correct thing to do in the kexec use-case. When
> >>kexec-ing, it makes sense that we'd want the exact same behaviour from
> >>the kexec'ed kernel. That means we want the device drivers to do the
> >>same thing including loading whatever overlays they depend on.
> >>
> >>If the flattened tree was left applied, then the behaviour becomes
> >>different.
> >>
> >>I say always remove the overlays unless explicitly told not to, but I'm
> >>struggling to come up with use cases where keeping them applied is
> >>desirable.
> >
> >I would assume, that I want them applied in most cases. DT describes
> >the hardware. If I kexec into a new kernel I change software, not
> >hardware.
> >
> >Maybe I'm missing the main purpose of the feature. I currently see
> >two useful usecases for DT overlays:
> >
> >1. The dtb the kernel is booted with cannot be changed for some
> >    reason, but the board has additional hardware attached (e.g.
> >    the user added a sensor on the i2c bus)
> >2. The hardware is changed on the fly (e.g. the user flashed the
> >    FPGA part of a zynq processor), sensors on i2c bus, ...
> >
> >In both cases the kernel should be booted with the additional
> >overlay information IMHO. Though for the second case it should
> >be possible to remove the "programmed" hardware information
> >somehow.
> >
>=20
> 3. Some hot-plug device or card is inserted or removed.

Can you give a more specific example? I guess most hot-plug
devices are connected to busses, which are not described via
DT, but support auto-identification (USB, PCI, ...)

> I would argue that the kernel should _not_ be booted with the
> overlay in place.

well the device is still attached to the system when you kexec
into the new kernel, isn't it?

> Otherwise the code handling overlays would have to have special
> handling for the restart case, which is much more complex than
> just to re-insert the overlay when it is determined that the
> device or card is still there.

I assume, that the kernel cannot auto-detect the attached hardware.
Otherwise we don't need the DT entries, but can simply scan the bus.
So the restart case (or restart + kexec case if kexec behaves like a
restart) means, that userspace needs to provide the information
about device existence.

Removing the overlay is like dropping information supplied from the
user. Not something, which should be done carelessly.

-- Sebastian

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTg90TAAoJENju1/PIO/qao6QQAI5UEaeiknOT4YoL+YSdbH3/
N3igTrsxru18Ck6LhA+EmtJc0wSGYE4olfdHfnOLLSsHu3bK7DbMRH7bmwW16wmv
2IvG22BpMcA3oh8RbiSbQVbnpOtlazYwX8CpkYepnMV60UaPxjfY6xgCAdSdkPbi
hXiaqzhfSdqYAHVDJynPl1dB+4kRyk8xiQFhdioCB0mjZblOBYYx0SpGffS6zlEF
daVVANd02tuRm/UZ341oXH4iFVBENUsBv2Av6l5TG1+vIE8SytXzusBo97QyxmgJ
4bKFgByRkxvwGet0hSF+BqzJvwNTOkDnoOSxMzgi5FebFm9/7QquX5A7X4y3KdsA
wV+Fksuc2BUpcZy1NzlDNwcvrMlU8SbgT983hNUkByosxr6PW7KBJrD9WtsolgH2
r+vMXcLx/vL664KzXAKIP1RhcoeCgwg0OnGfgXgszmvhe0ypPuw2amScEdmjBqck
j/FQmD7IILN1/fndH9mvD+dCmDJWeB0l/dkrhR7kcjl2nnHiq/Bn3mikOiDlzzZ3
7ATi7yKSaQZ1PKOF9vl6uPsj5/GHrMdiIGB3Xy6RjYE90crRn6gToo2iX2yC3nmk
FA1SCYOGpTmn85qepS1P9vP+KoXGtNkqGTeRxP1xjiu866yw4JRWrxKwod3vy+AB
i6kJPihV5k7yb0kcvXxr
=+oV6
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
