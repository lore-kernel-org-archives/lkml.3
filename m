Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3JDP1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:27:34 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41407 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3JDP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:27:33 -0400
Message-ID: <524EDE5C.4040902@monstr.eu>
Date: Fri, 04 Oct 2013 17:27:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alan Tull <atull@altera.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <cover.1380727889.git.michal.simek@xilinx.com> <1380836768.3815.27.camel@atx-linux-37>
In-Reply-To: <1380836768.3815.27.camel@atx-linux-37>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="89HLq3DBujDg9c96C999tFCBnIpmbsr4i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--89HLq3DBujDg9c96C999tFCBnIpmbsr4i
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 10/03/2013 11:46 PM, Alan Tull wrote:
> On Wed, 2013-10-02 at 17:35 +0200, Michal Simek wrote:
>=20
>>
>> Through firmware interface:
>> cat /sys/class/fpga_manager/fpga0/name
>> echo -n fpga.bin > /sys/class/fpga_manager/fpga0/firmware
>>
>> Through sysfs bin file:
>> cat /sys/class/fpga_manager/fpga0/fpga_config_state
>> echo -n write_init > /sys/class/fpga_manager/fpga0/fpga_config_state
>> cat /lib/firmware/fpga.bin > /sys/class/fpga_manager/fpga0/fpga_config=
_data
>> echo -n write_complete > /sys/class/fpga_manager/fpga0/fpga_config_sta=
te
>>
>=20
> Hi Michal,
>=20
> I have v2 working for me with Altera socfpga and had some feedback.
>=20
> Add me and Dinh as maintainers.

why not just one? What about you?

>=20
> This driver now has two interfaces for programming the image.
> I don't think things in the kernel usually have multiple interfaces.

The question here is if this is a problem. i2c create char devices
and also provide sysfs access too. It is done through notification.

> Does the fpga community in general find that the firmware class is
> suitable for all our use cases?  I think it only supports the most simp=
le
> use cases.

Let's continue with this on that second thread and we will see what happe=
n.


> My original fpga framework that you started with supported writing the
> fpga device through the devnode, i.e.
> cat fpga.bin > /dev/fpga0
> I think we should get back to that basic char driver interface like tha=
t.
> It seems like if you have a char driver, you would open and write to th=
e
> devnode instead of adding an attribute under /sys.

It is the same as above. As you know we can simple add support for char
device with the current set of functions without changing logic in the dr=
iver.

>=20
> The 'flags' implementation is a nice way to do some locking.  But it do=
esn't
> replace the status op to get fpga manager status which vanished in v2.
> So please add that back.  Its interface was that catting the 'status'
> attribute got a status description from the low level driver such as
> 'power up phase' or 'reset phase'.  Too useful to just get rid of.

No problem to add it back but it means that core will loose control
about values which can be returned back to the user. It is probably bette=
r
to create set of return values.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--89HLq3DBujDg9c96C999tFCBnIpmbsr4i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJO3lwACgkQykllyylKDCGoeQCfYlKv8fs5BDYZMARHLPhPp8gW
Ub0AoJnv9yXLm9uBdxCoZ+fDttbhBk6K
=qoyS
-----END PGP SIGNATURE-----

--89HLq3DBujDg9c96C999tFCBnIpmbsr4i--
