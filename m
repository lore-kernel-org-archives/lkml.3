Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaILNqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:46:34 -0400
Received: from sauhun.de ([89.238.76.85]:33704 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaILNqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:46:32 -0400
Date: Fri, 12 Sep 2014 15:46:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 2/8] i2c: Add the ability to match device to compatible
 string without an of_node
Message-ID: <20140912134648.GF1930@katana>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
 <1409236538-21274-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Content-Disposition: inline
In-Reply-To: <1409236538-21274-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 03:35:32PM +0100, Lee Jones wrote:
> A great deal of I2C devices are currently matched via DT node name, and
> as such the compatible naming convention of '<vendor>,<device>' has gone
> somewhat awry - some nodes don't supply one, some supply an arbitrary
> string and others the correct device name with an arbitrary vendor prefix.
>=20
> In an effort to correct this problem we have to supply a mechanism to
> match a device by compatible string AND by simple device name.  This
> function strips off the '<vendor>,' part of a supplied compatible string
> and attempts to match without it.
>=20
> The plan is to remove this function once all of the compatible strings
> for each device have been brought into line.

Is this really the plan? I mean, the old matching mechanism has been out
there for ages and I dunno how many already deployed DTs depend on it.
I'd think we need to keep this around forever.

>=20
> Acked-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/i2c/i2c-core.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index d3c8e9f..eb46d15 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1095,6 +1095,27 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(st=
ruct device_node *node)
>  	return i2c_verify_adapter(dev);
>  }
>  EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> +
> +static const struct of_device_id*
> +i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
> +				  struct i2c_client *client)
> +{
> +	const char *name;
> +
> +	for (; matches->compatible[0]; matches++) {
> +		name =3D strchr(matches->compatible, ',');
> +		if (!name)
> +			name =3D matches->compatible;
> +		else
> +			name++;
> +
> +		if (!strnicmp(client->name, name, strlen(client->name)))

Are compatible-properties case-independent? I though they were not.

> +			return matches;
> +	}
> +
> +	return NULL;
> +}
> +
>  #else
>  static void of_i2c_register_devices(struct i2c_adapter *adap) { }
>  #endif /* CONFIG_OF */
> --=20
> 1.9.1
>=20

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEvlIAAoJEBQN5MwUoCm2hogP/Rl8a5R+FCyggG3KvPNScrJe
OOLqeXDYSqPja7DotMMOnxkocpok2hWhr/lvV0cpnLfoDj+ho3XmZOrRnxR4cJ7w
YhYI3kOqxg4tGdJyJmtdmhjeAKfD3Qs43t+fD+O+gcoCT5BGsVCIM5U85qWFRS4A
h9CtHNgICfsa/0skhZThUNRbgRkJTUsUtZ7BM+K3CjHfKZUCiPLrIQeS3B8Om8s9
ouz1lUr6K38hbhXM8Y0kHGzVtz9A23M8U3ve9e2VhVnQVgIeFWlqvXU5OkcmnyYi
BBLeKi0dZVVEPlnXyV0nKcv60u75RQHTdL+COo1rDtJy1eDqEy00UHk/936pbFJd
+sbj+JAyasbZGp+K2wrMx0gJnzpgvoRRrTiHdxvKwJCPdUf97E+hKTUHXM218qDe
AYyjEFpNfgk7jQkPDxahWiMjELiYDLXncQVmwWHk5EjAlkx380oHnMyOAhiHrsqR
QrNqgpFXpC/KQoH0nkUKo+2PlDizUaBintoyxZCfaMdtA2u/HbYEcuQ5umsmWHNf
ZunPXFsXzt7utb5Scrf+752Bj+hsLiNWwIy864xoBM/sekOYfy8leJU6idT2dmEy
TRgnaPkDgmQbmVAJzpLSaiDyyhOp1Igb06bMdzdaWXdQ97/YPvURGbfcEVwbqgD3
/EW0RJzybz2pRNnz1Svu
=61ql
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--
