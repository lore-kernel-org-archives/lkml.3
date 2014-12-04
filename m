Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbaLDTAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:00:44 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62434 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLDTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:00:43 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Thu, 4 Dec 2014 20:00:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201412040148.31033@pali> <CAL_JsqKYpDD1Rq2n92FcspPWGJeQvtA4eRYPDK=xYPQN0=uQTg@mail.gmail.com>
In-Reply-To: <CAL_JsqKYpDD1Rq2n92FcspPWGJeQvtA4eRYPDK=xYPQN0=uQTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2456774.4ZY0bWBhWD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412042000.38925@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2456774.4ZY0bWBhWD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 04 December 2014 17:49:40 Rob Herring wrote:
> On Wed, Dec 3, 2014 at 6:48 PM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > On Thursday 04 December 2014 01:33:08 Rob Herring wrote:
> >> On Mon, Nov 24, 2014 at 4:19 PM, Pali Roh=C3=A1r
> >=20
> > <pali.rohar@gmail.com> wrote:
> >> > On Wednesday 18 June 2014 22:46:19 Rob Herring wrote:
> >> >> On Wed, Jun 18, 2014 at 2:22 PM, Pali Roh=C3=A1r
> >> >=20
> >> > <pali.rohar@gmail.com> wrote:
> >> >> > On Wednesday 18 June 2014 21:07:35 Rob Herring wrote:
> >> >> >> On Wed, Jun 18, 2014 at 11:54 AM, Pali Roh=C3=A1r
> >> >> >=20
> >> >> > <pali.rohar@gmail.com> wrote:
> >> >> >> > Machine name from board description is some generic
> >> >> >> > name on DT kernel. DT provides machine name
> >> >> >> > property which is specific for board, so use it
> >> >> >> > instead generic one when possible.
> >>=20
> >> [...]
> >>=20
> >> >> > Basically in DT kernel is missing Hardware, Revision
> >> >> > and probably also Serial key. (Now I used only qemu
> >> >> > for testing which set serial key to 0). All these
> >> >> > informations is used by userspace applications which
> >> >> > determinate how to behave.
> >> >>=20
> >> >> It is somewhat fragile to expect the name in the DT to
> >> >> match the old name from the kernel. As your patch to
> >> >> n900 dts shows, we'd probably have to update every dts
> >> >> file to make them match. While I think we should work
> >> >> to remove this string from the kernel, userspace
> >> >> depending on the DT model string is a bad idea. For
> >> >> example, if you had some platform with multiple OEMs
> >> >> just rebranding the same base design, they may all want
> >> >> to put their own model string into each product. The
> >> >> true h/w id is the compatible string.
> >> >>=20
> >> >> Serial number is easy. There is already a standard
> >> >> although not widely used property for it with
> >> >> "/serial-number". You just need to wire it up to
> >> >> cpuinfo.
> >> >=20
> >> > There is no "/serial-number" property in kernel:
> >> >=20
> >> > $ ls -l -a /sys/bus/soc/devices/soc0/
> >> > drwxr-xr-x    3 0        0                0 Jan  1 00:00
> >> > . drwxr-xr-x   18 0        0                0 Jan  1
> >> > 00:00 .. -r--r--r--    1 0        0             4096 Jan
> >> >  1 00:00 family -r--r--r--    1 0        0           =20
> >> > 4096 Jan  1 00:00 machine drwxr-xr-x    2 0        0   =20
> >> >            0 Jan  1 00:00 power -r--r--r--    1 0      =20
> >> > 0
> >> > 4096 Jan  1 00:00 revision lrwxrwxrwx    1 0        0
> >> >=20
> >> >          0 Jan  1 00:00 subsystem -> ../../bus/soc
> >> >=20
> >> > -r--r--r--    1 0        0             4096 Jan  1 00:00
> >> > type -rw-r--r--    1 0        0             4096 Jan  1
> >> > 00:00 uevent
> >>=20
> >> Wrong place. If you put /serial-number in your DT, then it
> >> will be in /proc/device-tree/serial-number.
> >>=20
> >> If you want to wire that up to /proc/cpuinfo, I would be
> >> fine with that.
> >>=20
> >> Rob
> >=20
> > I cannot hardcode it into DT, because it is set by
> > bootloader. And bootloader tell it to kernel via ATAGs
> > structure. Bootloader is closed and proprietary and cannot
> > be replaced (there is no documentation for hw init).
>=20
> Either the bootloader can put the serial number into the DTB
> instead of ATAGs or the kernel decompressor can copy it from
> ATAGs to DTB like is done already for other ATAGs. I presume
> you cannot update the bootloader and will need the latter.
>=20
> Rob

And what about copying also Revision ATAG (passed by bootloader)=20
to DTB (in compressed code) and then show DTB revision in=20
/proc/cpuinfo file?

Would be something like this for Revision acceptable for=20
upstream?

Rob, and what about exporting /proc/atags file (to userspace)=20
also in DT boot if bootloader provides ATAG structure? It is=20
possible? Would be something like that accepted to upstream?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2456774.4ZY0bWBhWD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSAr1YACgkQi/DJPQPkQ1KR/wCfb+ngPVxayJkhvIPa4E61iVep
E2cAnitpfISEKGgOhpMVDwZTZ6sYHzl2
=RDgO
-----END PGP SIGNATURE-----

--nextPart2456774.4ZY0bWBhWD--
