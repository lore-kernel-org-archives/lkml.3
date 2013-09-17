Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3IQMtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:49:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54516 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3IQMta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:49:30 -0400
Date: Tue, 17 Sep 2013 13:48:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Simon <horms@verge.net.au>, linux-kernel@vger.kernel.org
Message-ID: <20130917124852.GD21013@sirena.org.uk>
References: <87sixrre8r.wl%kuninori.morimoto.gx@renesas.com>
 <87mwnvsy7a.wl%kuninori.morimoto.gx@renesas.com>
 <87k3izsxw8.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xFHWmGwbilGjB8dh"
Content-Disposition: inline
In-Reply-To: <87k3izsxw8.wl%kuninori.morimoto.gx@renesas.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] regmap: Add regmap_fields APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xFHWmGwbilGjB8dh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 08:30:50PM -0700, Kuninori Morimoto wrote:
> Current Linux kernel is supporting regmap_field method
> and it is very useful feature.
> It needs one regmap_filed for one register access.

Applied, thanks.  I did make one update:

> + * A non-zero will be returned when fields access enable,
> + * a zero will be returned in single field.
> + */
> +int regmap_fields_enable(struct regmap_field *field)
> +{
> +	return field->id_size && field->id_offset;
> +}
> +EXPORT_SYMBOL_GPL(regmap_fields_enable);

This seems like it should be something like _is_present() - the name
makes me think it will turn something on, not check that something is
there.  I removed it since it's not used by the following patches and I
didn't notice earlier when I initially looked at the patches during the
merge window.

--xFHWmGwbilGjB8dh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOE+xAAoJELSic+t+oim9whgP/ApzL9UpdSBx+dE3DN3PR+Bk
GOaq+imWynulqOg7WiQYfvBNI/sRY74ouBAx1qSTj1Z50QsLaNUhBtc1Qm5BkAr+
oS1Qart+/wOOMOkB8wYnt2f957GqdWKHesxil309v7C58iniuGNAWNcJwSsGj97l
qSyrRXb8FzSR7+fDdY2H9BLz2segJveMD42mX/tZkzIHCLhQRpgKCF7axyjcJp4n
WL9gNHHsfQOjBeon3ISv6CFNJyHhD9ZnhEXa615lbgq7gMIWQ6lbRmvgKDCFTvJh
fGXCrLyzifrzN84NXavUvqhJcSiXOhXHXew2lCL6QXtcwDRxrndL4EUrfGhe4K6J
PqcvpErCG5mQkCDFAvxtrUQr+eEnL50XMzFOH0YY9sOYaCQij/DFgCzpqftI8mae
Di+9n8w1RphZDg5XfMGuWtKzsaQDgt4sm4HIGqO1EtrSmBk4u3zlDsv0FGF8Blh/
vG8UqC1P6oqLF6RoKpO15iV92i5vcJtsxol/NPtyRrLGWL2SKiKqc2LVdrpO8jlT
WFTGtSIqWU6Zk3ESqV8lLm1xXt4C+uuUrpuZL4UUIvHXCAX+1ySFLR2vzIbO8FQK
9u5qL3PlfA4LybJ8x8ZUlhKSxE3BAC90y+Kd/tyoRrlDa1ApYUgxC0ml6r4kP++M
nG23SdmiBqaqUn3I/aAf
=WVT1
-----END PGP SIGNATURE-----

--xFHWmGwbilGjB8dh--
