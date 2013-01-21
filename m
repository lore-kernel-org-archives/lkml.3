Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3AUHhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:37:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:46989 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3AUHhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:37:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="asc'?scan'208";a="276253851"
Date: Mon, 21 Jan 2013 02:27:29 -0500
From: Chen Gong <gong.chen@linux.intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] x86: Add cpu capability flag
 X86_FEATURE_TSC_S3_NOTSTOP
Message-ID: <20130121072729.GB11915@gchen.bj.intel.com>
Mail-Followup-To: Feng Tang <feng.tang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
	Len Brown <lenb@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	linux-kernel@vger.kernel.org
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <1358750325-21217-2-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <1358750325-21217-2-git-send-email-feng.tang@intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 02:38:41PM +0800, Feng Tang wrote:
> Date:	Mon, 21 Jan 2013 14:38:41 +0800
> From: Feng Tang <feng.tang@intel.com>
> To: Thomas Gleixner <tglx@linutronix.de>, John Stultz
>  <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin"
>  <hpa@linux.intel.com>, x86@kernel.org, Len Brown <lenb@kernel.org>,
>  "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
>  linux-kernel@vger.kernel.org
> Cc: Feng Tang <feng.tang@intel.com>
> Subject: [RFC PATCH 1/5] x86: Add cpu capability flag
>  X86_FEATURE_TSC_S3_NOTSTOP
> X-Mailer: git-send-email 1.7.9.5
>=20
> On some new Intel Atom processors (Penwell and Cloverview), there is
> a feature that the TSC won't stop S3, say the TSC value won't be
> reset to 0 after resume. This feature makes TSC a more reliable
> clocksource and could benefit the timekeeping code during system
> suspend/resume cycle, so add a flag for it.
>=20
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/intel.c       |   12 ++++++++++++
>  2 files changed, 13 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpu=
feature.h
> index 2d9075e..f7e1eac 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -100,6 +100,7 @@
>  #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
>  #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
>  #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU resto=
re */
> +#define X86_FEATURE_TSC_S3_NOTSTOP (3*32+30) /* TSC doesn't stop in S3 s=
tate */
> =20
We have an existed "TSC always running in C3+" feature and name it as
X86_FEATURE_NONSTOP_TSC, so how about naming it with the same style,
like X86_FEATURE_NONSTOP_TSC_S3?


--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/O3hAAoJEI01n1+kOSLHjmMQAIm/owcSBPRSgLtt6oMfUYzp
RBnLMe9vzZWEj5GegOrBiScYB4ZFaDW+Lw+dw0CLr0JdrW9mlFWS2Km3lIsjJNvg
UcOGKmNykDARghgVgFQQb/oO7SLxe7V/ybul69FD7WIJLk5OqaWZ1xyWyMf3R7Ly
3L3V7VRGtOhByMPx0QZv3eyflKQ+12reYvTxC370CXwapHhMweh5szC0AbKgwWxm
SfX95nwKE581DcBE/HzlhouXpPpq19pI8FrpZAWUE0GNv2QQXyu8+XytS7qnMJEb
H6NB8GpWXEp3vyby3dPLaHlNHerk5l5gI6RmWzlPHqfjiv4pu5Y932Ybtb7dqi7x
iJG7rh78M1SFWaRkGDrs1GB2elVGiHi/sfhJ2+5TVeaSEGH/P0JRYUBz8OZ79SnC
j/UAM6dKtZy1cJ334ifvt75sjVnhZyRRJ3JnUcjrk/y/+DD2bY66JaPDImCHBWuc
DARJOG2o5HgV7qiHYzX41djd8WzUoXaQj0tZSQcALI3EniRYKGcUCB88fqykNmEt
pncBefTLCgwW0MpAYinaRBk0KU2TAzUOhV/t358kY3z0oqDPoK8Agvhg/UYW9dCD
g8edzx20PC9By97pdpEzDLJtnWyw5fyfmjdTSz8CoqKElyHDDFCzz+bQgXS2/z7t
z1UTqrERKNT02AHH+bB6
=P36F
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
