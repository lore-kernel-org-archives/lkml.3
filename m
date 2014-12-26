Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaLZP14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 10:27:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLZP1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 10:27:53 -0500
Date: Fri, 26 Dec 2014 09:27:07 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Wu, Songjun" <songjun.wu@atmel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: gadget: udc: atmel: fix possible oops when
 unloading module
Message-ID: <20141226152707.GG17430@saruman>
Reply-To: <balbi@ti.com>
References: <1419240374-12179-1-git-send-email-songjun.wu@atmel.com>
 <20141223162419.GB9147@saruman>
 <549A138D.50204@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
In-Reply-To: <549A138D.50204@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 24, 2014 at 09:14:53AM +0800, Wu, Songjun wrote:
>=20
> =E5=9C=A8 12/24/2014 00:24, Felipe Balbi =E5=86=99=E9=81=93:
> >On Mon, Dec 22, 2014 at 05:26:14PM +0800, Songjun Wu wrote:
> >>When unloading the module, the urb request will be dequeued
> >>and the completion routine will be excuted.
> >>If no urb packet, the urb request will not be added to the endpoint que=
ue
> >>and the completion routine pointer in urb request is NULL.
> >>Accessing to the NULL function pointer will cause the oops issue.
> >>Add the code to check the urb request is in the endpoint queue or not.
> >>If the urb request is not in the endpoint queue, a negative error code
> >>will be returned.
> >
> >have you triggered the NULL pointer oops ? Care to add it to the commit
> >log.
>=20
> Executing the 'insmod g_hid.ko', then executing the 'rmmod g_hid.ko', the
> NULL pointer oops will be triggered.

what about all my other queries below and what about adding the oops
dump to commit log ?

> >Also, which commit is this fixing ? Does this need to be backported ?
> >When was the bug introduced ?

--=20
balbi

--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUnX5LAAoJEIaOsuA1yqREvUoP/jtQSCq6idIa5UKrE197fW/3
Qb779kzCIDDCXuG/YUFXU/kIE6p9bNs18IiZuZm88yQ1vStHqJTtZpbes3TZxMJS
rAYCL307gkLPc6AHQdN4yVj0jidEUaRrDLjJ90yuuzpVMl8qAsOFDPOuNBmL1LRI
QJ1a0iPF7sHiDHm5pfTyFBvl10JTxJtDOlMtZysov0PI1owNQOfKC/6hIEcKXDJG
l3w4U/LwmdzY3OlVtrGlWsJdeV3SL0x5GYEiBLGUQbMuOqQVgoR5B7rCY1jpoxCL
GmhmUvKliepHRXVlBF6Bu299KMvk82WQ8Jb/GgDqXYA1rq+j4b3mLbfUcByGjtR2
abSmTnENuvK3LsI0xxP/CS/IgOhnaeSrIYIHPi96rAGuc/8h074m5rtgfjzLyPbK
7clOgbTFYvIFlc3IigzXLM5X/euTOOC1MPX2iByuaCM3mXVAnNAMIUYfBU2p80Uh
9gisk6v0rR7pRq0sSGH/gD8bYupEUoyPgeJXyQfQRjlHXk9ANPAACOYwqZOztuon
BavECe/qCxhADZpLnaCKBhV3QzIKCitguhw0Yq7zqLeO6blL9SuveByg28V8bN/X
kirS+oMEFCiI9RdTBgT2UicHT18BDw9hX/swXKz/lU7/pEMkDubMUzlrVV13dCyH
3T2hSJdDUO6rDqhC2FyO
=zJor
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--
