Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3LJEmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:42:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52196 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3LJEmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:42:47 -0500
Date: Mon, 9 Dec 2013 22:41:57 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Michal Nazarewicz <mina86@mina86.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
Message-ID: <20131210044117.GA28252@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
 <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com>
 <xa1t7gbdfn8c.fsf@mina86.com>
 <52A68BF7.2080901@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <52A68BF7.2080901@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 07:35:19PM -0800, David Cohen wrote:
> On 12/09/2013 06:34 PM, Michal Nazarewicz wrote:
> > dOn Tue, Dec 10 2013, David Cohen wrote:
> >> Due to USB controllers may have different restrictions, usb gadget lay=
er
> >> needs to provide a generic way to inform gadget functions to complain
> >> with non-standard requirements.
> >>
> >> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> >> to inform when controller's epout requires buffer size to be aligned to
> >> MaxPacketSize. A helper is also provided to align buffer size when
> >> necessary.
> >>
> >> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> >> Cc: Alan Stern <stern@rowland.harvard.edu>
> >> Cc: Michal Nazarewicz <mina86@mina86.com>
> >=20
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> >=20
> >> ---
> >>  include/linux/usb/gadget.h | 20 ++++++++++++++++++++
> >>  1 file changed, 20 insertions(+)
> >>
> >> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> >> index 23b3bfd0a842..cae8a6216551 100644
> >> --- a/include/linux/usb/gadget.h
> >> +++ b/include/linux/usb/gadget.h
> >> @@ -502,6 +502,8 @@ struct usb_gadget_ops {
> >>   *	only supports HNP on a different root port.
> >>   * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
> >>   *	enabled HNP support.
> >> + * @quirk_ep_out_aligned_size: epout requires buffer size to be align=
ed to
> >> + *	MaxPacketSize.
> >>   *
> >>   * Gadgets have a mostly-portable "gadget driver" implementing device
> >>   * functions, handling all usb configurations and interfaces.  Gadget
> >> @@ -541,6 +543,7 @@ struct usb_gadget {
> >>  	unsigned			b_hnp_enable:1;
> >>  	unsigned			a_hnp_support:1;
> >>  	unsigned			a_alt_hnp_support:1;
> >> +	unsigned			quirk_ep_out_aligned_size:1;
> >>  };
> >>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
> >> =20
> >> @@ -559,6 +562,23 @@ static inline struct usb_gadget *dev_to_usb_gadge=
t(struct device *dev)
> >> =20
> >> =20
> >>  /**
> >> + * usb_ep_align_maybe - returns @len aligned to ep's maxpacketsize if=
 gadget
> >> + *	requires quirk_ep_out_aligned_size, otherwise reguens len.
> >=20
> > =E2=80=9Creturns=E2=80=9D
>=20
> I've got no idea how returns became reguens :)
> But maybe Felipe can fix it when applying?

Sure, but you owe me a beer hehe :-)

--=20
balbi

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSppuVAAoJEIaOsuA1yqREtaMQAKfZNdLyIIaZ4jp8yQEQ/1TA
wc/xMIviG+r9bUy/iPdcxJdsTGYwBPyBzYA2l7y/psDgy2rANnJX55WT683XFEQw
KIvnKTNXhpRRiydSUv/Zc0F0PFMf+QvWqLU2GSko/7UkkfyRpGESvizXH8fbCoRh
Acbu3MvAWD/uyohrEaYcHTsQ5kXzv8gHuLX8bJCs3yl36vSFGCVREkL268MmoVes
SKqSb29fR0HWl6b9HidZW/8wKvVf7y5J4YVa9SE6F8NfqrodamL02LGge/4xrvlO
0pdQGXCG99XX9s81WQjaQC/w5GCtwfNPynS2/FBYHlGgee+SRV93R4e00bQfJ13b
KSK9n7pmT5h7/L7WfXIRA5fiyHfUQkLGgNXRhjGD2i5mHfxZ0VjSXA7PCRNWqCMO
GSQ9Y0uSj5HGnwet+3woJjnCvevtX/ultl/iLZzjNIYFzpCv4OUghaBmxmtlBe7D
0E3c68h3Q4IH8H3CAM2PT1AciaGvQ9nP/Bv79j+uGryZdKs3KKmb5WVKbjUdiUHi
k0rGRnLaDlLZjvzND44Nex5eSC0hjjYAXjwe7LtWZ5/eNn9a2d1iT1s5apWjrz7q
9HknleUjOUz8QfsFI5oc+sCw8uefCOaTtfUA2tT1JIchCgI4+lvTQkJQyFdxomyK
SpunshkJKk2XljUnC7Bo
=Fncl
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
