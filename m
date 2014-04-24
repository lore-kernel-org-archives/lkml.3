Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaDXO54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:57:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60827 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821AbaDXO5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:57:52 -0400
Date: Thu, 24 Apr 2014 09:57:14 -0500
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/6] soc: ti: add Keystone Navigator QMSS driver
Message-ID: <20140424145714.GM26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
 <1398296783-1176-5-git-send-email-santosh.shilimkar@ti.com>
 <20140424013053.GC13374@saruman.home>
 <53590F33.6070508@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1rguoi8KZGYj2k4L"
Content-Disposition: inline
In-Reply-To: <53590F33.6070508@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1rguoi8KZGYj2k4L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 09:18:43AM -0400, Santosh Shilimkar wrote:
> On Wednesday 23 April 2014 09:30 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Apr 23, 2014 at 07:46:20PM -0400, Santosh Shilimkar wrote:
> >> From: Sandeep Nair <sandeep_n@ti.com>
> >>
> >> The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
> >> the main hardware sub system which forms the backbone of the Keystone
> >> Multi-core Navigator. QMSS consist of queue managers, packed-data stru=
cture
> >> processors(PDSP), linking RAM, descriptor pools and infrastructure
> >> Packet DMA.
> >>
> >> The Queue Manager is a hardware module that is responsible for acceler=
ating
> >> management of the packet queues. Packets are queued/de-queued by writi=
ng or
> >> reading descriptor address to a particular memory mapped location. The=
 PDSPs
> >> perform QMSS related functions like accumulation, QoS, or event manage=
ment.
> >> Linking RAM registers are used to link the descriptors which are store=
d in
> >> descriptor RAM. Descriptor RAM is configurable as internal or external=
 memory.
> >>
> >> The QMSS driver manages the PDSP setups, linking RAM regions,
> >> queue pool management (allocation, push, pop and notify) and descriptor
> >> pool management. The specifics on the device tree bindings for
> >> QMSS can be found in:
> >> 	Documentation/devicetree/bindings/soc/keystone-navigator-qmss.txt
> >>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Kumar Gala <galak@codeaurora.org>
> >> Cc: Olof Johansson <olof@lixom.net>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: Rob Herring <robh+dt@kernel.org>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> >> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >> ---
> >>  drivers/Kconfig                  |    2 +
> >>  drivers/soc/Kconfig              |    2 +
> >>  drivers/soc/Makefile             |    5 +
> >>  drivers/soc/ti/Kconfig           |   21 +
> >>  drivers/soc/ti/Makefile          |    4 +
> >>  drivers/soc/ti/knav_qmss.h       |  386 ++++++++
> >>  drivers/soc/ti/knav_qmss_acc.c   |  591 +++++++++++++
> >>  drivers/soc/ti/knav_qmss_queue.c | 1814 +++++++++++++++++++++++++++++=
+++++++++
> >>  include/linux/soc/ti/knav_qmss.h |   90 ++
> >>  9 files changed, 2915 insertions(+)
> >>  create mode 100644 drivers/soc/Makefile
> >>  create mode 100644 drivers/soc/ti/Kconfig
> >>  create mode 100644 drivers/soc/ti/Makefile
> >>  create mode 100644 drivers/soc/ti/knav_qmss.h
> >>  create mode 100644 drivers/soc/ti/knav_qmss_acc.c
> >>  create mode 100644 drivers/soc/ti/knav_qmss_queue.c
> >>  create mode 100644 include/linux/soc/ti/knav_qmss.h
> >>
> >> diff --git a/drivers/Kconfig b/drivers/Kconfig
> >> index 0e87a34..8993913 100644
> >> --- a/drivers/Kconfig
> >> +++ b/drivers/Kconfig
> >> @@ -148,6 +148,8 @@ source "drivers/remoteproc/Kconfig"
> >> =20
> >>  source "drivers/rpmsg/Kconfig"
> >> =20
> >> +source "drivers/soc/Kconfig"
> >=20
> > This hunk was already in patch one but in a different offset in this
> > file.
> >=20
> right.. I will drop this one... Thanks for spotting it

np, cheers

--=20
balbi

--1rguoi8KZGYj2k4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSZKAAoJEIaOsuA1yqREYp0P+wY7HCMZwhky1BvGWTpIwgqo
7jiOZp5vo+ziJsIHzj2lTrg66mn3JMljzJYotDeSbS6OL5h+savBNcXOf8IGJOrv
+X4B0ORVUDHI3MD2AUw8f2d43bPJyKJ+s61rKSUSPZuc2yH8IO2VYQJYld9Xw+Qa
tioYA4XaQZz8I3ylcK2YQ3GqwsSIgQJ2OkK7N+W/VkJQno9u9EeNjNihJmQjwUEO
E8/++gzu5gFYuZrC1IItXWmTXS/iV4gGzJPP7a531dkso8Qq4UjaaIvWLtWQp+B2
cD7WmZsZZz8F4vv6TbnS+aBmLvM0UrOtlKOO4oAelDZdyflzcxEVE7pnwFsawMaP
FsAFsJobaCNslFjwKfUzELrV/O7jNFTlSu5exVWCln2ruMX66kIJy0i2f+1pnGqI
bq0M76p/6xfH/oqgWy+aZe7CHlM5D9xchXAG42PaCcdEHJYP9f5wBVzCWNJGFkhp
gpMGpKP1NEts7i5sii8YR1EgKAk8iIXTcLI04FiSDRHERGqAtjvRKviB1tgDdRrn
CTIas1daFdGcwOuYFUzW+q9O21dGMbtG0483skldeOrfSBX8qgJwobXr6kBF642e
sb93kOEBo7K4Hq3MZwSMp0AaAuDCV3JvpoXNEzubkOOHjZrKvSKs6NMzyJ0uEtxu
/+NMo1LHYg9jR68+N3s6
=fjkP
-----END PGP SIGNATURE-----

--1rguoi8KZGYj2k4L--
