Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaJHMlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:41:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:43608 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbaJHMlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:41:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,677,1406617200"; 
   d="asc'?scan'208";a="585329610"
Date: Wed, 8 Oct 2014 17:37:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation
 for the dma controller API
Message-ID: <20141008120757.GT1638@intel.com>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com>
 <1411746035-15882-2-git-send-email-maxime.ripard@free-electrons.com>
 <7725507.nuHj4C7OxF@avalon>
 <5433D9AF.8020508@atmel.com>
 <20141007145226.GA17925@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cW+P/jduATWpL925"
Content-Disposition: inline
In-Reply-To: <20141007145226.GA17925@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cW+P/jduATWpL925
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 04:52:26PM +0200, Maxime Ripard wrote:
> > >> +Moreover, some DMA controllers, whenever the RAM is involved, can
> > >=20
> > > s/the RAM is involved/RAM is used as a source or destination/ ?
> > >=20
> > >> +group the reads or writes in memory into a buffer, so instead of
> > >> +having a lot of small memory accesses, which is not really efficien=
t,
> > >> +you'll get several bigger transfers. This is done using a parameter
> > >> +called the burst size, that defines how many single reads/writes it=
's
> > >> +allowed to do in a single clock cycle.
> >=20
> > Yes, here "single" word is used for different concepts and can have
> > several meanings. We usually make the difference between "single"
> > accesses and "burst" accesses.
>=20
> Which was kind of what I was explaining, but it was probably not clear
> enough.
The burst can be in multiple clock cycles as well, so any reference to
clocks may not be right across various dma controllers.

Generically burst size is defined as a chunk of data transfer dma
controller would perform in single shot (may happen in 1 or multiple clock
cycles). The dma controller won't break this.

This has a very special meaning wrt slave usages as it involves FIFO (not
much of importance in memory copy ops where you want max burst for
performance). DMA transfer should not push data more than FIFO capacity,
ditto for pull as well.

Consider FIFO of 16 data items (beware not bytes), and burst being 8 and
watermark 8. So we will transfer 8 then 8 and so on.. ensures FIFO is
typically full or half.

> > >> +         + DMA_TERMINATE_ALL
> > >> +           + Aborts all the pending and ongoing transfers on the
> > >> +             channel
> > >> +           + This command should operate synchronously on the chann=
el,
> > >> +             terminating right away all the channels
> >=20
> > Is it a strong requirement to "terminate right away" all the transfers
> > on the channel? Must the ongoing transfer be stopped of can it ends its
> > current chunk?
>=20
> Since it's blocking, I guess it's fine to wait for the current chunk
> to end as long as you block. But I'm not 100% sure on that. Russell? Vino=
d?
Typically terminate_all would be called in error or timeout scenario. So
current transfer may not complete, so aborting right away would be the right
approach


--=20
~Vinod

--cW+P/jduATWpL925
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUNSkdAAoJEHwUBw8lI4NHsHIP/0gbHJDsIFWy6rnnwCCbMLSf
45NGuufD0gVXild03f6psY9J5wGO00vRWsmqEE7ICgHxfsdbdojM8qzyQoltu8aI
K6YuTMh77D+S18F1m5XW1Ay45uZ3WZFFpma/1WzKJK5KRbNTZYCecUlEbW0FjqeT
amurJRnAY4nWttGZML7XCFQ5FMKY3em4T8RAZsDQQlRXqqEkE7ummVBIabzyp/0+
Yx0RMW9VpuYJ5WhgYulBxlINS4Bki94lDvuQasfBFHOwoJC8GVUd0qBIDRE2Zy1t
NsUF7+8CYMqGQ3CY/st6yVhmE3ok/aaOrG/uU4Hd/Vnr1/fhaTeElcVhm+r/bHLK
fKyeTW/yOYs+vd2aybuqat37ETBVMjd4ArTh2ZmmxB/UsRVTxizbkps3nbNUAJID
8KBIG0r1rbHzggfv2VCGF3OiPpmeIiHe8eCnhwRayF/IwI0SJQW/qw3duMbLVqLy
ZAbZ5FW7Fz1CBKUmn1CfWG/HnpHN8TT43mIOLSsi6Qw+iA4zcKdaUZ1hPdTSj3Wp
ji5Kq6Se4rmNtChAw97an+ANIqKWlIXieLgY47wK2mykKqcg1kTDgpB1qAytQ/on
oSpqZG1t75StfCZ/DaK4wKem6ibJ9xJJiNqJ3D7FJEPpBTBPTl8gHpncDUMOiuts
bGBd+sxGEy2Pgu0yW9ij
=piAP
-----END PGP SIGNATURE-----

--cW+P/jduATWpL925--
