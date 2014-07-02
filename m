Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaGBQql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:46:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48607 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaGBQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:46:39 -0400
Date: Wed, 2 Jul 2014 11:46:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140702164629.GI5541@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140421160802.GA22794@saruman.home>
 <Pine.LNX.4.44L0.1404211228190.1201-100000@iolanthe.rowland.org>
 <CALHRZur7+MaYXbWOfbvjggPN7_eYAE+th5VNbcLP=ehvm0HGsA@mail.gmail.com>
 <20140422144944.GF5524@saruman.home>
 <CALHRZuoq32qoh70hbb2LtVJNgkwB1j6bvzmYONmxcn3mBnGONQ@mail.gmail.com>
 <20140430165437.GO23679@saruman.home>
 <CALHRZur13jLsszV8m_2q1nnBcd00P+2jO60Bvn48aKeu0f7yNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
Content-Disposition: inline
In-Reply-To: <CALHRZur13jLsszV8m_2q1nnBcd00P+2jO60Bvn48aKeu0f7yNQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, May 25, 2014 at 11:10:30PM +0530, sundeep subbaraya wrote:
> Hi Felipe,
>=20
> Please take a look at below about how this IP works:
>=20
> IN:
>       req.buf ---> DMA (transfers from ddr to IP buffer, raise DMA
> done interrupt and set Buffer ready to transfer data to Host)---->Host
> PC
>   buffer sent interrupt
>=20
> OUT:
>      Host PC--->buffer ready interrupt--->DMA (transfer from IP buffer
> to DDR,DMA done interrupt, set Buffer ready to receive next data from
> Host)-->req.buf
>=20
> I written logic to call completion in DMA done handler because it
> works for both IN and OUT eps. But I see significant performance
> degradation (by copying a file to mass storage gadget). DMA can handle
> unaligned address too but it has ep max limit (say 512 for bulk).
> Hence it is SW job to split packets and to drive DMA till req.length
> completes. I feel polling for a while is faster than switching between
> interrupt handler back and forth rapidly. Moreover, DMA may or may not
> be present in IP based on user configuration at design time.
>=20
> I fixed all other comments expect this one if you do not agree for
> polling then I may have to create threads and do this stuff. What do
> you suggest?

Can you resend your driver so we can review again everything you have
fixed ? I guess you have no other way... polling it is.

cheers

--=20
balbi

--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtDdlAAoJEIaOsuA1yqRE2LIQAJ7ABd5wTSeoPEq+D8BmAYRV
NKBjosUQ5X4shof7jh5sP2UwH0wHdzXMmIX+qBPxiwUhDLdhUM0yAlHsP3QDXDd0
XScmrb1xrYE8txH92TxaMYmqSVSiMctPj+6YCOjB1afBRrGfDSAeLpkdeImuz7K3
2oS3pdlA07I6DnZ/an4ckl1z8dLFYgO4pwoSge4RadEoryp945mZ3/wKctw7SU8c
7mn6l9MIjsUeYcIzbYwyEvdgUwA/eX/VohTQb+jXIA2aX450bim5xrtNu6L+7xQU
+3v9LV0ukEOqzeANu81Z6695eU/My/2XwuiObRcXXV47hJuPOjCFVgZhiJD8/FPx
QUqrV3c8DdBxu6ZDB7gTF2ZjTYHmDZ5ra/hUwCkfD9jdiwbTQtRNCCydl77TwJuD
ZihK3shkgjRFtoEIYygiD8Q+x6NqWlLD3MFruHIVTK8XAPWw3H8xshKnXKX8bze4
Ia0smp4JOf/fMdYNW3SnBHD3tNqsvg1863IDwCv+56J7Dovf7ypbV50VTzsmk/Yl
v+ROvGCzquPO3p8A61P7ZF5VKd2Ep8Hle/L/39udH6DCXhtzd9b4uf9PtEfg2skO
1/cXQM83GpoHR2nzMwEV/MtoW/Y91oCP3pIu2Vy+MBQqY4Pg02Jcg2q2qeNTYy4X
df2H/7kwg1MWpwipgFMf
=Ujk6
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--
