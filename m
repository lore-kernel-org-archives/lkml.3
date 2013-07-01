Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3GAMRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:17:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47477 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3GAMRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:17:08 -0400
Date: Mon, 1 Jul 2013 15:16:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: sleeping while atomic in dwc3_gadget_start
Message-ID: <20130701121659.GE28300@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130626215256.GC11625@codeaurora.org>
 <20130627065837.GL15455@arwen.pp.htv.fi>
 <51CC6F10.3000202@codeaurora.org>
 <20130628105805.GN11297@arwen.pp.htv.fi>
 <51CE4038.5000905@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rgf3q3z9SdmXC6oT"
Content-Disposition: inline
In-Reply-To: <51CE4038.5000905@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 07:02:32PM -0700, Stephen Boyd wrote:
> On 06/28/13 03:58, Felipe Balbi wrote:
> > Hi,
> >
> > On Thu, Jun 27, 2013 at 09:57:52AM -0700, Stephen Boyd wrote:
> >> On 06/26/13 23:58, Felipe Balbi wrote:
> >>> On Wed, Jun 26, 2013 at 02:52:56PM -0700, Stephen Boyd wrote:
> >>>> Hi,
> >>>>
> >>>> I'm getting the folllowing BUG message on bootup with 3.10-rc5
> >>>>
> >>>> BUG: sleeping function called from invalid context at mm/slub.c:926
> >>>> in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper/0
> >>>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-gee3e35b-09316-=
ge78f3b35 #643
> >>>> [<c0014220>] (unwind_backtrace+0x0/0x120) from [<c001212c>] (show_st=
ack+0x10/0x14)
> >>>> [<c001212c>] (show_stack+0x10/0x14) from [<c0143750>] (kmem_cache_al=
loc_trace+0x3c/0x210)
> >>>> [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210) from [<c00e0c60>] (=
request_threaded_irq+0x88/0x11c)
> >>>> [<c00e0c60>] (request_threaded_irq+0x88/0x11c) from [<c03bf53c>] (dw=
c3_gadget_start+0x198/0x200)
> >>>> [<c03bf53c>] (dwc3_gadget_start+0x198/0x200) from [<c03f7a5c>] (udc_=
bind_to_driver+0x70/0xd8)
> >>>> [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8) from [<c03f7b50>] (usb_g=
adget_probe_driver+0x8c/0xb8)
> >>>>
> >>>> and I suspect this problem was introduced in commit 8698e2acf
> >>>> (usb: dwc3: gadget: introduce and use enable/disable irq
> >>>> methods). Is there a fix for this problem? Can we just move the
> >>>> irq request outside the spinlock?
> >>> nice :-)
> >>>
> >>> how about this ?
> >> If start fails do you call stop? I believe the answer is no, so we'll
> >> need to free_irq() somewhere along the error path. Or we can request it
> >> after the spin_unlock()?
> > good point here's v2:
>=20
> Ok looks good to me. I hope that platform_get_irq() doesn't fail,
> otherwise we're in for a nasty surprise. Maybe we should add a check in
> request_irq() for that case.

I don't think we would ever fall into that situation. And if we do, our
data (struct resource or DT) is f-ed up anyway :-)

--=20
balbi

--Rgf3q3z9SdmXC6oT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0XM7AAoJEIaOsuA1yqREm7wP/3wS3j6lJ95+hx6evVFEPy/6
zfok4pX2d0u8fB6Rnw69XDY7A9WWmjHN0fjF5CqCIgue+rq4bu+9kw4mfzWPDMOy
qednn4kpldzaVB5QK4Gc7tjdfjxUQgtZBeSdaSLvFMZCOWXethjGlwfiIJpCK+R+
9FwsvaBGymHuYCEnfh1hjdctRHJa9SS1L48v8lNJTCw+9gd2na8jvReKZEJ/4mYT
xxP71n72CjaNSDFZo6cJPNAEC1D2RIzJwfSJeKFDsx/O02Z7xRQtwB3Sone9mjtD
f3PGMEvbrcYiVGtL5fbAGZQXoR/f1fXcUy0s5skdNTObetxekRNoLcnz12tE+vE1
uL8FET2bDUgQAKjzVJpjRiCgPwaU8XI37uTCZqXqw1qxTdrkUCEgOvgXe8qoiDpE
Oc723GVoj8Him48mhpsQ8MBtyVDJF3cZ1mKWQ5GwdWkXUSsnlaIARKyqovL5OzEN
49A3rMQyfkm9DYZEZUZnHJdZpMt7K/syybltOGV4WFZ9R9WFXVsffPoj/RS4yZ1w
kbkZItEBxNYljrCWYDZNIg5HgB/76kSNoFB5i7xtViLXt86j4G5rJazrytpwcr/O
CgE0GZlZHRVaDEnzUAoNReZEpjqCBKgj4DBMfvddrtJpysjBUPo6o5vxTtlqlMz6
29J0KAQt3sR32xC/rX8T
=cjRU
-----END PGP SIGNATURE-----

--Rgf3q3z9SdmXC6oT--
