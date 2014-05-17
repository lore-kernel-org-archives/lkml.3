Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343AbaEQRsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:48:51 -0400
Received: from sauhun.de ([89.238.76.85]:41183 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbaEQRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:48:49 -0400
Date: Sat, 17 May 2014 19:48:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>, rjw@rjwysocki.net, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
Message-ID: <20140517174834.GA2858@katana>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-10-git-send-email-tianyu.lan@intel.com>
 <20140429081609.GF1684@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20140429081609.GF1684@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 11:16:09AM +0300, Mika Westerberg wrote:
> On Mon, Apr 28, 2014 at 10:27:48PM +0800, Lan Tianyu wrote:
> > This patch is to add CONFIG_I2C_ACPI. Current there is a race between
> > removing I2C ACPI operation region and ACPI AML code accessing.
> > So make i2c core built-in if CONFIG_I2C_ACPI is set.
> >=20
> > Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> > ---
> >  drivers/i2c/Kconfig  | 17 ++++++++++++++++-
> >  drivers/i2c/Makefile |  2 +-
> >  include/linux/i2c.h  |  2 +-
> >  3 files changed, 18 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> > index 7b7ea32..c670d49 100644
> > --- a/drivers/i2c/Kconfig
> > +++ b/drivers/i2c/Kconfig
> > @@ -2,7 +2,9 @@
> >  # I2C subsystem configuration
> >  #
> > =20
> > -menuconfig I2C
> > +menu "I2C support"
> > +
> > +config I2C
> >  	tristate "I2C support"
> >  	select RT_MUTEXES
> >  	---help---
> > @@ -21,6 +23,17 @@ menuconfig I2C
> >  	  This I2C support can also be built as a module.  If so, the module
> >  	  will be called i2c-core.
> > =20
> > +config I2C_ACPI
> > +	bool "I2C ACPI support"
> > +	select I2C
> > +	depends on ACPI
> > +	default y
> > +	help
> > +	  Say Y here if you want to enable I2C ACPI function. ACPI table
> > +	  provides I2C slave devices' information to enumerate these devices.
> > +	  This option also allows ACPI AML code to access I2C slave devices
> > +	  via I2C ACPI operation region to fulfill ACPI method.
>=20
> I would prefer something like:
>=20
> Say Y here if you want to enable ACPI I2C support. This includes support
> for automatic enumeration of I2C slave devices and support for ACPI I2C
> Operation Regions. Operation Regions allow firmware (BIOS) code to
> access I2C slave devices, such as smart batteries through an I2C host
> controller driver.
>=20
> But it is really up to you so,
>=20
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

How does this fit into the context of
55e71edb81b2b45273e7b284cce13ff24bde846f ("i2c: move ACPI helpers into
the core")?


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTd6DyAAoJEBQN5MwUoCm2GPYP/iRp8a/7r/IFX03BkyZU5EbK
dDtMBicmqvF6bmp9q5SZlrW6vjzK5aoLXtMgAwEYzkX10StDbEd34954sZB3VSl4
BrPIJq/sFSkyk8L2IQWtvxmbdbXsC2vIz9TkgL9opmDEjWci5ZOrfXGBjrcDgtKS
tQ71o0yDwPLcyTr2rfpgKVDaCcBjgI1+0Dzn58S/4otaBmDq5GdXK8E4/NjoBEUu
Cq2bxGB9YmPvXzh9knbmJggfktAel5jVnY8FxOjI2dryCCrfnfSDJL7BeEBFf4XI
aJIUhy3ZbkCagfkdaan4O+EQe6alUgZ3cS2aSmcvUMbsN1bnMAH3bkjXWRjc4kqW
4Zcbqz4vG2MsLWI1NX0yOSmZwTK2Sc5ez+DAIqw/hTBOo6lv6MUfmYDsMLy4PGXA
dnVT+zqdfaCN8O11Quu64Z1glgx9fflQStduPqRaeROLCnLb4Z7XOxSXPy0Q047n
o5ZUIcS6e8QZ7oBYc8p4s5syfzQxOJnfbr49a8zIcCpyDLmCiC44ZxxsJeFu3O+6
ZANvJDsIpExbipA/wa6ObRXBrIm0ur2clyaw/Jy8vaR8qzp6jR63sCV8wXS+gNPc
ep//ddC+p2jNPXCg8vRaLKE6ChIx5/f+VWZVQRJI9yWlPeqITNabeWllCXouOrXB
uHJA3zsTx4q/qOllfWpK
=SXtj
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
