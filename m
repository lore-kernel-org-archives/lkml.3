Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934930Ab3FSR0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:26:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43483 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934731Ab3FSR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:26:21 -0400
Message-ID: <51C1E98B.8030503@ti.com>
Date: Wed, 19 Jun 2013 13:25:31 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 08/15] thermal: cpu_cooling: fix stub function
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1370038972-2318779-9-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2OJJKQETNUJCPPUTHNDRR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OJJKQETNUJCPPUTHNDRR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Arnd,

On 31-05-2013 18:22, Arnd Bergmann wrote:
> The function stub for cpufreq_cooling_get_level introduced
> in 57df81069 "Thermal: exynos: fix cooling state translation"
> is not syntactically correct C and needs to be fixed to avoid
> this error:
>=20
> In file included from drivers/thermal/db8500_thermal.c:20:0:
>  include/linux/cpu_cooling.h: In function 'cpufreq_cooling_get_level':
> include/linux/cpu_cooling.h:57:1:
>  error: parameter name omitted  unsigned long cpufreq_cooling_get_level=
(unsigned int, unsigned int)  ^
>  include/linux/cpu_cooling.h:57:1: error: parameter name omitted
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>


What is the status of this patch?

I believe Rui is supposed to queue this one right?


> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
> ---
>  include/linux/cpu_cooling.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
> index 282e270..a5d52ee 100644
> --- a/include/linux/cpu_cooling.h
> +++ b/include/linux/cpu_cooling.h
> @@ -41,7 +41,7 @@ cpufreq_cooling_register(const struct cpumask *clip_c=
pus);
>   */
>  void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
> =20
> -unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int);
> +unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int=
 freq);
>  #else /* !CONFIG_CPU_THERMAL */
>  static inline struct thermal_cooling_device *
>  cpufreq_cooling_register(const struct cpumask *clip_cpus)
> @@ -54,7 +54,7 @@ void cpufreq_cooling_unregister(struct thermal_coolin=
g_device *cdev)
>  	return;
>  }
>  static inline
> -unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)
> +unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int=
 freq)
>  {
>  	return THERMAL_CSTATE_INVALID;
>  }
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2OJJKQETNUJCPPUTHNDRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHB6YsACgkQCXcVR3XQvP0hwQEAh0awPf3VhYdWEccmXSWfQsI/
E4DNfWZUJbKB2BV7buUA/jWK5xVmnTxzh8YHxcZCVYZe3jolPCiWXpWMTEzgZlYN
=m7w8
-----END PGP SIGNATURE-----

------enig2OJJKQETNUJCPPUTHNDRR--
