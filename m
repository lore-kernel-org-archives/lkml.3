Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3G2Mxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:53:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38893 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab3G2MxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:53:10 -0400
Date: Mon, 29 Jul 2013 15:52:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb: gadget: mv_u3d_core: fix violation of locking
 discipline in mv_u3d_ep_disable()
Message-ID: <20130729125250.GB13938@radagast>
Reply-To: <balbi@ti.com>
References: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru>
 <20130725173017.GK25415@radagast>
 <51F2950D.3070103@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <51F2950D.3070103@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 26, 2013 at 07:26:05PM +0400, Alexey Khoroshilov wrote:
> On 07/25/2013 09:30 PM, Felipe Balbi wrote:
> > On Wed, Jul 24, 2013 at 12:20:17AM +0400, Alexey Khoroshilov wrote:
> >> mv_u3d_nuke() expects to be calles with ep->u3d->lock held,
> >> because mv_u3d_done() does. But mv_u3d_ep_disable() calls it
> >> without lock that can lead to unpleasant consequences.
> >>
> >> Found by Linux Driver Verification project (linuxtesting.org).
> >>
> >> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > which commit introduced the bug ? Which kernels are affected by this bu=
g ?
> The bug is present from the very beginning: commit 3d4eb9d of 15 June 201=
2.
> So it is in the mainline since v3.5.

Alright, do you want to have the same fix in stable kernels ? Is it
necessary at all or do we consider it 'never worked before' and send it
in the next merge window ?

--=20
balbi

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9mWiAAoJEIaOsuA1yqRE3JIP/1oWATdC37ZmgZcReJGeQAlH
lWTmhj5nS2W6BB3ZmsW4gwtSknCIlYuAbAQj2eHdB3j6t2ubw38RQrfAKTl3s3G0
RDFBoR7Jb6zp4Rpd+AalciMba27DDhvZR/N7siHtkjGBRBa0LJXshDg+fgdFD7TA
rpmaexU8SvJRY9zYy83QuvTvrxW3XET2lmSR8EcGgigFMkc0HTh64b0Zem8lSXAK
1ugD7O9IikRRPLZRGYsSqhkeOEANCBrZRml2pvQc34n70he94Dq1ToLlYo9TFNyo
W1iV1F654Xqmn3UCVmy7P1C2ZdmJFgLBtXXKXnrvjckA+w7UKS+loVBPU4r0+BYm
H64a0aGt4mHTO6Wf7Jgki4PVJwKf72zat4jdirvjUl8+2nW0jIJizi78/zrHvJ/x
bcyj3IhhXHSj7RTrEv4TtsIsaIq9puCUEwf5ACqOV7U9781jy056z3W9V433xGa4
crXRi4MCGRY1Qwk2cdIiYO8MDDuYOPnQYuQIQ7OsfYFr/p4PWIFV5KURnI/eiZ6l
aHwHUUt81rh90N4hylQx06fYB5Bt9ZSzrG+pIaYlDtrhP7P62SJvLJr/E3xXoWoY
v+s66TO6w6eq+awLTrEd6i4ZiKHkR33VkMzVQFJ4pEZE3F8OmXXsXPWmkAvPk361
BKnH4+OE6Z9DQU6gkYFf
=EOx2
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
