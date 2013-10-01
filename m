Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3JAUg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:36:26 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51511 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3JAUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:36:20 -0400
Date: Tue, 1 Oct 2013 22:34:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] pwm-backlight: Refactor backlight power on/off
Message-ID: <20131001203430.GA9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-2-git-send-email-treding@nvidia.com>
 <524B13BF.7080902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <524B13BF.7080902@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 12:26:07PM -0600, Stephen Warren wrote:
> On 09/23/2013 03:40 PM, Thierry Reding wrote:
> > In preparation for adding an optional regulator and enable GPIO to the
> > driver, split the power on and power off sequences into separate
> > functions to reduce code duplication at the multiple call sites.
>=20
> > diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight=
/pwm_bl.c
>=20
> > +static void pwm_backlight_power_off(struct pwm_bl_data *pb)
> > +{
> > +	pwm_disable(pb->pwm);
>=20
> Both the call-sites you're replacing do the following before pwm_disable(=
):
>=20
> 		pwm_config(pb->pwm, 0, pb->period);
>=20
> While I agree that probably shouldn't be necessary, I think it's at
> least worth mentioning that in the commit description just to make it
> obvious that it was a deliberate change. Splitting that change into a
> separate patch might be reasonable in order to keep refactoring and
> functional changes separate, although perhaps it's not worth it.

Actually I'll add that back. I'm not sure exactly why I dropped it (it
may just have been oversight) and there have been reports that some HW
actually requires pwm_config(..., 0, ...) before pwm_disable() to turn
off properly.

> There are also a couple unrelated whitespace changes thrown in here.

I think they increase readability, but I can certainly move them into a
separate patch.

Thierry

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSzHWAAoJEN0jrNd/PrOhc4IP/A/8tzxD8ELDkkCzKhqGuLAZ
TkfYFhVRUEccTBx1sn/ROmqYx5jcMwEeTuKb1QvrTozzwLW6dW7tVvz2QWr0Nxpk
eFx99F2kmNvWNrf2in0wtmGRxBFJUydUWwKcagiVO+C4wl36tCWUaP5hMrlDbEte
j7k6ydMQDZDxZuVcN/qZ+vOeIN5zdI7KeQtS/CbLAXpJtLCJr6W8dIm/+sJmt+MU
VpkF/DxnK2VhEwNbxRS/irOnoIs9Kgh1PRPQFciNUq2ab7uy9ADUSlosUEp2Jhvw
ZLNGsDeUm1zD4XYgBDVMJuU9hSeMneEUkdEQmJwih5gEDUs3NhyDzxZ00pM6IwQf
g/Dw2ewFx9l7+qHEvxxnOYWdeSfal+M+rjfAkSz7jriypXDJgvYIToSQMj3rRxVV
6G8AFe/+VaH/oKsKixk0d3aPhZQtNHVjQaShbJ8C7EvpowhkLFVQQ7MVMTQ7lWpS
Rm3MVeP7tN39RtIC0svt66Vuq/OjxOW8xQEKS68USzWZVcSrgYSL6AEOc5e/nf73
/IUabT+3ng/s9MmWcYNx01OEKAdDhegt5vcfAweX4ntcezcXgxkTXXHIH4emuymb
ZS+0RIZ5QFWS0aUeAQ3CxjoEp4a660oA46LbG13viblpQw0ZB0xL17chLUwRCeYj
UIuGk6yoOioDeG8g0A2J
=zpgL
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
