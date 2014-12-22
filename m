Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaLVQLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:11:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44079 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbaLVQLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:11:43 -0500
Date: Mon, 22 Dec 2014 10:11:23 -0600
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: query on DWC3
Message-ID: <20141222161123.GE12815@saruman>
Reply-To: <balbi@ti.com>
References: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
 <CALHRZupFbTxTn9KiUCmvcmgYxUUcNfvAoMqOq=Drq0gZ+H246w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <CALHRZupFbTxTn9KiUCmvcmgYxUUcNfvAoMqOq=Drq0gZ+H246w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(please don't top-post)

On Sun, Dec 14, 2014 at 08:39:18AM +0530, sundeep subbaraya wrote:
> Hi Paul,
>=20
> As per my understanding, for BULK OUT we do queue a request with 512
> bytes length since we do not

sometimes we _do_ know the size. In case of Mass Storage, we _know_ that
the first bulk out transfer will be 31-bytes (CBW), if we were to start
a 31-byte transfer, we would't receive anything.

> know the length of the transfer Host is going to send. For Control OUT
> we know the length in wLength of
> Setup packet, hence I assumed there is no difference in programming
> model of Control IN and OUT.

there is _no_ difference. It's just that it was agreed that for anything
other than control ep, the function drivers would take care of it. See
the uses of quirk_ep_out_aligned_size.

--=20
balbi

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmEKrAAoJEIaOsuA1yqREs+gP+wY/VOF0P0Emd7svSs4Ue8cu
OblDxhvzBGC3YzbiPTUQE5UlM+a2a5N6bJ47GqmO3GflogtwCMTsBYAAPKo1QJZi
ui4BiFit2hdvKJHj2cPEmEbkwGKHvXxljiHGttHVTmbf45TcRuACQCMvJdkxuVOX
Z+xn7C6Kg/C3xxMJ1FTH+FxtmP6fFLlnRTQaXJEkrB0zi+wO3eMCGClQiLL1yGEp
idb4cI6VJs9jgui7cz27F9Y+p1N2i4D/3IUUaM2uXcUmeH06Ncef5YprNzDUI6Pk
uxtGaDHDT2arLv0cExjGWtckUEVdN2IDTBMnMCMEFKHb57NHcdWFucpI39UPAwBW
UcKA1Ayr1hjy8PLogXIegdVsNV+OlI/YgcZfS2hTV9g5s8DGgsV5J4ieOlbLTOmk
p7STu0Uv1kKteuaNgxcVSReSXoLFKyGawe2GoF7H3Lj/vaGImkzVXteBGiOEnzEh
seAJNGZk8tHIK/sUDyLautMi84r1Pz4nTo3ZxJyLsbeBkeZn6wPNp0sYJSWDRik9
dY71IJeqIp/CvW7yDw43n5/0lAbkzYaXrKZJcDnyyw3lBY5MmXUOsyet+jB1uyC/
V7F/37vDhsf4xm3JBG73ASrsLL4iC0hljgAp+hAv8ia44/D+VohERnqzzkmIg8/W
jYV8DNz6NIwbKL9U/8IS
=hzYJ
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
