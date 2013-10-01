Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3JAOpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:45:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39093 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3JAOpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:45:38 -0400
Date: Tue, 1 Oct 2013 09:45:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] USB: gadget: s3c-hsotg: add isochronous transfers
 support
Message-ID: <20131001144527.GX1476@radagast>
Reply-To: <balbi@ti.com>
References: <1380016036-20983-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBYWXwvsCkEY5LOm"
Content-Disposition: inline
In-Reply-To: <1380016036-20983-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SBYWXwvsCkEY5LOm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 24, 2013 at 11:47:16AM +0200, Robert Baldyga wrote:
> Hello,
>=20
> This is update for my proposal for isochronous transfers support in s3c-h=
sotg
> driver. I've fixed issuses pointed by Bartlomiej Zolnierkiewicz. For more
> information, please check the change log at the end of the mail.

this shouldn't be part of commit log.

> This patch adds isochronous transfer support. It adds few modifications:
> - Modify s3c_hsotg_write_fifo() function. It actually calculates transfer
>   size, taking into account Multi Count value, which indicates number of
>   transactions per microframe.
> - Fix s3c_hsotg_start_req() function by setting number of packets to Multi
>   Count field in DIEPTSIZ register for isochronous endpoints.
> - Fix s3c_hsotg_set_ep_maxpacket() function. Field wMaxPacketSize of endp=
oint
>   descriptor is now splitted into maximum packet size value and number of
>   additional transaction per microframe.
> - Modify s3c_hsotg_epint() function. Some interrupts are ignored for
>   isochronous endpoints, (e.g. INTknTXFEmpMsk) becouse isochronous reques=
t is
>   always transfered in single transaction, which ends with XferCompl inte=
rrupt.
>   Add Odd/Even microframe toggle to allow data transfering in each microf=
rame.
> - Fix s3c_hsotg_ep_enable() function by supporting isochronous endpoint t=
ype.

you're doing way too many things in a single patch.

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>=20
> Changelog:
>=20
> v2:
> - moved bugfix affecting to the other features to separated patch
> - changed conditions order in request length checking in s3c_hsotg_start_=
req
>   function, as Bartlomiej Zolnierkiewicz suggested
> - fixed typos
>=20
> v1: https://lkml.org/lkml/2013/9/23/72
> - initial proposal

changelog sould be after tearline (---) below.

--=20
balbi

--SBYWXwvsCkEY5LOm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSuAHAAoJEIaOsuA1yqRER14P/A+B7jOMq7L5KPfyPQ8HzNyt
jcLzTs2zMnAQUoT920jhOE8sd5rTd7tH0JWg8E2+VnaOrL/erLPiTs/Ocwh5z1cr
dyDwEvXWlRG5wDvoQtxsn5SpQFE+3r+Nh+HZ3TZ3zlVds/mzTJmkXZ4xy6FlvVqR
ZeWpSVsRxQ+8Khuqjch5Yls9JSoV9rbpDCgGM+pCj2VvqxALgCA129IAHXtA2zPO
Zc1D+2fHcNr7KiEe8+N96ffajynzdjuw/g8diVl9i48qOPOiNsjLTuR2SfSjYkBR
Tc4d1RJsZRD66exBWqL/mG9ddTUOHZQfIDJo33tDDHDhJr3h8W5qtL8OVgamm3qF
GWp1U5CXcpLj5n3NYAigQZNod4yOUxEhpruSW7UoTa2EYngVnCMBN0luKUx6/ob1
TVSnhY+HR6U73GYoUF+PYQbxcewrzV2by3iWsgfuVPzjfa9wbiIVZhDkXT/s7eV6
lzuom20arQ1TxylxjTJ45uSf2g1deZc5HkJJEZyoW6Mlxg/Fia+mkDpgmuObEk6H
cU/D4tiOM7tPZ2CvQ/vyEw+lO8h9FcJxhGlQqmPyNfELlh6ZQWFkU78Sr4XKD+kv
TrALmIQJj2t3aQWI1+RNjuaQbfGlb2kKm/4KHJXjXeAQ/c+nsxEPVIy3VmF5yf3O
qOFGJXCA6Z7XITJ4cJt8
=XgkU
-----END PGP SIGNATURE-----

--SBYWXwvsCkEY5LOm--
