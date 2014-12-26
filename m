Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaLZPxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 10:53:00 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56721 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLZPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 10:52:59 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: 3.19-rc1 errors when opening LID
Date: Fri, 26 Dec 2014 16:52:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <201412241951.48652@pali> <3406993.nnu7vUsHIn@vostro.rjw.lan>
In-Reply-To: <3406993.nnu7vUsHIn@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2803232.V5hP08oaOP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412261652.54112@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2803232.V5hP08oaOP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 26 December 2014 16:12:49 Rafael J. Wysocki wrote:
> On Wednesday, December 24, 2014 07:51:48 PM Pali Roh=C3=A1r wrote:
> > --nextPart5943893.pKyMBm5Emp
> > Content-Type: Text/Plain;
> >=20
> >   charset=3D"utf-8"
> >=20
> > Content-Transfer-Encoding: quoted-printable
> >=20
> > Hello!
> >=20
> > With new 3.19-rc1 kernel every time when I open LID on my
> > laptop, kernel pr=3D
>=20
> > ints these error lines to dmesg:
> Does your syste suspend when the lid is closed and resume when
> it is open?
>=20

No, I disabled all autosuspend and autohibernate settings. When I=20
close LID system is running.

>=20
> > [25568.448566] acpi MSFT1111:00: Cannot transition to power
> > state D3cold fo=3D r parent in (unknown)
> > [25568.448572] acpi INT33C2:00: Cannot transition to non-D0
> > state from D3 [25568.448577] acpi MSFT0002:00: Cannot
> > transition to power state D3cold fo=3D r parent in (unknown)
> > [25568.448581] acpi ELAN1010:00: Cannot transition to power
> > state D3cold fo=3D r parent in (unknown)
> > [25568.448587] acpi INT33C3:00: Cannot transition to non-D0
> > state from D3 [25568.448590] acpi INT33C0:00: Cannot
> > transition to non-D0 state from D3 [25568.448594] acpi
> > INT33C1:00: Cannot transition to non-D0 state from D3
> > [25568.448598] acpi INT33C4:00: Cannot transition to non-D0
> > state from D3 [25568.448602] acpi INT33C5:00: Cannot
> > transition to non-D0 state from D3 [25568.448623] acpi
> > device:41: Cannot transition to power state D3cold for =3D
> > parent in (unknown)
> > [25568.448627] acpi INT33C6:00: Cannot transition to non-D0
> > state from D3
>=20
> All of the above mean that power transitions were not carried
> out for some devices, because they were in unexpected power
> states to start with.
>=20
> They are devices on the Intel LPSS as far as I can say (CCing
> Mika and Andy).
>=20

Just to note: all above acpi devices do not exist in 3.13 kernel,=20
at least I do not see them in /sys/bus/acpi/.

> > [25568.448890] pci_bus 0000:01: Allocating resources
> > [25568.448905] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> > flags 0x2] has bog=3D us alignment
> > [25568.449064] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> > flags 0x2] has bog=3D us alignment
> > [25568.449472] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> > flags 0x2] has bog=3D us alignment
> >=20
> > With older kernel (3.13) I do not see these errors, so it is
> > regression.
>=20
> It only is a regression if it leads to functional problems.=20
> Do you see any?
>=20

Ok. I do not see functional problems, but I see above messages in=20
dmesg log every time when I open LID.

> > Ca=3Dn you look at it? If it is needed, I can provide other
> > logs, ACPI/DSTD dump=3D s, etc.
>=20
> It looks like 3.13 didn't try to use some devices that are now
> used in 3.19-rc1 and something doesn't work entirely as
> expected.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2803232.V5hP08oaOP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSdhFYACgkQi/DJPQPkQ1IcRgCfZ1PB+47+ZP/JBFnXrH8crdYe
eN8An2gTl3SxG/HthbWXi4ElZwy7Jc23
=zisQ
-----END PGP SIGNATURE-----

--nextPart2803232.V5hP08oaOP--
