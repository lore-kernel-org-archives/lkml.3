Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbaCTRhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:37:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50110 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061AbaCTRhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:37:11 -0400
Date: Thu, 20 Mar 2014 12:35:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: <balbi@ti.com>, Alan Cox <alan@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: hci_ldsic nested locking problem
Message-ID: <20140320173518.GD2827@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140320163435.GH32692@saruman.home>
 <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com>
 <20140320171621.GA2827@saruman.home>
 <20140320172920.GC2827@saruman.home>
 <532B26C1.8080806@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <532B26C1.8080806@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2014 at 01:34:57PM -0400, Peter Hurley wrote:
> [ +cc Huang Shijie ]
>=20
> On 03/20/2014 01:29 PM, Felipe Balbi wrote:
> >then we need updates to Documentation:
> >
> >Documentation/serial/tty.txt::
> >
> >|  Driver Side Interfaces:
> >|
> >|  receive_buf()	-	Hand buffers of bytes from the driver to the ldisc
> >|  			for processing. Semantics currently rather
> >|  			mysterious 8(
> >|
> >|  write_wakeup()	-	May be called at any point between open and close.
> >|  			The TTY_DO_WRITE_WAKEUP flag indicates if a call
> >|  			is needed but always races versus calls. Thus the
> >|  			ldisc must be careful about setting order and to
> >|  			handle unexpected calls. Must not sleep.
> >|
> >|  			The driver is forbidden from calling this directly
> >|  			from the ->write call from the ldisc as the ldisc
> >|  			is permitted to call the driver write method from
> >|  			this function. In such a situation defer it.
> >
> >documentation says ldisc is allowed to call ->write() from
> >->write_wakeup(). huh ?
>=20
> Patch submitted but never applied.
>=20
> http://www.spinics.net/lists/linux-serial/msg11144.html

Thank you. For that patch:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKybWAAoJEIaOsuA1yqRE6OAP/iLuyS64jJB9QHh4xToxGJEf
thG6Q5qwp0aSBDbZ42iJrYUV+HGqNoXcAhxhdIAdXYqVPpb0eW54KHZ74MQ3nXtw
JpW2/jKlG5Fsqji4SKpGdY8JqquAygOWRh53yNQ7mcp0YDwPBsb7HrPQU1wG7Loq
gWm8kA+O0rnJofc6+QninDu5QvmUdqINOE60n/9snOTvQrMy+SoqjXBSMNrcoSEp
NPnsK4oLsvuQWB+FCdMJafpR8MsEx/YhrxzQsRpgJEeBv8FLDrOLaRXe8KTSlmPO
MChU54A+/m01ORhrpSb7lIvk8xXg3SY2ORKNYOe2S64qcfqQD7l8sdmeGlAHQXFY
2Y0kCdPaJcXFZfQMho5BqI+gq2eZ8tldfo5fIJL4KZDXjgF6uD0JimceVR7UX4OK
RFYuFJkZsWqJopho33Ks12IIy1qQwWAUXprFqy5htPHu3FoZ8DuUfEAoUz0NnyZV
80+Cqn25hv7BZ2A5NZsdOHLXpyue94uDcLUmhIEflu80FKi7P9sVsxRuOtlS2hK0
E5mMPUEUaj44Eu9G5u3cm7O0+u8SSRrYzaEIwcCQjgjYVt5QZSAmU7LUwIOaGusf
mGx3am3lU9P/vnOF/GI4/cXoQ/97MVm5/+xub/mxnepvC9rIdZh7ViG+TbhIKzWD
lFTOlFDsjh3Jc6W4cFpV
=RGsU
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
