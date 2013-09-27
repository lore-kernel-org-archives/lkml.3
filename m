Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3I0NcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:32:10 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34299 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3I0NcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:32:03 -0400
Message-ID: <524588C9.1090600@monstr.eu>
Date: Fri, 27 Sep 2013 15:31:53 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
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
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com>
In-Reply-To: <20130918203247.GA11181@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JfhvI3A2wO1Rjr0VRJa40rMS4xbMjSJVo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JfhvI3A2wO1Rjr0VRJa40rMS4xbMjSJVo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On 09/18/2013 10:32 PM, Jason Gunthorpe wrote:
> On Wed, Sep 18, 2013 at 03:15:17PM -0400, Jason Cooper wrote:
>=20
>> + Jason Gunthorpe
>=20
> Thanks, looks interesting, we could possibly use this interface if it=20
> met our needs..
> =20
>> On Wed, Sep 18, 2013 at 05:56:39PM +0200, Michal Simek wrote:
>>> This new subsystem should unify all fpga drivers which
>>> do the same things. Load configuration data to fpga
>>> or another programmable logic through common interface.
>>> It doesn't matter if it is MMIO device, gpio bitbanging,
>>> etc. connection. The point is to have the same
>>> inteface for these drivers.
>=20
> So, we have many years of in-field experience with this and this API
> doesn't really match what we do.
>=20
> Here are the steps we perform, from userspace:
>  - Ask kernel to place FPGA into reset and prepare for programming
>    * Kernel can return an error (eg FPGA failed to erase, etc)
>    * this is the PROG_N low -> DONE high, PROG_N high -> INIT_N high
>      sequencing on Xilinx chips
>  - Ask kernel to load a bitstream.
>    * Userspace locats the bitstream file to load, and the mmaps it.
>    * Userspace passes the entire file in a single write() call to the
>      kernel which streams it over the configuration bus
>    * The kernel can report an erro rhere (eg Xilinx can report CRC
>    error)
>  - Ask the kernel to verify that configuration is complete.=20
>    * On Xilinx this wait for done to go high
>  - Ask the kernel to release the configuration bus (tristate
>    all drivers) (or sometimes we have to drive the bus low,
>    it depends on the bitfile, user space knows what to do)
>=20
> It is very important that userspace know exactly which step fails
> because the resolution is different. We use this in a manufacturing
> setting, so failures are expected and need quick root cause
> determination.
>=20
> You could probably address that need by very clearly defining a
> variety of errno values for the various cases. However, it would be a
> disaster if every driver did something a little different :|
>=20
> Using request_firmware exclusively is not useful for us. We
> format the bitfile with a header that contains our internal tracking
> information. Sometimes we need to bitswap the bitfile. Our userspace
> handles all of this and can pass a bitfile in memory to write().
>=20
> request_firmware would be horrible to use :)
>=20
> Our API uses a binary sysfs attribute to stream the FPGA data, you
> might want to consider that.

I have done some experiments with binary sysfs attribute and can
you please be more specific how you are working with it?

I expect that you are detecting/specifying in the driver which
fpga is connected and you also need to know size of this device.
Then your driver allocate buffer with this size in the kernel
and streming data to this buffer. When this is done you are
using another sysfs files to control device programming.

Can you please correct me if I am wrong?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--JfhvI3A2wO1Rjr0VRJa40rMS4xbMjSJVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJFiMkACgkQykllyylKDCGQoQCffUDfk4OKX/7YgHvPbcSNVe5O
p5IAn0Sc+614l52r2pNfgWUEAGkGq9Ro
=m5k0
-----END PGP SIGNATURE-----

--JfhvI3A2wO1Rjr0VRJa40rMS4xbMjSJVo--
