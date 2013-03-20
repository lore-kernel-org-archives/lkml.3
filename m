Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403Ab3CTMvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:51:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39336 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934335Ab3CTMvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:51:49 -0400
Date: Wed, 20 Mar 2013 14:51:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: <oskar.andero@sonymobile.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <Radovan.Lekanovic@sonymobile.com>,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>
Subject: Re: [RFC PATCHv2 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev
 can be null
Message-ID: <20130320125125.GP29659@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363691503-15581-1-git-send-email-oskar.andero@sonymobile.com>
 <1363691503-15581-2-git-send-email-oskar.andero@sonymobile.com>
 <xa1t7gl3a5hr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWsnvgFfkTS2ATo5"
Content-Disposition: inline
In-Reply-To: <xa1t7gl3a5hr.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SWsnvgFfkTS2ATo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 02:22:56PM +0100, Michal Nazarewicz wrote:
> On Tue, Mar 19 2013, oskar.andero@sonymobile.com wrote:
> > The udc_irq service runs the isr_tr_complete_handler which in turn
> > "nukes" the endpoints, including a call to rndis_response_complete,
> > if appropriate. If the rndis_msg_parser fails here, an error will
> > be printed using a dev_err call (through the ERROR() macro).
> >
> > However, if the usb cable was just disconnected the device (cdev)
> > might not be available and will be null. Since the dev_err macro will
> > dereference the cdev pointer we get a null pointer exception.
> >
> > Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> > Signed-off-by: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
>=20
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>=20
> I think this is the best solution.  Adding if statements around it would
> just add noise.

alright, please re-send without RFC tag and with Michal's acked-by so I
can apply.

--=20
balbi

--SWsnvgFfkTS2ATo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSbDNAAoJEIaOsuA1yqREYRsP/RrKMpVzNOrtuigdmAzgKIQe
nIn+BXyv33zAqbuiGYpBUMBCV0nq1plS+1E4DhKEJbPWRFqnkhevUpI8dqrK68T+
GVW/3/ZZAeP4M3BhHjHS5Lai6fh5zeDOvghvPQzvnRZEQdinIC6LtIvHEm/blV7Y
s9FvHcCfTljhDevwkdCFj+MeAJB914husixBb11D8zOW0x497D0ayh4bNHnCicqQ
Nwj0iucofiDv4ANjBE5ztkTdO7GXCWecw9evrzwOy/ZIG67jOZWVqFKDGOeru9gn
NYBnrYX6u+CL6e430qAILQs+lPOIFS23EvEsDNEvJoPWODI282Wl+Ln9LJUefP5n
l2IVv3lv84EiNrfk1TCOS6pj1TxbKgaVophQA2F+RNqr2N4FivA5AQy0HUOS/gUJ
5XXKa8GvdB7sa82S9b5sORLW6iGM75U9cyzvxoyQP/3MEPjDC+YPbCK06uvCIbPa
OlGtdzebNwWspSeqw4EkdRHJPC3W0KYloncwzeLA7VyOe0wy+QymLSvcgrBjTM+5
4+A2qCE+d9xv3vXxemMb9jpYL8yP4dqx9JwX5hBeJ6zcjXz0tfx1HDR0CzhYjCsg
uKq2yrbegwB3ArKD7yxQi/46jv8K4BbzBf/YzUQh159Dt72cuiu8pTV4BWzYx8an
9sxhNwDAk6S5WfKL4sPS
=3rdc
-----END PGP SIGNATURE-----

--SWsnvgFfkTS2ATo5--
