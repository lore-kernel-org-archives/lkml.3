Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3IYKlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:41:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45207 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:41:38 -0400
Message-ID: <5242BDDD.6040303@monstr.eu>
Date: Wed, 25 Sep 2013 12:41:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Pavel Machek <pavel@denx.de>, Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <20130919100833.GC19346@amd.pavel.ucw.cz> <52421829.4050708@zytor.com>
In-Reply-To: <52421829.4050708@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PPHIrhwjOjWEdWphmfiDFSxujuFaf7LbB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PPHIrhwjOjWEdWphmfiDFSxujuFaf7LbB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 09/25/2013 12:54 AM, H. Peter Anvin wrote:
> On 09/19/2013 03:08 AM, Pavel Machek wrote:
>>
>>> The firmware approach is interesting.  It might be less flexible
>>> compared with my original code (see link to git below) that this is
>>
>> On the other hand... that's the interface world wants, right? To most
>> users, fpga bitstream is just a firmware.
>>
>=20
> No, not really.
>=20
> The typical assumption with the firmware interface is that there is
> exactly one possible firmware for each device (possibly modulated by
> driver version, but still.)  This is blatantly not true for an FPGA in
> the most extreme way possible -- there are an almost infinite number of=

> ways one can load an FPGA.

That's truth but on the other hand on target hw you probably have
well known bitstream which you want to load to the device and your
drivers exactly know based on board revision what firmware you want to lo=
ad.

> However, I have to question the whole idea of an "FPGA subsystem" --
> there is an almost infinite number of ways to program an FPGA or FPGA
> programming device (which may even be a commodity flash with a
> microcontroller or CPLD, and may be shared with other devices), and it
> really doesn't make any inherent sense to lump them together.

That's exactly discussion what I would like to have about this concept
in general.
I can agree that there are number of ways how to program fpga/cpld and ot=
hers.
I wouldn't say infinite number just because of users can choose really
custom options.
I would say there are some standard ways how to load bitstream to fpga/cp=
ld.
The most of customers just use them and they can be described.

Currently I do more care about zynq devcfg driver for loading bitstream
to zynq PL and partially icap driver just because it is in the mainline.
But there are others way though gpio, etc. Altera has also their drivers
for doing this type of work.
If you look at current state in connection to the kernel then for example=

hwicap just create char driver. zynq devcfg driver which we have in xilin=
x tree
just create another char driver. Altera (please guys correct me if I am w=
rong)
has one driver drivers/misc/altera-stapl in the kernel which is used by a=
ny pci
card which is working with firmware interface.
Then they have any fpga-bridge in their tree which create any new class
+ origin fpga-mgr which is I think for their socfpga programming.

In general all these drivers can just create whatever user interface
they like and just start to pushing these drivers to the mainline
to char or misc folders.
But IMHO all of them just do the same program fpga/cpld trough particular=

interface but why not just to have fpga core driver just to unify
this user access.

When we have agreement on this another valid discussion is
if firmware interface is OK for this purpose or NOT. Or if make sense
to create different interface or have all of them.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--PPHIrhwjOjWEdWphmfiDFSxujuFaf7LbB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJCvd0ACgkQykllyylKDCHkiQCeIvsEx/uDu12AEV/KeVp4wH5T
r00An2XXmg0FoKrAUQStX5WlSh+aiwyy
=Yapc
-----END PGP SIGNATURE-----

--PPHIrhwjOjWEdWphmfiDFSxujuFaf7LbB--
