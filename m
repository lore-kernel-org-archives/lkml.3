Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3LNMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:16:27 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52436 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LNMQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:16:26 -0500
Date: Sat, 14 Dec 2013 13:16:21 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131214121620.GA17467@mithrandir>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131213020413.GD13333@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20131213020413.GD13333@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 06:04:13PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> > This is a simple test module that can be used to allocate, export and
> > delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> > systems that lack a real second driver.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/base/Kconfig        |   4 +
> >  drivers/base/Makefile       |   1 +
> >  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++++=
++++++++
> >  3 files changed, 313 insertions(+)
> >  create mode 100644 drivers/base/dma-buf-test.c
> >=20
> > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > index e373671652b0..bed2abb9491b 100644
> > --- a/drivers/base/Kconfig
> > +++ b/drivers/base/Kconfig
> > @@ -200,6 +200,10 @@ config DMA_SHARED_BUFFER
> >  	  APIs extension; the file's descriptor can then be passed on to other
> >  	  driver.
> > =20
> > +config DMA_BUF_TEST
> > +	tristate "DMA-BUF test module"
> > +	depends on DMA_SHARED_BUFFER
>=20
> We need some good documentation here.

I agree. The description should go into more details about what exactly
this is meant to address.

> > > +static struct miscdevice dmabuf_device =3D {
> > +	.minor =3D 128,
>=20
> Why did you pick this minor?  Why not just make it dynamic?

It seemed like minors are statically allocated for miscdevice and 128
seemed to be as good as any. The tentative plan was to go through the
official way of having one allocated as explained in the comment in
include/linux/miscdevice.h.

Reading that comment again, there's MISC_DYNAMIC_MINOR, which I guess
would be appropriate here. Chances are that if you want to test DMA-BUF
you'll have a reasonably modern userspace that will create the device
dynamically.

Alternatively I guess I could instead turn this into a more full-fledged
cdev and do the whole alloc_chrdev_region() dance. Although that will
only allocate the major dynamically.

I'm not aware of any function that just allocates a single major/minor
pair completely dynamically. Is there one that you could point me to?

Thierry

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrEwUAAoJEN0jrNd/PrOhHtgQAJYDLxZlUaSdYI6dNNTYxi0J
DDXpO8RKUIqhS4ojZfgGcIpvb0/YSLJ7gF/HBIQISrvoXk3pJL4UG/C6x2ad7p3T
t3X+6LI/JbyLhhwfC55Y/tGy8zGe+s0VpDsZg3Yrs3tjodNpoz55EfPqYSsaxU2e
hDUb8eBU7CaJ1eNGYHmxLwPhT4Nu9O821yCPMKVatGgygW5Z/kjoDx/LROSiwe43
upUeBP6ioGKM9FQXXiqoAsuk6FQ3XH/DIMvvewLBCY13eeCuIhhEW84zBsWT9dpu
d08Z1LeQvsNA0pxD5qqupWvA1ivOYEyRtKlkJyZ97/QTPh9rHygFmq/FD0IoZOc/
A8kuprDdEd2woQ/driAhXp/AXuyZcgCTrkrScXLM6yJ3amXhlTPXIl1n52SK0MIN
EubaJHUjhIDwtblzwvfQP37d8vnSIaaEUFKhIBUd9Yb9dWSitQIKzB71bxp9cCgf
lgRFWaRrTYIA7ZP5runuldX6IrKBiPdX8/boBQHDE8ze5OZpBSOVr2z9Cfg3Sygx
o6Q5iy3H1DwTyabYNMFs8DlX6/aUGb/13/rJJJUf1+wGEhTJPw8x70ZEU5qWN4UL
W3Iqf+TYPF2WoftJDiB/TW93bAO1F1tIVw5OZbSw4/nJvkI4mYVNp3OR6U9FpiNt
4ug2bx5/47DQIDUdJAg1
=4Eas
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
