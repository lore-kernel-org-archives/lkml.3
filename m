Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab3EBQzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:55:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44239 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760578Ab3EBQzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:55:12 -0400
Message-ID: <51829A45.7040307@ti.com>
Date: Thu, 2 May 2013 12:54:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v2] thermal: cpu_cooling: fix stub function
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-13-git-send-email-arnd@arndb.de> <51828A45.60909@ti.com> <201305021829.37343.arnd@arndb.de>
In-Reply-To: <201305021829.37343.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2APRMFCAIGEHLWUVELWGI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2APRMFCAIGEHLWUVELWGI
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Rui, Arnd,

On 02-05-2013 12:29, Arnd Bergmann wrote:
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
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

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
>=20
>=20

>=20



------enig2APRMFCAIGEHLWUVELWGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGCmkUACgkQCXcVR3XQvP3JYQD/a4ueTTFuwRdfktuh6q2c9ZxG
0YeJyUXiq0G9CpMUFbcA+wVoQDZgfdjywa8K5BJfeQCbDNxGltt7m9h/tbCf7rhz
=9sto
-----END PGP SIGNATURE-----

------enig2APRMFCAIGEHLWUVELWGI--
