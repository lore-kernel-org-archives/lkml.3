Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3IYOnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:43:46 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57392 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3IYOno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:43:44 -0400
Message-ID: <5242F695.2070506@monstr.eu>
Date: Wed, 25 Sep 2013 16:43:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Philip Balister <philip@balister.org>
CC: Pavel Machek <pavel@denx.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <20130919100833.GC19346@amd.pavel.ucw.cz> <52421829.4050708@zytor.com> <20130925120052.GD9690@amd.pavel.ucw.cz> <5242F2EF.2050900@balister.org>
In-Reply-To: <5242F2EF.2050900@balister.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7cMS1VGWgH8O3I7V1O9DdIlnGj289JmpD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7cMS1VGWgH8O3I7V1O9DdIlnGj289JmpD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/25/2013 04:27 PM, Philip Balister wrote:
> On 09/25/2013 08:00 AM, Pavel Machek wrote:
>> Hi!
>>
>>>>> The firmware approach is interesting.  It might be less flexible
>>>>> compared with my original code (see link to git below) that this is=

>>>>
>>>> On the other hand... that's the interface world wants, right? To mos=
t
>>>> users, fpga bitstream is just a firmware.
>>>>
>>>
>>> No, not really.
>>>
>>> The typical assumption with the firmware interface is that there is
>>> exactly one possible firmware for each device (possibly modulated by
>>> driver version, but still.) =20
>>
>> Actually, I have seen counterexample there, too. Wifi card had
>> different firmware for host and access points mode, probably because
>> internal RAM could not fit both at same time.=20
>=20
> And another counter example ...
>=20
> For the Zynq based product I am working on, we encourage the end user t=
o
> create their own bitstreams to customize their application. So we need
> an easy way for the user to load a bitstream. cat foo.bin > /dev/xdevcf=
g
> works well for us.

You probably don't care if this will be
cat foo.bin > /sys/fpga/fpga0/<whatever>
(for zynq case you can also run)
cat foo.bit > /sys/fpga/fpga0/<whatever>

FYI: Current driver in xilinx repo supports bit format too.

> Then we need to make sure that the interface supports partial
> reconfiguration.

That will be next step.

> That said, having a sane user api that addresses the various fpga use
> cases would be a win for use since we would not need to write custom
> user space code for every platform created in the future. I'd like to
> see this api work with things like PCI based FPGA cards and discrete
> fpgas that are not integrated with an arm etc.

I don't have any PCI based FPGA card to have information how to work with=

it but for discrete fpga I have one application note where jtag is emulat=
ed
by gpio interface and you can program another fpga from zynq (This can
be probably generic case for any combination in this 4 pin connection).

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--7cMS1VGWgH8O3I7V1O9DdIlnGj289JmpD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJC9pUACgkQykllyylKDCFb+ACffQtEYbfwca98xfvws3PrftKb
7ysAn0x1uijj8g+X2CmwibWHut14Pfzx
=0z2L
-----END PGP SIGNATURE-----

--7cMS1VGWgH8O3I7V1O9DdIlnGj289JmpD--
