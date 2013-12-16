Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3LPMPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:15:33 -0500
Received: from ring0.de ([91.143.88.219]:42685 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab3LPMPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:15:31 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 16 Dec 2013 13:15:24 +0100
From: Sebastian Reichel <sre@debian.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [RFCv4 06/11] misc: Introduce Nokia CMT driver
Message-ID: <20131216121524.GA6177@earth.universe>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux-OMAP <linux-omap@vger.kernel.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
 <1387150085-23173-7-git-send-email-sre@debian.org>
 <CACRpkdYjjXgE_W8gq1e6z=nGMF=r-m+o2kkvrBFrEMm3o0=RwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <CACRpkdYjjXgE_W8gq1e6z=nGMF=r-m+o2kkvrBFrEMm3o0=RwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, Dec 16, 2013 at 10:48:06AM +0100, Linus Walleij wrote:
> On Mon, Dec 16, 2013 at 12:27 AM, Sebastian Reichel <sre@debian.org> wrot=
e:
> > Add driver handling GPIO pins of Nokia modems. The
> > driver provides reset notifications, so that SSI
> > clients can subscribe to them easily.
> >
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
>=20
> If the driver provides reset notifications, should it rather be
> in drivers/reset?
>=20
> I'm thinking of a generic GPIO reset driver with a generic
> notification mechanism, which seems to be what this is.
>=20
> I.e. it doesn't look device-specific at all, just like some
> generic glue code that could be useful to many such
> scenarios.

I like the idea.

Probably the remaining gpio exporting code can be converted into
some generic gpio-sysfs-export driver as well.

What do you think about the following?

/*
 * driver, which provides generic reset notifications
 */
cmt_reset: reset-notifier {
    compatible =3D "linux,reset-notification";

    interrupts =3D <gpio>;
};

/*
 * driver, which exports the specified gpios in sysfs with the
 * supplied names. The device will be named according to the
 * label
 */
cmt_gpios: gpio-sysfs-export {
    compatible =3D "linux,gpio-sysfs-export";
    label =3D "nokia-cmt";

    gpios =3D <A>, <B>, ...;
    gpio-names =3D "A", "B", ...;
};

> > +config NOKIA_CMT
> > +       tristate "Enable CMT support"
> > +       help
> > +       If you say Y here, you will enable CMT support.
> > +
> > +       If unsure, say Y, or else you will not be able to use the CMT.
>=20
> None of this explains what this driver actually does and what
> CMT means, so please rewrite this a bit to be more helpful.
> The way it is written it could as well say "enable FOO support".

I probably should have reviewed this better. This is the original
text from Nokia's driver.

> > +++ b/drivers/misc/nokia-cmt.c
> > @@ -0,0 +1,298 @@
> > +/*
> > + * CMT support.
>=20
> So CMT =3D ...?

CMT =3D Cellular Modem

> > +/**
> > + * struct cmt_device - CMT device data
> > + * @cmt_rst_ind_tasklet: Bottom half for CMT reset line events
> > + * @cmt_rst_ind_irq: IRQ number of the CMT reset line
> > + * @n_head: List of notifiers registered to get CMT events
> > + * @node: Link on the list of available CMTs
> > + * @device: Reference to the CMT platform device
> > + */
> > +struct cmt_device {
> > +       struct tasklet_struct           cmt_rst_ind_tasklet;
> > +       unsigned int                    cmt_rst_ind_irq;
> > +       struct atomic_notifier_head     n_head;
> > +       struct list_head                node;
> > +       struct device                   *device;
> > +       struct cmt_gpio                 *gpios;
> > +       int                             gpio_amount;
> > +};
>=20
> The kerneldoc and and the struct are not in sync. Look
> this over.

I will fix this in v5 (in case that its not removed completly).

> > +static LIST_HEAD(cmt_list);    /* List of CMT devices */
> (...)
> > +struct cmt_device *cmt_get(const char *name)
> > +{
> > +       struct cmt_device *p, *cmt =3D ERR_PTR(-ENODEV);
> > +
> > +       list_for_each_entry(p, &cmt_list, node)
> > +               if (strcmp(name, dev_name(p->device)) =3D=3D 0) {
> > +                       cmt =3D p;
> > +                       break;
> > +               }
> > +
> > +       return cmt;
> > +}
> > +EXPORT_SYMBOL_GPL(cmt_get);
>=20
> Is this driver used on non-DT platforms, or can we skip this
> struct device * referencing altogether?
>
> I would feel better if this driver looked more like
> drivers/mfd/syscon.c

Will be removed in v5.

> > +static irqreturn_t cmt_rst_ind_isr(int irq, void *cmtdev)
> > +{
> > +       struct cmt_device *cmt =3D (struct cmt_device *)cmtdev;
> > +
> > +       tasklet_schedule(&cmt->cmt_rst_ind_tasklet);
> > +
> > +       return IRQ_HANDLED;
> > +}
>=20
> Why are you using a tasklet rather than a work
> for this?

No particular reason. I just took this over from Nokia's code.

-- Sebastian

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSru7cAAoJENju1/PIO/qa6qkP+gKKi+BUkOKDO5LwVej51IfF
Jc8tpX1k8OpI2JgALP4uX8sQEUn/TCO4djGyPZU+GNbbZW8MLMAxrh1MIkm/zOrk
zyHI0ifIhke4uexPgeuJ9lqobqeSzy+J0BcJkw4bWDG4XJIMBEGXzViQzVzI+8EB
ODKKriYvqdaTTetPLq102cb7E7v/P3wqXVRTmUU6F9d7L/ACuhf/YGzvt5iel7UV
aPJpsV7wp0XlG0+yGDVFjdhrv4rDBRhDw5a4hyz8b6VRGNBGYKGNTaWGSnCSxyEO
D/F7WmDM3A3JR3J0+yCOtGm4D6HrQq2F0xlb6g620pa5S3VcxE9H1JHDyH/vt80Z
/kolz7AUSbvGRdeTCRU92phThazEoWzKWQy2g5D+dN8g9rFRXO4bey8mmTrC42AF
cl9Mw2T1aPRrRkRL8DEZo+MRukeYIOATicbf7g435of5KvwHdJBIUHHipHCR7j3I
e9jh7gG+Hpvzjr3L5rZve60JaTif4dKOlT20HHbqjx0Sk0e3D/ugUK+bDAU153IR
g7g+q70DEkFEhB9WDJvK4074owV+ilfXuer8xsULronfiwZPYcU1EFjGgxTkY2OZ
VsxBASde3usnxCWISzLRWMnd+dtMiht9WN/sP5gxLHiifND5KuRrim0ESq85DuhJ
Y1LUlolhtDdIJAnwZqjk
=lNxa
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
