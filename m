Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaC0CLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:11:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57133 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaC0CLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:11:09 -0400
Date: Wed, 26 Mar 2014 21:09:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, <linux-serial@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] bluetooth: hci_ldisc: fix deadlock condition
Message-ID: <20140327020909.GA11651@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-9-git-send-email-balbi@ti.com>
 <53337513.1010708@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <53337513.1010708@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 08:47:15PM -0400, Peter Hurley wrote:
> [ +to Marcel Holtmann ]
>=20
> On 03/20/2014 03:30 PM, Felipe Balbi wrote:
> >LDISCs shouldn't call tty->ops->write() from within
> >->write_wakeup().
> >
> >->write_wakeup() is called with port lock taken and
> >IRQs disabled, tty->ops->write() will try to acquire
> >the same port lock and we will deadlock.
> >
> >Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> >Reported-by: Huang Shijie <b32955@freescale.com>
> >Signed-off-by: Felipe Balbi <balbi@ti.com>
>=20
> I just noticed this patch wasn't addressed to Marcel;
> seems like this should go through the bluetooth tree (but not
> through bluetooth-next because it fixes an oops).

read the archives:

http://marc.info/?l=3Dlinux-bluetooth&m=3D139534449409583&w=3D2

> Marcel,
>=20
> You may want to build on top of this patch split handling;
> I noticed some of the protocol drivers are calling
> hci_uart_tx_wakeup() from work functions already (so don't
> need to schedule another work...)

I don't think that should be part of $subject, though.

--=20
balbi

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTM4hFAAoJEIaOsuA1yqREwyIP/3XEL4u03XTpxbTA6+F/gBxx
6H2b5EFxQqsgJGUm1mDwMQP8R+pR18nxgdEVq4xvyStHO3rWtJmNVDXKHFrn1akF
lDI0iboVake1GqOEZnNUygYQ37zawnZLoEMQp4SzMpz2P6e8Gx0D9cw7zw6MJrdW
NQQe/n1Z/+CItv6wKz/CkkNggPzT9jg8sWUAEdRbDB9uNYidS7zexP6WKUh1EWgr
dV6vYaaG6hrioayIj+znPR8E6D3CJDiKUxYjUYyltEEpG7aKoqE9jZYakvwnq8jv
qeAadfw2IE45bVWQL6CPYGZKRg4PJJQtclT9pGuA9U1MY82BM4Jq37Didttn+K11
3zOuICgZFka1IOFuHmg4FnBfptf8zdOloqVnznDOGcxdz7Rx+Rxk8j0pF9ySt1JY
WvluP6EhJayhtHn0hz2GKvm8uVDhX7jyB8dlugqRuSM6vum+K/09tntUvyBhuq8g
jWp5C9+hrKaPdHNghEPmLAJB6NePbzGG0286mh2J6GlJlzI3k5a1mZ4X1V/+6mN8
hvnZEg8K9zfacNoiCorHQcatZPtmCWI1FJFPMriasb9wAlHbQvAKy1hbAeMzum8P
U5upoj2gsYnp1qTz0N8Bxg/yUpnrfXjUHvCZefL4iIN7K2Vj1F3UOe/C+lemszVz
GTE4mIkmBDfQ1z/3UZDQ
=9+YE
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
