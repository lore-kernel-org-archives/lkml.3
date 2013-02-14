Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab3BNLfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:35:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39267 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757489Ab3BNLfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:35:33 -0500
Date: Thu, 14 Feb 2013 11:35:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap: irq: do not write mask register if it is not
 supported
Message-ID: <20130214113531.GC13249@opensource.wolfsonmicro.com>
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
 <1360761290-15976-2-git-send-email-ldewangan@nvidia.com>
 <20130213142036.GJ5062@opensource.wolfsonmicro.com>
 <511CC520.8050104@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <511CC520.8050104@nvidia.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 04:36:08PM +0530, Laxman Dewangan wrote:
> On Wednesday 13 February 2013 07:50 PM, Mark Brown wrote:

> >>  	for (i = 0; i < d->chip->num_regs; i++) {
> >>+		if (!d->chip->mask_base)
> >>+			goto skip_mask_reg_update;

> >Why is this inside the loop?

You appear to have ignored this question.

> >I'd also expect us to return an error if a caller tries to enable or
> >disable an interrupt, or possibly to give different ops to the IRQ
> >subsystem, rather than just silently claim we did what we were asked.

> I tried to use regmap-irq for the gpio submodule and it has two sets
> of register:
> GPIOx_CNFG: bit[7:6] interrupt rising/falling.
> GPIO_INT_STS where each bit shows the interrupt status whether it
> occured or not.
> There is no mask register.

> In regmap-irq_thread() we see the interrupt status and compare
> against mask enable buffer wther this is enabled or not and
> accordingly call the handler.

> hence I am still require irq_mask()/irq_unmask() to reflect the mask
> with interrupt status and type for actually configuring the
> GPIOx_CNFG.

> if I remove the mask_buf at all then how do we tell the int_sts
> register is corresponding to which gpio handler?

This doesn't sound like something that should be open coded in
individual interrupt controller drivers, obviously it's a bit rubbish
that there's no way to enable or disable the interrupt but presumably
other hardware has the same "feature" and the IRQ subsystem ought to
understand it.

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHMv5AAoJELSic+t+oim9QHwP/3PAla6xBkFFzkCzKDarRL+g
L3ohaO2i39XGBhfgZ/wc4PqK9MpjMWd1ReDTQuIegDaRHEBpTP7pN61+XuqnygJm
JjoXPF3PFaZ6LgDqWknTqocPHQLrQ9O22I4zBxMBwxz12QJ10f4sADro+oNjHHdK
MyhPmIAqj++jKEcaJPy6/BC3Cp/YFynhTrQ85UwGtxqh9hrO4+Z8PaoqlBDOLPti
LGJJ7nQYPDphAXH2zO6UJ2Ro0SiYimQ2Fni4li8vbcuSimlPvBuI9iMeWkITYjDL
FVPEtbxP8RDzCbKLHWrf3RWFqpCvRHhaqJ/xxo6bHEvGbz9shgLVZdpEPdao6IuX
kZmaXWMUh3WzI1cAtEBql5QM54PDb1+nZKstlCUcfbY+GwZATwg/UvOMrr9FT34I
E733+vboLQu5+5+yzXL1F1V5IesFWLcGOrEWwiUxV+3ZIBdhefWDzEhIABdxX2Z2
OToyj5j7ycSwSD/gRY5GWKOUpT7U1ZJ5wLes1ouV2RW8iXYNQi7BH7G9SKwb8itX
aSRRaMARSLYqI/8hR+W+/kG/lDyXTb0j8Sx5Q8r4jvUQa++cYkqgP4DxUQgi1BuJ
j2GoAMtsIS9GMv/V+SndID6Lv3q6FehvElAbqfkQJZ2XiXlMa2u0oNYyB6Hq/Lnn
T6Jwfez1Oj3b4t3VIdaW
=Mfyj
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
