Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbaD2AAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:00:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46600 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaD2AAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:00:09 -0400
Date: Mon, 28 Apr 2014 18:59:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Zhuang Jin Can <jin.can.zhuang@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: debugfs: add snapshot to dump requests trbs
 events
Message-ID: <20140428235957.GD18010@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140428204923.GC12185@intel.com>
 <20140428155536.GE30292@saruman.home>
 <A2CA0424C0A6F04399FB9E1CD98E03046D192103@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YkJPYEFdoxh/AXLE"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03046D192103@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YkJPYEFdoxh/AXLE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 07:58:43PM +0000, Paul Zimmerman wrote:
> > From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kern=
el.org] On Behalf Of Felipe Balbi
> > Sent: Monday, April 28, 2014 8:56 AM
> >=20
> > On Mon, Apr 28, 2014 at 04:49:23PM -0400, Zhuang Jin Can wrote:
> > > Adds a debugfs file "snapshot" to dump dwc3 requests, trbs and events.
>=20
> < snip >=20
>=20
> > > +	for (i =3D 0; i < evt->length; i +=3D 4) {
> > > +		event.raw =3D *(u32 *) (evt->buf + i);
> > > +		if (i =3D=3D evt->lpos) {
> > > +			seq_puts(s, "lpos-------|\n");
> > > +			seq_puts(s, "           \\\n");
> > > +		}
> > > +		seq_printf(s, "event[%d]: %08x ", i, event.raw);
> > > +
> > > +		if (event.type.is_devspec)
> > > +			dwc3_dump_dev_event(s, &event.devt);
> > > +		else
> > > +			dwc3_dump_ep_event(s, &event.depevt);
> > > +		seq_puts(s, "\n");
> > > +	}
> >=20
> > how well have you tested this ? I'm not entirely sure you should be
> > reading the event buffer at any time you want, though I might be wrong.
>=20
> Just FYI, it is fine to read from the event buffer memory at any time.
> But of course, if you happen to read from a location at the same time
> the core is writing to it, you may read either the old value or the new,
> depending on the timing. So the results might not be 100% reliable.

Thanks, based on this I'll stick to my
"use-a-ring-buffer-to-store-last-5-events" suggestion :-)

--=20
balbi

--YkJPYEFdoxh/AXLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXut9AAoJEIaOsuA1yqRErXUQAIH5YnN4JaUhYWK9womYZ59D
DHiqq3UoaLsyT9fk5CL5x+l+fSjKGZ+GhvvQ3YEhhNoqM28+aCO1gC09mivk3oxc
+Oqoh33sGLhvn0R5ST0pWmTckBJQXyZMwPEhWF9KIeJP7+neXo+lJUqD3XfvPYeY
oF6r8BelrGpQTwgVgeNLo3y7r5jSiTMO6sAa7iU+dj9JQE2FKLUHfH6XfLvaIWyJ
iQpPlcAoDZa2lGJuYaj1LMX0eRPi30+9BFiZXz3V14zFaHnPtcMn5cjvsCWCdEWd
APItzKMuEjf10mmmIXkjDL5wTCqGsui0gsWUFJfjMmxUMKKK9SL3790nQTETnGzR
0L7b0nsTbgsehNx4T0/zdEAIncJXg8NSlljvRVRzkO5eBRWmsQLiXIC3pn4sGnDf
vykGpTDsklybTF+SedJpBpQhAakUkd09zAgSkMx8sLWK59svZKzBcNnckYIz0E42
eO+hl16UOK7ZoDngGwCs2QN6uZyFOVnuzQp0tKMN7I9TFfKupbdmiJSqp4jzdTUM
Sqe8TO9O8mt32zLs1cfhq1UO6IJL3ahypfmaiSe9omrZlNlhwX9XdqNrgt8Qn5BS
2X8vfJpoSk56c4tNaqrPDL7Ptp2pph5NoyAoAq8TAlwlHAKIyO9B3r3hJMy1AvAn
d4k2zS13UtuKbjK3SP3B
=+6Mi
-----END PGP SIGNATURE-----

--YkJPYEFdoxh/AXLE--
