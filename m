Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaG3Gzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:55:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:37706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaG3Gzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:55:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="asc'?scan'208";a="551120159"
Date: Wed, 30 Jul 2014 02:24:15 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140730062415.GA5100@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20140723203628.GJ21707@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 10:36:28PM +0200, Borislav Petkov wrote:
>   /*
>    * At CPU state changes, update the x2apic cluster sibling info.
>    */
> @@ -151,9 +166,14 @@ static int
>  update_clusterinfo(struct notifier_block *nfb, unsigned long action, voi=
d *hcpu)
>  {
>  	unsigned int this_cpu =3D (unsigned long)hcpu;
> -	unsigned int cpu;
>  	int err =3D 0;
> =20
> +	if (action & CPU_TASKS_FROZEN) {
> +		if ((action & ~CPU_TASKS_FROZEN) =3D=3D CPU_UP_CANCELED)
> +			__update_clusterinfo(this_cpu);
> +		return NOTIFY_OK;
> +	}
> +
Hi, Boris

Here you assume once the action contains FROZEN flag, it will return
NOTIFY_OK. It looks like not quite comply with original logic. Once
new FROZEN logic is added, we have to update this code again. How
about using following code snippet:

+       if ((action & CPU_TASKS_FROZEN) &&
+           ((action & ~CPU_TASKS_FROZEN) =3D=3D CPU_UP_CANCELED)) {
+               __update_clusterinfo(this_cpu);
+               return NOTIFY_OK;
+       }
+


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2I+PAAoJEI01n1+kOSLHG78QAKsSej9mkdwZPP4yIaGZP1Bt
/Mqq7P4pWOH8e6jJ/OZNoj21Ni60akFEg1jsLcKgsa3HkGAp+MEcmiWn/wBMKrCc
UwzKEYBts0Xjg0kfKGXEEWXzHJ1qjPuNLmaPyRiXzMzzrC/Y2oR+zPUoaHfKGUfY
nLgDza9sb1otC9t5bU28WYIH2GdxzpAgFDAQa2uGT7fbV+iJ2j13Vn5dBolR1q8x
K/yQXhoAuXTAJBJS7NNlsMdBRJu6D4FhopKmNWPxujASVoUxOtw/6bvskIzm6Q4m
fLoW7l5Sx9JWd550l9VPj4pHtKhefB8vafM7aCQf6/m/8NYxYCH84vrh7INUFsZh
2hPQvLrLrKydqIRaQC1QapdY8vF+uSuQeg65BQYaefdBTbzoLAUF78z+PW5tLVFf
vz4KBu+D7rmXRLfSdCp0axDwEHZYvETUqdYujSX5TplrN1BXrxia2agXWd1H5yDy
d/2+SllW8efkU1KAWMmbCEVHC3F19T955mml8yCvv5S6lskym7VB3tO9tb/t5oq8
896nkDkPvt8eJOtXe5wQfVTS/zBjnBQMVr2/0SO3FfYV/rVthJ7TNVEsmhDdLwVh
wi9iKgbhMy+OLDeRCM5V+weeIUPyKP5Vx09T+x6vYxAzaP0LDEAerhDULFjFFCeA
A9zFkJS8ovl0wqPNLtHR
=xcFN
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
