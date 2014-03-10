Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaCJQjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:39:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbaCJQi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:38:58 -0400
Date: Mon, 10 Mar 2014 11:37:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Henrik Rydberg <rydberg@euromail.se>, <dmitry.torokhov@gmail.com>,
        <jcbian@pixcir.com.cn>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/8] Input: pixcir_i2c_ts: Use Type-B Multi-Touch
 protocol
Message-ID: <20140310163701.GA30397@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393428486-15001-1-git-send-email-rogerq@ti.com>
 <1393428486-15001-5-git-send-email-rogerq@ti.com>
 <531B3331.9050008@euromail.se>
 <531D7E66.1070300@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <531D7E66.1070300@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 10:57:10AM +0200, Roger Quadros wrote:
> Hi Henrik,
>=20
> On 03/08/2014 05:11 PM, Henrik Rydberg wrote:
> > Hi Roger,
> >=20
> > the MT implementation seems mostly fine, just one curiosity:
> >=20
> >>  static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
> >>  {
> >>  	struct pixcir_i2c_ts_data *tsdata =3D dev_id;
> >>  	const struct pixcir_ts_platform_data *pdata =3D tsdata->chip;
> >> +	struct pixcir_report_data report;
> >> =20
> >>  	while (!tsdata->exiting) {
> >> -		pixcir_ts_poscheck(tsdata);
> >> -
> >> -		if (gpio_get_value(pdata->gpio_attb))
> >> +		/* parse packet */
> >> +		pixcir_ts_parse(tsdata, &report);
> >> +
> >> +		/* report it */
> >> +		pixcir_ts_report(tsdata, &report);
> >> +
> >> +		if (gpio_get_value(pdata->gpio_attb)) {
> >> +			if (report.num_touches) {
> >> +				/*
> >> +				 * Last report with no finger up?
> >> +				 * Do it now then.
> >> +				 */
> >> +				input_mt_sync_frame(tsdata->input);
> >> +				input_sync(tsdata->input);
> >=20
> > Why is this special handling needed?
>=20
> This is needed because the controller doesn't always report when all fing=
ers
> have left the screen. e.g. report might contain 3 fingers touched and then
> gpio_attb line is de-asserted. There's no report with 0 fingers touched e=
ven
> if the user's fingers have left the screen. So we never detect a BUTTON_U=
P.
>=20
> Without this s/w workaround we observe side effects like buttons being pr=
essed
> but not released. To me it looks like a bug in the controller.

the other way would be to *also* use IRQF_TRIGGER_RISING, then you get
an IRQ when fingers leave the screen. No ?

--=20
balbi

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHeotAAoJEIaOsuA1yqRETb4QALJCMlzEjH+h++ArhkS3w5sU
k/ZGnOjvxNLoSaAKzjd6A9os07SGtLhzJdc96fOa4+ZL9kG4nLn0tgQWbbANY3UG
PJSoXh4RcR/tRVLsVbTVTzY5lCtiPPDljDO1eeyEdNu4WnchMXVYD2Zs/Qt2gc3C
xttLeCsDgwpjr45EO0vzexkeUyDWSQHtki9aYID/dljC2MxRXwyGC3F7w4YLRVCc
S3y8uHB7wcHtf+0lbvW/NpPep3lyWblblzlqwCiRlXWoni+xmA+/fVMvNo3LJb3D
zuYy0Ox4lMCjaqmbI5UfxL22IxtLW36DicEEiPcXyjJmy9z3qFFszQz1VTtn88yh
nhg49wAQxMKwtIaj8zM9XaWasW2ujkcMRFpnW3y5liuVR1hRui24RDlkNieYb32y
Y2mRhqtMsgP6bNncRwPk1qYFQ1jTv2T5fxmzw2NVLzK+AQsDiDWu/DWtJm8O8pIH
FPfip7tQUUakUD1E/0s6yMexZbkVKEzPyneHZV0qcrp6ihcd/iedpSGB99cOZ85S
9ko8pA9zUw7XDbFvlQAs6cyu2Qlt6LSz6x+v3EzyLOoimtCnmwQ2+0Jwkoj4eB3n
KBYlOgihOnSR5jBIswpNpDWxtRL2AIRt5rlycUeTg8DGQLZV1HDJTLQHD4QCoGDm
u6qYhSpgJP3ot6Q1evBN
=F8xU
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
