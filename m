Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbaICNhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:37:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48133 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaICNhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:37:36 -0400
Date: Wed, 3 Sep 2014 14:37:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140903133729.GM29327@sirena.org.uk>
References: <20140903143146.88d4b3ada1e3098989139540@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vYlOGI1a8wP+YbIl"
Content-Disposition: inline
In-Reply-To: <20140903143146.88d4b3ada1e3098989139540@kernel.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: manual merge of the drm-intel tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vYlOGI1a8wP+YbIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 02:31:46PM +0100, Mark Brown wrote:

> @@ -3923,7 +3942,9 @@ static void valleyview_irq_uninstall(struct drm_dev=
ice *dev)
> =20
>  	I915_WRITE(VLV_MASTER_IER, 0);
> =20
> -	for_each_pipe(pipe)
> +	intel_hpd_irq_uninstall(dev_priv);
> +
> +	for_each_pipe(dev_priv, pipe)
>  		I915_WRITE(PIPESTAT(pipe), 0xffff);
> =20
>  	I915_WRITE(HWSTAM, 0xffffffff);

=2E..or actually this since the above doesn't build, I was too hasty:


@@ -3923,7 +3942,9 @@ static void valleyview_irq_uninstall(struct drm_devic=
e *dev)
=20
 	I915_WRITE(VLV_MASTER_IER, 0);
=20
-	for_each_pipe(pipe)
+
+	for_each_pipe(dev_priv, pipe)
 		I915_WRITE(PIPESTAT(pipe), 0xffff);
=20
 	I915_WRITE(HWSTAM, 0xffffffff);

--vYlOGI1a8wP+YbIl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBxmWAAoJELSic+t+oim9k5sP/itbgjrEkcfzVOngmJgkNeAE
5db7Cfi8FBvqu45HCpNjdIngnl3VnvhaH3Y4G3MhZU6Ioz1Pcpvv2pIFCtMmrsjq
0U4VRTT39oO0ZGKs1FTf+MDf8ve1mKW5G/6aMmRmW3bySBay/T/fHAGsRUQB5+FW
i+oASE6f6+3atNQWyR1KIrIXgpBnczmevXKNPD6u1BhZHOZOYpQT6hdFHdLBbq4U
63LWHyouwf+sOSwTAdSCuhKnyGYIXoF5kmAgnfcUb3hc8n4a1WRrIyfAZ0ylcAy/
3ZGUi31MmetUvQKKI9DEtHrDvh14A7dhf4aZRSajbZc9j8CdWNofUgwEbPnBIFkW
BaFEJSJu8NWjPrSL6Npbbvn3T6C/XiBTPSR0L8fC60siDUaSfZmepS79EhHPsAX8
vFrQKuRhElTNOT7+laEcm62TMJSrkzStMfUdnYYxWK2FL4+xsnEdg6klfFzldUVg
OV4tdI8ZUo7lDzSZ6u5fogrYLrrn2+PLHRQGoUIUyXN4NZSBO2eRT9ruBEXRDg1u
hYmER5BJGLgAPhkOROwpJeDtw7G5a+ANLIrnzBFR/0TagJC1kXs5OvQIFU33dZU+
zxZzXiCedsbMGPD/ZcAHbIBML3ZmUDyx+ui+J/pwOT7fXXuPtBqJh8HM/raly4aC
PxTtSAtZ9M4UkxMwrv9q
=Pywr
-----END PGP SIGNATURE-----

--vYlOGI1a8wP+YbIl--
