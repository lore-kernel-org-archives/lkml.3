Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3ISLxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:53:54 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53647 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3ISLxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:53:52 -0400
Message-ID: <523AE5CC.4000909@monstr.eu>
Date: Thu, 19 Sep 2013 13:53:48 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dinh Nguyen <dinguyen@altera.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>,
        delicious.quinoa@gmail.com, rocket.yvanderv@gmail.com
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com>  <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <1379530957.23877.11.camel@linux-builds1>
In-Reply-To: <1379530957.23877.11.camel@linux-builds1>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iS08oBqlOLJNeRTdjdxaPgcQIObBt1fUD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iS08oBqlOLJNeRTdjdxaPgcQIObBt1fUD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/18/2013 09:02 PM, Dinh Nguyen wrote:
> Hi Michal,
>=20
> On Wed, 2013-09-18 at 17:56 +0200, Michal Simek wrote:
>> This new subsystem should unify all fpga drivers which
>> do the same things. Load configuration data to fpga
>> or another programmable logic through common interface.
>> It doesn't matter if it is MMIO device, gpio bitbanging,
>> etc. connection. The point is to have the same
>> inteface for these drivers.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>=20
> [CC] Alan Tull <delicious.quinoa@gmail.com>
> [CC] Yves Vandervennet <rocket.yvanderv@gmail.com>
>=20
> Thanks for doing this. Myself and Alan Tull had plans to send this
> upstream, but we wanted to make sure that this framework would also wor=
k
> on the Xilinx platform as well. Have you had a chance to test this on a=

> SOCFGPA platform? If not, we can go do that.

Sorry. No. I don't have any socfpga platform to be able to test it.
I believe Alan will test it.

>>
>> ---
>>  MAINTAINERS             |   7 +
>>  drivers/Kconfig         |   2 +
>>  drivers/Makefile        |   1 +
>>  drivers/fpga/Kconfig    |  18 ++
>>  drivers/fpga/Makefile   |   5 +
>>  drivers/fpga/fpga-mgr.c | 433 +++++++++++++++++++++++++++++++++++++++=
+++++++++
>>  include/linux/fpga.h    | 105 ++++++++++++
>>  7 files changed, 571 insertions(+)
>>  create mode 100644 drivers/fpga/Kconfig
>>  create mode 100644 drivers/fpga/Makefile
>>  create mode 100644 drivers/fpga/fpga-mgr.c
>>  create mode 100644 include/linux/fpga.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e61c2e8..5c7597b 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3427,6 +3427,13 @@ F:	include/linux/fmc*.h
>>  F:	include/linux/ipmi-fru.h
>>  K:	fmc_d.*register
>>
>> +FPGA SUBSYSTEM
>> +M:	Michal Simek <michal.simek@xilinx.com>
>=20
> Since the basic framework of this driver was done by Alan Tull and
> myself, can you please add Alan and myself as the maintainer here?

If we end up with any reasonable solution which will suitable
for all of us I have no problem to add you here because every change
in this subsystem should be validated by all parties.
You should be definitely in a CC for all these emails which will
be ensured by adding your names here.

But still there will be just one repo which will store patches
for this subsystem.

>> +T:	git git://git.xilinx.com/linux-xlnx.git
>> +S:	Supported
>> +F:	drivers/fpga/
>> +F:	include/linux/fpga.h
>> +
>>  FPU EMULATOR
>>  M:	Bill Metzenthen <billm@melbpc.org.au>
>>  W:	http://floatingpoint.sourceforge.net/emulator/index.html
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index aa43b91..17f3caa 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -166,4 +166,6 @@ source "drivers/reset/Kconfig"
>>
>>  source "drivers/fmc/Kconfig"
>>
>> +source "drivers/fpga/Kconfig"
>> +
>>  endmenu
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index ab93de8..2b5e73b 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -152,3 +152,4 @@ obj-$(CONFIG_VME_BUS)		+=3D vme/
>>  obj-$(CONFIG_IPACK_BUS)		+=3D ipack/
>>  obj-$(CONFIG_NTB)		+=3D ntb/
>>  obj-$(CONFIG_FMC)		+=3D fmc/
>> +obj-$(CONFIG_FPGA)		+=3D fpga/
>> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
>> new file mode 100644
>> index 0000000..5357645
>> --- /dev/null
>> +++ b/drivers/fpga/Kconfig
>> @@ -0,0 +1,18 @@
>> +#
>> +# FPGA framework configuration
>> +#
>> +
>> +menu "FPGA devices"
>> +
>> +config FPGA
>> +	tristate "FPGA Framework"
>> +	help
>> +	  Say Y here if you want support for configuring FPGAs from the
>> +	  kernel.  The FPGA framework adds a FPGA manager class and FPGA
>> +	  manager drivers.
>> +
>> +if FPGA
>=20
> Not sure what this is for?

It is just for adding fpga end driver here. I have here
zynq devcfg driver.
It is just preparation for others end driver.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--iS08oBqlOLJNeRTdjdxaPgcQIObBt1fUD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI65c0ACgkQykllyylKDCEIpACgm8RGCL/m14JM56RAgl6zdshc
9NMAnR6pyDMru7diouitVwsgcTP8d2M5
=80Ve
-----END PGP SIGNATURE-----

--iS08oBqlOLJNeRTdjdxaPgcQIObBt1fUD--
