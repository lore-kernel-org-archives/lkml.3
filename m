Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3G2N7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:59:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34695 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3G2N7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:59:46 -0400
Date: Mon, 29 Jul 2013 16:52:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb: gadget: mv_u3d_core: fix violation of locking
 discipline in mv_u3d_ep_disable()
Message-ID: <20130729135212.GC13978@radagast>
Reply-To: <balbi@ti.com>
References: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru>
 <20130725173017.GK25415@radagast>
 <51F2950D.3070103@ispras.ru>
 <20130729125250.GB13938@radagast>
 <51F66B0E.40408@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <51F66B0E.40408@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 05:15:58PM +0400, Alexey Khoroshilov wrote:
> On 07/29/2013 04:52 PM, Felipe Balbi wrote:
> > Hi,
> >
> > On Fri, Jul 26, 2013 at 07:26:05PM +0400, Alexey Khoroshilov wrote:
> >> On 07/25/2013 09:30 PM, Felipe Balbi wrote:
> >>> On Wed, Jul 24, 2013 at 12:20:17AM +0400, Alexey Khoroshilov wrote:
> >>>> mv_u3d_nuke() expects to be calles with ep->u3d->lock held,
> >>>> because mv_u3d_done() does. But mv_u3d_ep_disable() calls it
> >>>> without lock that can lead to unpleasant consequences.
> >>>>
> >>>> Found by Linux Driver Verification project (linuxtesting.org).
> >>>>
> >>>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> >>> which commit introduced the bug ? Which kernels are affected by this =
bug ?
> >> The bug is present from the very beginning: commit 3d4eb9d of 15 June =
2012.
> >> So it is in the mainline since v3.5.
> > Alright, do you want to have the same fix in stable kernels ? Is it
> > necessary at all or do we consider it 'never worked before' and send it
> > in the next merge window ?
>=20
> It is a tricky point. From one point of view it 'never worked before',
> but as far as the bug leads to a data race with unpredictable
> consequences I would prefer to have it fixed within 3.11 timeframe.

Alright, I have already sent my pull request for v3.11-rc3, so once -rc4
is tagged (in about a week) I'll send this patch.

--=20
balbi

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9nOLAAoJEIaOsuA1yqREX5EP/2EtzGLtHA1rmsCPMOqNheAL
fIyU96f8OilZdg86vzyV9VChL0JlWtjtR+oKiL7tnzhHU0bi6WT0NX+XsiYZxjiP
IqmulGQH/p3o40ctgR8XwVBGOA/4WUFrrKVg6AUMzbs2EjkfsWsXu8zyDNlOFN/e
MwrxiDggV7I+AOKHXTm++9rMHP+GyUBHa00Ll8S2MF9XbNTzsv080jMnVZeqo69A
y3YgJCwzvrIpfBTIF3LMO+XAa5M5xthhPpsAosX/qlkp4inzGSoH4ZSI51QIWGP9
MbYApldpTuwK4SOM9mqJ6MQQsmdDuj+nJXr4yW2PrHk75JrXLQMnq+fD/PadYn4g
pA4/ZCKd8H1DXu5iDeB7G3CJ8xgnBt5f8+Lku7qGfk6Ej3q4K8PmVFAP9skztgLc
bWgnrbMpUnENkzkK3XDOr4F5Q1BcQ3SxjG36c/muE96h0C09F3geLcby1mVm13cj
4tBq5vLvUCbJxbE3uVfwbDOtZqOsmvyRE80rsh6ES2lTd4Dn0KOdjzFIXd1YUKNW
1+FkTu9L4VxBWRYhIE1A0BXevk1lRHamhX9mMR4+kJp9gO4Dhr5o/9QM6f6SAZpk
AXYigRBjPP38I/Kq2uzPp7WLMeYIh895cJLw1ZNP7Fo7+hKqAyvYqL9BJkJzsN0s
OvQgGH96fEG+0C3+fPMU
=5VB/
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
