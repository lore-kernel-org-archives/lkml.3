Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3IYKsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:48:43 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34907 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3IYKsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:48:41 -0400
Message-ID: <5242BF86.30302@monstr.eu>
Date: Wed, 25 Sep 2013 12:48:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Alan Tull <atull@altera.com>, Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
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
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu> <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com> <20130919172814.GA3855@obsidianresearch.com> <52403DB3.1080902@monstr.eu> <20130923171029.GA29429@obsidianresearch.com>
In-Reply-To: <20130923171029.GA29429@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="XbFWICGAGo3isBhOVmB7UcVLLKa47dW77"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XbFWICGAGo3isBhOVmB7UcVLLKa47dW77
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/23/2013 07:10 PM, Jason Gunthorpe wrote:
> On Mon, Sep 23, 2013 at 03:10:11PM +0200, Michal Simek wrote:
>=20
>>> 1) The driver doesn't know what firmware to request. It just knows
>>>    how to send it to a FPGA.
>>
>> But dts property in the manager driver which uses this as end driver
>> can know that.
>=20
> I think the device tree maintainers would push back on this since it
> is not "describing the hardware"

Yes. Then if you want to put it in this way firmware name doesn't need
to be specified in DTS and there can be default name in the driver
or you can read this information from i2c. There are options how to do
differently.

>>> 2) Telling the kernel a filename via sysfs and then having it go
>>>    around the long way via request_firwmare to get the data is silly.=

>>>    Just give the kernel the actual data instead of a file name
>>
>> Firmware interface is valid way how to pass bitstream to the kernel.
>> If you don't like just don't use it. For example you can add
>> firmware blob directly to the kernel and load this at bootup phase
>> without user-space access.
>=20
> I'm not against using request firmware for what it is ment for: having
> the kernel autonomously load firmware.
>=20
> I am against the sysfs API in the core code where userspace writes a
> file name that is then used to request_firwmare. That is a goofy API
> for the reasons I outlined.
>=20
> It is appropriate to use request firmware at the driver level where
> the driver somehow knows what FPGA to request.

I don't have enough information if this can be a problem in connection
to have goofy API but I have no problem to keep firmware interface
just at driver level.
And instead sending firmware name which should be loaded just
send data instead.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--XbFWICGAGo3isBhOVmB7UcVLLKa47dW77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJCv4YACgkQykllyylKDCHJQwCeNfbLewvmCc62Ezbwy9PK4DZ3
ZMQAnjwNHRd4Af3y1XEpb+MJTorzZ6L+
=gxQ7
-----END PGP SIGNATURE-----

--XbFWICGAGo3isBhOVmB7UcVLLKa47dW77--
