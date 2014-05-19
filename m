Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaESM7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:59:55 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46073 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaESM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:59:53 -0400
Date: Mon, 19 May 2014 14:57:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, santosh.shilimkar@ti.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] of/irq: do irq resolution in
 platform_get_irq_byname()
Message-ID: <20140519125738.GB9466@ulmo>
References: <1400506259-18397-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <1400506259-18397-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 04:30:59PM +0300, Grygorii Strashko wrote:
[...]
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
[...]
>  /**
> + * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq number
> + * @dev: pointer to device tree node
> + * @name: zero-based index of the irq

This is a name, not an index.

> + *
> + * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
> + * is not yet created, or errorno in case of failure.

s/errorno/error code/? Also EPROBE_DEFER is also an error code, so I'm
not sure if it's worth a special case in the description here.

> + *
> + */
> +int of_irq_get_byname(struct device_node *dev, const char *name)
> +{
> +	const char *name_irq = NULL;
> +	int index = 0;
> +
> +	if (unlikely(!name))
> +		return -EINVAL;
> +
> +	while (!of_property_read_string_index(dev, "interrupt-names",
> +					      index, &name_irq))
> +		if (!strcmp(name, name_irq))
> +			return of_irq_get(dev, index);

Isn't this missing an index++ somewhere? Otherwise it seems like this
would loop infinitely if there was no match on the first entry.

Thierry

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTef/CAAoJEN0jrNd/PrOhfOsP/AskVvB9TFUOcvTLUvXMuMXA
/RSs9f8H23ICbPjPLYThqbvqo4m1pY5Isjk41/Ljnael8q8lkXIm4BiK3X84OQeS
ZOFJtk41y1OBO+iYgY04HBqMdN5tPlm8mGkMFigKdhAGY2JlRXfAYrIlzz70eRE2
uybZy55nm7gamRn1XitiJKvBtpMdDOidJX8Pyp/sTyDRKQlqj4Z1vdNmYP0gtRSm
pTqFy8JBeXdXCTufu1LzfBtkHfAnKNR3QMhXcfOtlFVDfsp0Md9fjNb6ST6bT39J
i2/t9YVBEaxCESr3Zd8D/o+v3tGjUuVM4oyrKQiE0CE7gEcH1icyQzo6HlhLtzvQ
dyCWyNtesn7/QO+52YYCD93vAawa1+h9vjUVzqwRFWzdc3BCv8sGfjSyCNsnsAvx
Yi3XzK6sW1daSdoA5LDeaeedTvxGgiv+q4p7vnVuaIojF5KJNC4Uxmi6S464Uhis
3aXNxltVdO2eLxJfoLzq/dSVsW+CevYoCDqBCNMQ3nWRN7pVL0CR7PK8AOploJm1
PyRz+PmoD2Xng1p6TATjUAl1dxKQSbzDJXyBkTIbGfWATk+5dfyy7IzgGxmPKgWR
Sr//I8HbAXmF6Yr2C48gb/fg4moeloJoV8QECwxkgqLLB6bIXpHlSEK4ou8hVxFL
//+xziHRfUDXq1JCbBRR
=ZWdE
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
