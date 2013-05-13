Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3EMHCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:02:42 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55389 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3EMHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:02:40 -0400
Message-ID: <5190900D.5020408@monstr.eu>
Date: Mon, 13 May 2013 09:02:37 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        microblaze-uclinux@itee.uq.edu.au, linux-mips@linux-mips.org,
        linux@openrisc.net, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-xtensa@linux-xtensa.org, Rob Herring <rob.herring@calxeda.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC] device-tree.git automatic sync from linux.git
References: <1366800525.20256.266.camel@zakaz.uk.xensource.com>
In-Reply-To: <1366800525.20256.266.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2COFCJWQJNTBFSTWMDDET"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2COFCJWQJNTBFSTWMDDET
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ian,


On 04/24/2013 12:48 PM, Ian Campbell wrote:
> Hi,
>=20
> First off apologies for the large CC list -- I think this catches the
> arch list for all the arches with device tree source in the tree.
>=20
> Various folks have expressed an interest in eventually splitting the
> device tree bindings out of the Linux git repository into a separate
> tree. This should help reduce the cross talk between the code and the
> bindings and to make it difficult to accidentally "co-evolve" the
> bindings and the code (i.e. break compatibility) etc. There are also
> other projects (such as Xen) which would also like to use device-tree a=
s
> an OS agnostic description of the hardware.
>=20
> I was talking to Grant about this at this Spring's LinaroConnect in Hon=
g
> Kong and as a first step he was interested in a device-tree.git
> repository which is automatically kept insync with the main Linux tree.=

> Somehow I found myself volunteering to set up that tree.
>=20
> An RFC repository can be found at:
>         http://xenbits.xen.org/gitweb/?p=3Dpeople/ianc/device-tree-reba=
sing.git
>=20
> This is created using git filter-branch and retains the full history fo=
r
> the device tree source files up to v3.9-rc8.
>=20
> The master branch contains everything including the required build
> infrastructure while upstream/master and upstream/dts contain the most
> recently converted upstream master branch and the pristine converted
> version respectively. Each upstream tag T is paired with a tag T-dts
> which is the converted version of that tag.
>=20
> Note that the tree will be potentially rebasing (hence the name) for th=
e
> time being while I'm still smoothing out the conversion process.
>=20
> The paths to include in the conversion are described in
> scripts/rewrite-paths.sed. The generic cases are:
>         arch/ARCH/boot/dts/*.dts and *.dts? (for dtsi and dtsp etc)
> 	arch/ARCH/boot/*.dts and *.dts?
>         arch/ARCH/include/dts/* (currently unused?)
> which become src/ARCH/*.dts and *.dts? plus src/ARCH/include/*
>=20
> There are also some special cases for some arches which don't follow
> this pattern and for older versions of the kernel which were less
> consistent. The paths were gleaned from git ls-tree + grep on every tag=

> in the tree, so if a file was added and moved between two rcs then the
> original path may not be covered (so the move will look like it just
> adds the files).
>=20
> In principal this supports the new .dtsp files and includes the require=
d
> include paths in the conversion but none of them seem to be in mainline=

> yet, so we'll have to see!
>=20
> The initial conversion took in excess of 40 hours (running out of a
> ramdisk) so even if the result is stable in terms of commit ids etc a
> fresh conversion every time isn't an option for a ~daily sync so I had
> to create a slightly hacked around git-filter-branch (found in
> scripts/git-filter-branch) to support incremental filtering, which I
> intend to send to the git folks soon.=20
>=20
> Please let me know what you think.

I have seen that discussion on youtube about this and connection
to arm dtses in the kernel.

Let me describe Microblaze case because probably Microblaze was the first=

architecture in the Linux kernel which was DT only from the beginning.

Just small overview it is a Xilinx soft core cpu where you can even setup=

some parameters for core itself - multiplier, divider, BS, fpu, cache siz=
es, etc.
You have to also compose the whole system and every platform/configuratio=
n is different
because you can setup addresses, IP on the bus, IRQs, etc.
Based on this configuration we have created tcl script which is able to g=
enerate
DTS directly from Xilinx design tool and it is working quite well for sev=
eral years
and everybody just use it without any problem.

As you see in your repo there is only one microblaze DTS which is for one=
 of mine
ancient configuration which none used.
It means from microblaze point of view we can simple remove it from mainl=
ine kernel
because it is useless.

I also care about arm zynq platform where situation is partially differen=
t because
zynq is fixed block but you can add others thing to programmable logic.
It means for zynq case we are almost in the same situation where every zy=
nq based
platform is using different configuration and that's why fpgas are so gre=
at.

It means for zynq case everybody will need different DTS but will be just=
 good
to describe or show binding.
Currently we have just one dts for zc702 xilinx reference board.

Let's move to my point.
Based on our experience all xilinx boards don't depend on any dts in the =
linux kernel
and our users just understand the reason why they should use our tcl scri=
pt for
DTS generation.

Back to your point about moving DTSes out of the kernel. For microblaze -=
 no problem
just do it. For arm zynq this is more problematic because there is weird =
binding
for ARM. For example PMU which is out of bus and should be probably in cp=
u node.
Also scu devices, scutimers, watchdog which lie on the bus for our case a=
nd we
need to use PPI interrupt cpu mask. Different clock binding, maybe pinmux=
 binding, etc.

It means from my point of view if binding is correct, no problem to move =
it
out of the kernel. If a kernel patch change binding, it is worth for me t=
o change
dts in the kernel too to reflect this change and track this change too.
My proposal is, let's clean all DTSes in the arm kernel that all platform=
 use
the same binding where all platforms are just correctly described.

The reaching this point I would suggest that for arm, arm-soc maintainers=
 should
keep eyes on any dts binding change and all these changes require ACK fro=
m Rob or Grant
(like device-tree maintainers).

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2COFCJWQJNTBFSTWMDDET
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGQkA0ACgkQykllyylKDCGwTwCgk7D1EI5QHh3Auwp+CZhRVBQd
OJUAnAsnL/NIk12tLZCRTvoDHJ4OpNc9
=ngN2
-----END PGP SIGNATURE-----

------enig2COFCJWQJNTBFSTWMDDET--
