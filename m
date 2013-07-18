Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab3GRL4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:56:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40382 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab3GRL4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:56:21 -0400
Date: Thu, 18 Jul 2013 14:56:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: Mark Brown <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
Message-ID: <20130718115607.GK11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718104233.GG22506@sirena.org.uk>
 <51E7D569.2010709@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rpGc+ACYPE+RMC+Z"
Content-Disposition: inline
In-Reply-To: <51E7D569.2010709@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rpGc+ACYPE+RMC+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 18, 2013 at 05:15:45PM +0530, Sourav Poddar wrote:
> >>+	list_for_each_entry(t,&m->transfers, transfer_list) {
> >>+		qspi->cmd |=3D QSPI_WLEN(t->bits_per_word);
> >>+		qspi->cmd |=3D QSPI_WC_CMD_INT_EN;
> >>+
> >>+		ret =3D qspi_transfer_msg(qspi, t);
> >>+		if (ret) {
> >>+			dev_dbg(qspi->dev, "transfer message failed\n");
> >>+			return -EINVAL;
> >>+		}
> >>+
> >>+		m->actual_length +=3D t->len;
> >>+
> >>+		if (list_is_last(&t->transfer_list,&m->transfers))
> >>+			goto out;
> >>+	}
> >The use of list_is_last() here is *realy* strange - what's going on
> >there?
> >
> We are checking if there is any transfer left, if no we are signalling the
> flash device about the end of transfer.

I'll quote your diff below because I wanted to show where your 'out'
label lies:

+       list_for_each_entry(t, &m->transfers, transfer_list) {
+               qspi->cmd |=3D QSPI_WLEN(t->bits_per_word);
+               qspi->cmd |=3D QSPI_WC_CMD_INT_EN;
+
+               ret =3D qspi_transfer_msg(qspi, t);
+               if (ret) {
+                       dev_dbg(qspi->dev, "transfer message failed\n");
+                       return -EINVAL;
+               }
+
+               m->actual_length +=3D t->len;
+
+               if (list_is_last(&t->transfer_list, &m->transfers))
+                       goto out;
+       }
+
+out:
+       m->status =3D status;
+       spi_finalize_current_message(master);

see how it's place right after the closing curly brackets ? In that
case, why do you need it ? list_for_each_entry() will do exactly what it
says: iterate over each entry on the entry. When it reaches the last
one, the loop will end.

This renders your list_is_last() check useless. In fact, you could've
figured that out if you just spent the time to read
list_for_each_entry() carefully.

--=20
balbi

--rpGc+ACYPE+RMC+Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR59fXAAoJEIaOsuA1yqREAlwP/0zhNva5B7OXjxfF9oX/4Sjz
SBcU7bAvTtwFwl9ENPGvW0yA7I/ZPVqoJKnzV/ZCEgDW5M2W/F/U2lscjriuned9
bsj4J8ZpG+k+G9oeN688UtG7Y/toF0cUTwHd4K77lfAtAtw+z7IS0hgK9buaKome
oKw2C6Ahu93dXNjmb9Wh5WZdoSmEsihuIffXZ98nu6mKieREtH+UJ1FCR0fz3M2i
CXoYxsFaOvacJNyIYRGRsrllY81SBCepZh2o61MjFUrWFL23xaFN0QG0B/aH0b0x
3OXFIT3mrQgCsiEQ5Q4GbFmfCib/gVU7FDBqCuwJ1stuo6T8wqQHVs4cTMDAbiGI
YH/DcuSqnDiHULMQM2dzJt23lqiDGYFJD4DvNd3nAOd7Vqu6JIj7GIv2EPH7CYQn
a7uA2/dp4MrWpGLwA0g9O669RacUU7vZ6grp3P4bBXF71/4fDDOTsbPcrFtgrKk6
Le7aMf8FJhGNILuIC9/T6wGJ9DZwMVIqcF9vOyp1mQb2Qr8HE75PLPf7I2ELcL5s
G5nkC2U/CR0BO+8jxrOrBe1Y0fUyL7+AXN+abuRBlkqZtA4ONbGlbUs4GFKn+znR
E5CIymlJMPCjTaoahx/KmJbLdx/+OdpHpkwSBV8i/7+AMOQNdxx8DGxZ7KW27G4I
qTF6O+P1pMhD8YB8gTj7
=jftt
-----END PGP SIGNATURE-----

--rpGc+ACYPE+RMC+Z--
