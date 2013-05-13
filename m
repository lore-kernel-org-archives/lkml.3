Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3EMQAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:00:04 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40902 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3EMQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:00:01 -0400
Message-ID: <51910DDF.9010202@monstr.eu>
Date: Mon, 13 May 2013 17:59:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux@lists.openrisc.net" <linux@openrisc.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [RFC] device-tree.git automatic sync from linux.git
References: <1366800525.20256.266.camel@zakaz.uk.xensource.com>  <5190900D.5020408@monstr.eu> <1368446352.537.81.camel@zakaz.uk.xensource.com>
In-Reply-To: <1368446352.537.81.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2QBCIIVXWHHJKPXUNXKHP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QBCIIVXWHHJKPXUNXKHP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/13/2013 01:59 PM, Ian Campbell wrote:
> On Mon, 2013-05-13 at 08:02 +0100, Michal Simek wrote:
>> Just small overview it is a Xilinx soft core cpu where you can even se=
tup
>> some parameters for core itself - multiplier, divider, BS, fpu, cache =
sizes, etc.
>> You have to also compose the whole system and every platform/configura=
tion is different
>> because you can setup addresses, IP on the bus, IRQs, etc.
>> Based on this configuration we have created tcl script which is able t=
o generate
>> DTS directly from Xilinx design tool and it is working quite well for =
several years
>> and everybody just use it without any problem.
>=20
> That sounds very neat!
>=20
> Does this tcl script live in the kernel tree? If so would you think it
> would make sense for it to also migrate to device-tree.git? I'm not at
> all sure if that makes sense but if you think it does please let me kno=
w
> which paths need top be carried over.

No. This script is here.
https://github.com/Xilinx/device-tree/tree/master-next

It is tightly connected to Xilinx design tool that's why I don't think it=
 is useful
to add it to any other tree.


>> As you see in your repo there is only one microblaze DTS which is for =
one of mine
>> ancient configuration which none used.
>> It means from microblaze point of view we can simple remove it from ma=
inline kernel
>> because it is useless.
>=20
> That will then naturally get propagated over to device-tree.git.

I will think about it for a while and probably just remove it through my =
microblaze tree.


>> I also care about arm zynq platform where situation is partially diffe=
rent because
>> zynq is fixed block but you can add others thing to programmable logic=
=2E
>> It means for zynq case we are almost in the same situation where every=
 zynq based
>> platform is using different configuration and that's why fpgas are so =
great.
>>
>> It means for zynq case everybody will need different DTS but will be j=
ust good
>> to describe or show binding.
>> Currently we have just one dts for zc702 xilinx reference board.
>>
>> Let's move to my point.
>> Based on our experience all xilinx boards don't depend on any dts in t=
he linux kernel
>> and our users just understand the reason why they should use our tcl s=
cript for
>> DTS generation.
>>
>> Back to your point about moving DTSes out of the kernel.
>=20
> I suppose you are now commenting on the Phase II bit where maintenance
> of the DTS moves out of linux.git into device-tree.git, rather than
> Phase I work, which is creating a split repo which is automatically
> synchronised from linux.git but maintenance remains in linux.git, i.e.
> what I'm doing here.

ok.

>>  For microblaze - no problem
>> just do it. For arm zynq this is more problematic because there is wei=
rd binding
>> for ARM. For example PMU which is out of bus and should be probably in=
 cpu node.
>> Also scu devices, scutimers, watchdog which lie on the bus for our cas=
e and we
>> need to use PPI interrupt cpu mask. Different clock binding, maybe pin=
mux binding, etc.
>>
>> It means from my point of view if binding is correct, no problem to mo=
ve it
>> out of the kernel. If a kernel patch change binding, it is worth for m=
e to change
>> dts in the kernel too to reflect this change and track this change too=
=2E
>> My proposal is, let's clean all DTSes in the arm kernel that all platf=
orm use
>> the same binding where all platforms are just correctly described.
>=20
> AIUI this split/move isn't intended to change the existing policy, whic=
h
> is already that DTS files are supposed to remain compatible across
> kernel versions and that "flag days" are to be avoided. The split is
> supposed to make it harder (if not impossible) to accidentally break
> that policy.
>=20
> On the other hand I suppose there is an argument to be made for clearin=
g
> up the cruft *before* making the split.
>=20
> Ultimately I think this will be up to Grant & co.

ok.

>> The reaching this point I would suggest that for arm, arm-soc maintain=
ers should
>> keep eyes on any dts binding change and all these changes require ACK =
from Rob or Grant
>> (like device-tree maintainers).
>=20
> Yes, once we move onto Phase II I don't expect it will end up being me
> that is the DTS maintainer -- I expect the maintenance will remain with=

> those who take care of it in linux.git today.
>=20
> My involvement in Phase I is really just to help out with the transitio=
n
> (ulterior motive: the Xen project would also like to use these DTS
> files...) not to perform a "land grab" or take over maintenance etc. I
> certainly don't think I am the right person to become the long term
> maintainer of device-tree.git!

Ok. I see you point right now in connection to different project where
your Phase I make more sense.
Our flow, because of a lot of flexibility in fpga word, is more based on =
DTS which
we don't have in hand and everyone has to maintain it.
Starting to using not correct DTSes by another project will be problemati=
c.

It is good step but it suggests that they can start to use it but one cha=
nge
in the kernel binging will caused that it breaks another project.

=46rom my point of view this Phase I is good to do for DTSes which are co=
rrect.
Then another project can be sure that they won't change a lot.

I have the same experience with our DTS driven Qemu that it works when de=
scription
is stable but till that time it is just pain because you need to be sure
that all binding changes are also done in Qemu.

Thanks,
Michal




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2QBCIIVXWHHJKPXUNXKHP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGRDd8ACgkQykllyylKDCGFzQCePFBRbg/OcSwBeAYF2oGtJKFW
1mYAnRe5RQ9LxobNjuSS0LY/Fm4y6PtI
=k6P2
-----END PGP SIGNATURE-----

------enig2QBCIIVXWHHJKPXUNXKHP--
