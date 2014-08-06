Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbaHFSzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:55:45 -0400
Received: from sauhun.de ([89.238.76.85]:56499 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbaHFSzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:55:43 -0400
Date: Wed, 6 Aug 2014 20:55:40 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: remove unnecessary 'else' after 'return' statement
Message-ID: <20140806185539.GA2736@katana>
References: <1407308765-13869-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1407308765-13869-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 12:36:05PM +0530, Kiran Padwal wrote:
> Fix the following warning reported by checkpatch.pl:
>=20
> WARNING: else is not generally useful after a break or return
>=20
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>

Technically true, yet I think the original code is a tad more readable,
so I'll keep it like it is.

> ---
>  drivers/i2c/i2c-core.c |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 632057a..228bd04 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -351,8 +351,8 @@ static int i2c_device_pm_suspend(struct device *dev)
> =20
>  	if (pm)
>  		return pm_generic_suspend(dev);
> -	else
> -		return i2c_legacy_suspend(dev, PMSG_SUSPEND);
> +
> +	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
>  }
> =20
>  static int i2c_device_pm_resume(struct device *dev)
> @@ -361,8 +361,8 @@ static int i2c_device_pm_resume(struct device *dev)
> =20
>  	if (pm)
>  		return pm_generic_resume(dev);
> -	else
> -		return i2c_legacy_resume(dev);
> +
> +	return i2c_legacy_resume(dev);
>  }
> =20
>  static int i2c_device_pm_freeze(struct device *dev)
> @@ -371,8 +371,8 @@ static int i2c_device_pm_freeze(struct device *dev)
> =20
>  	if (pm)
>  		return pm_generic_freeze(dev);
> -	else
> -		return i2c_legacy_suspend(dev, PMSG_FREEZE);
> +
> +	return i2c_legacy_suspend(dev, PMSG_FREEZE);
>  }
> =20
>  static int i2c_device_pm_thaw(struct device *dev)
> @@ -381,8 +381,8 @@ static int i2c_device_pm_thaw(struct device *dev)
> =20
>  	if (pm)
>  		return pm_generic_thaw(dev);
> -	else
> -		return i2c_legacy_resume(dev);
> +
> +	return i2c_legacy_resume(dev);
>  }
> =20
>  static int i2c_device_pm_poweroff(struct device *dev)
> @@ -391,8 +391,8 @@ static int i2c_device_pm_poweroff(struct device *dev)
> =20
>  	if (pm)
>  		return pm_generic_poweroff(dev);
> -	else
> -		return i2c_legacy_suspend(dev, PMSG_HIBERNATE);
> +
> +	return i2c_legacy_suspend(dev, PMSG_HIBERNATE);
>  }
> =20
>  static int i2c_device_pm_restore(struct device *dev)
> @@ -401,8 +401,8 @@ static int i2c_device_pm_restore(struct device *dev)
> =20
>  	if (pm)
>  		return pm_generic_restore(dev);
> -	else
> -		return i2c_legacy_resume(dev);
> +
> +	return i2c_legacy_resume(dev);
>  }
>  #else /* !CONFIG_PM_SLEEP */
>  #define i2c_device_pm_suspend	NULL
> @@ -622,8 +622,8 @@ static int i2c_trylock_adapter(struct i2c_adapter *ad=
apter)
> =20
>  	if (parent)
>  		return i2c_trylock_adapter(parent);
> -	else
> -		return rt_mutex_trylock(&adapter->bus_lock);
> +
> +	return rt_mutex_trylock(&adapter->bus_lock);
>  }
> =20
>  /**
> --=20
> 1.7.9.5
>=20

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT4norAAoJEBQN5MwUoCm2c/0P/1MS+8W/XMxLbrDNNeNhDj2h
AMV2v1t2JiFNmfsCKQm3dibKwVxa2qjp8eovzP4BPPXB42WPlNejpIDvPshaVl8b
BxnDCVD9fijL/4uxSIc5/fpfa0nNTX4YGLrPukK5v3Fxm3twUGytKppzw1NYCly7
PdQR2Bz6yBpPMvTUhZowImf/Nx6c2TkAbleYvxYSkWITCYvVCu69Dbpt5bgHPAET
iXit30qGCPGWnkf1+nHwtQ8J1ePvC2BRrM4oGyMopscgYZQrYxuAP/M9w1/xH/DE
5eHvY6/SHIXsC5rBzZvzDWjiOVsOS591oClUk/9ojanjQF5SvW9shvax/ilPSvmx
R3ri2Pw86c369u7isyHzuTQf1E+27kqNLIyAJL+BFARbbcukUgk1NSLdhCHYOd76
Ja26PHSnc1h1CGRPiFyRv7M9lqRp8dnkV2s39EGcXkEk0LWi98XSb49tahz61X/p
tvwSdLrFXac+98FE7+g8IL2VVjVndc2r9YzVMG3ty9cCkJvnTQZ0WnVPArrDtcx1
u/ei0s66PMHC83rR7lid2MuiENEfnsW+U4XAfrD+Cc3P+aP1kYwDXaNqLFC4hDyu
sttq32W1EqUpanHcp2iBhCRkCobncHS9Is2M67qFewK4Ek969d3AFulr6Gcr0Ld0
P/+w1iqNPNkmkYcVOoDn
=sCiS
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
