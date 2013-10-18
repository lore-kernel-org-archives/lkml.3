Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3JRALH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:11:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34578 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3JRALF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:11:05 -0400
Date: Fri, 18 Oct 2013 01:10:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang@marvell.com>
Cc: zhouqiao@marvell.com, zhangwm@marvell.com, yizhang.mrvl@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131018001036.GD2443@sirena.org.uk>
References: <1381839810-28984-1-git-send-email-yizhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RtvLjloV0UO9Bo7r"
Content-Disposition: inline
In-Reply-To: <1381839810-28984-1-git-send-email-yizhang@marvell.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: irq: clear status when disable irq
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RtvLjloV0UO9Bo7r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2013 at 08:23:30PM +0800, Yi Zhang wrote:

I'm still not sure this is doing the right thing.

> +			for (j = 0; j < bits_length; j++) {
> +				if (!(d->mask_buf[i] & (0x1 << j))) {

This is checking to see if the bit is masked...

> +					ret = regmap_update_bits(d->map, reg,
> +								 (0x1 << j), 0);

...then writing a zero to that bit.  For most chips with a write 1 to
clear acknowledge this will result in all set bits in the register being
acked except the currently masked one (though if there are two masked
bits all will be acked).

It would be much quicker to just write mask_buf[i] back to the device to
acknoweldge all masked bits at once rather than try to do it
individually and the result should be the same unless the chip requires
us to set zero (which probably ought to be a quirk).

--RtvLjloV0UO9Bo7r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYHx5AAoJELSic+t+oim9pkMP/AiVyhFa+DFTRqhP7iRi1Q/g
aS93Bw9v93SyEgOMVTXJcac++zJx6g/Sxle1D1JsHCdCX1rLopjGToL1p0TsyhjA
+mropERSa6yZBEdNUPtEvR1GSZtZHQodKwv0/bSsFcKL5jePQIVCj77s0320yR2k
Xv9BPnjQR7NSCHzbQoqxMJKFSGsqhEjPaGTuUJygoefX1VYM+9S55jMbqz2BhFOC
gDwWh6Vh91U6HTg/+Y4YM29qejkPrqxPYuaqNGR7NRivcza2pjurBU+KzIa/oQiO
rBsCD4cS/ci1VPgTNOa+5ynWCHhLGcbdH1Y25vV0EqFJ5EpIAI94ZKAyaSCMrT4O
KJBf2awY+hU5p4F+AdVBFbuJOi16r4gsowLeVOQaGPflC7raisfk7p97gxqJyoSi
JjylsTZB7s0LOZr5TUpgWbcrBNcmNz1YHDiRAxKNtyQuWQ1L0hR9A6bMcl/QRD1L
KCikQwpt+L7WiH7vac/1EP2zPG4ra8T+aQe83XxumbXckrUFOicNrvTTiZIq1TZh
LyMZVFc8sULa2rc7ADLyBldF+PbuXSyVVEp9gqKf5O3ahDw1fhaCXR1C4WCmUnMY
ZvCD4TZXJ4ZTsSvfVXIhRKB8U2190dFBdKfpDFscg4zkNr55kpW46TdwSERb490n
MQo3PamzmJcX16rhHP24
=gu6h
-----END PGP SIGNATURE-----

--RtvLjloV0UO9Bo7r--
