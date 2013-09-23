Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3IWNKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:10:19 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:54452 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3IWNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:10:17 -0400
Message-ID: <52403DB3.1080902@monstr.eu>
Date: Mon, 23 Sep 2013 15:10:11 +0200
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
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu> <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com> <20130919172814.GA3855@obsidianresearch.com>
In-Reply-To: <20130919172814.GA3855@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MqSdvElB1pX0U9tbwMgTFCI8wkIKkwnCf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MqSdvElB1pX0U9tbwMgTFCI8wkIKkwnCf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 07:28 PM, Jason Gunthorpe wrote:
> On Thu, Sep 19, 2013 at 10:18:03AM -0500, Yves Vandervennet wrote:
>> On Thu, Sep 19, 2013 at 5:55 AM, Michal Simek <monstr@monstr.eu> wrote=
:
>>
>>>> Is there some way a per-device userspace helper can be added that ca=
n
>>>> handle adding the headers?  Such that different fpga types get diffe=
rent
>>>> helpers?
>>>
>>> What do you exactly mean by that? Any example what do you want to ach=
ieve?
>> Bit streams may not be in raw format, so using 'cat' is not possible.
>> Xilinx and Altera have their own bit stream "richer" format, that need=

>> to be processed before they are presented to the driver(s). So, a
>> hotplug helper per manufacturer/FPGA is required. Assuming 'cat' will
>> be used is too limiting.
>> Does it make sense to you?
>=20
> IMHO it doesn't make sense to use request firmware for this, in
> general.

If this is not the best way for you than fine just don't use it.

As I wrote I see a value to have sysfs bin file for this and
you don't need to use this request firmware interface.

>=20
> 1) The driver doesn't know what firmware to request. It just knows
>    how to send it to a FPGA.

But dts property in the manager driver which uses this as end driver
can know that.

> 2) Telling the kernel a filename via sysfs and then having it go
>    around the long way via request_firwmare to get the data is silly.
>    Just give the kernel the actual data instead of a file name

Firmware interface is valid way how to pass bitstream to the kernel.
If you don't like just don't use it. For example you can add firmware blo=
b directly
to the kernel and load this at bootup phase without user-space access.


> 3) It is hard to use, when userspace writes the file name the kernel
>    doesn't return until request_firmware completes, which means you
>    need multiple threads in user space to make this work.

that's again and again.

> 4) Converting an input file into bitstreamable format should be done
>    in userspace. This doesn't require request_firmware. If you want
>    to make it automatic then a program invoked via udev is the way
>    to go.

why are you restricting who should do this work? From my point of view
you are just pushing to have open way how to do it from user space
and there will be this option. But don't try to restrict others
if they want to do it just in the kernel in early phase.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform




--MqSdvElB1pX0U9tbwMgTFCI8wkIKkwnCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJAPbMACgkQykllyylKDCEZLQCfTuIhYEYouOQFShTeE7wvo6/5
M4AAn1xDJyQk3Gg4F3fvXEmf/aK+UYDV
=hoeX
-----END PGP SIGNATURE-----

--MqSdvElB1pX0U9tbwMgTFCI8wkIKkwnCf--
