Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaIBDFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:05:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:59819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaIBDFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:05:51 -0400
Date: Tue, 2 Sep 2014 05:05:46 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140902030546.GB6724@earth.universe>
References: <20140821184416.GF10066@atomide.com>
 <53FE3779.5090908@linutronix.de>
 <20140827202313.GF16006@atomide.com>
 <20140828082348.GA5413@linutronix.de>
 <20140828164645.GG16006@atomide.com>
 <53FF84DF.7080406@linutronix.de>
 <20140828225454.GM16006@atomide.com>
 <540048B4.7010807@linutronix.de>
 <20140829161221.GO16006@atomide.com>
 <5404B149.6010400@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <5404B149.6010400@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 01, 2014 at 07:47:53PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/29/2014 06:12 PM, Tony Lindgren wrote:
> > Looks like the paste bug is there for sure, doing off idle and pasting
> > 240 characters to the console can hang the UART RX after few attempts,
> > and pasting 16 charactes won't show up at all if the system is idling.
> > So you may want to play with that too a bit :)
>=20
> One character wakes it up. After that you can send 16, 64 and you see
> them. Right away. No delay.
>=20
> If you send "a lot" data in one-go it takes approx 152 characters until
> the first one is displayed properly at 115200,8N1. That is approx 13ms.
> Could it take that long to get up and be ready?

I noticed the same behaviour when I tested the runtime PM stuff on
my N900 with the existing serial-omap driver and I also assumed,
that the chip needs that long to get up.

> Comparing it with serial-omap I see the same thing: I takes approx the
> same amount of data until the first one is displayed. After a lot of
> "long" writes which wake the chip up from idle I manage to freeze both,
> the serial-omap driver and mine driver.
>=20
> One thing that is probably a dumb idea is that printk in
> omap_8250_mdr1_errataset().
> Would it be possible that when I hit a printk in the resume path that I
> may deadlock and box will freeze?

-- Sebastian

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUBTQJAAoJENju1/PIO/qaw4YP/355aewztKTr/5ipq84jfF60
dAuWXommZrw1dnC1IsOkXpwSiBgb9RErN6mjquWuAaz0ZQ8ZziwuTrGgnsO48lNr
81rx746iCB4AYKR/NBc0hjE5he8B7d+bcNDmAV+FN3tsaKVHcxsJzaDQC0w98lLy
+4RKLYufJ7O9wr+0EjmX1wpwhvuVgaVBIXOnbb8FvuvU5vbJqJ6qjRQ41cUke5IE
NkkzfNiLJU5R6Is4N1AIsrzTRyt5xxj+3P9z5F38MAbezEzlg5TTWsmDsrUaAi+j
gtzz0U6dDztS4yBAFr3a2bEeCnQwbOMgXHtTn6YJxa9atzDcEIz0IYPAYPhBQFQX
FUUSHvLBiNYkhgZfjkIsx12bXnSwFu/uXohP95gKoUHNDPJ9CffL9v+nND4sgmeq
3uDUviUiBfTuXNG1mg661F8DuRIITkQx/gKbkR+OblmvCSBoKT8nRGnfxx7Ik/ZS
PH5vMi3wAMXyX/UVXI9IuAY6ThyA/rvO1zQeCb+odblMQGJo8HMF1lsXL2BUuEXy
SdhTZzsVjrI5tcvNfgG+MlbnuxPO9gw7URvtFgI4QDCJbPVDcn1FQ+8P4DiNOrzU
58VBU0yeElYTp3+DGHNbA6k/RhcjNTiOPRcckBvjuqQak+5H6RU/by2fHjhEbDr3
peSg7DHVMxq5lnsTYQrD
=nVOC
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
