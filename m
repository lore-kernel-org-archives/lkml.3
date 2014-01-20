Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaATJKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:10:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:54222 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbaATJKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:10:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="asc'?scan'208";a="469399354"
Date: Mon, 20 Jan 2014 03:50:17 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Fengguang Wu <fengguang.wu@Intel.com>
Subject: Re: [PATCH] x86, cpu hotplug, use cpumask stack safe variant
 cpumask_var_t in check_irq_vectors_for_cpu_disable()
Message-ID: <20140120085017.GB5243@gchen.bj.intel.com>
References: <1389965961-14975-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <1389965961-14975-1-git-send-email-prarit@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2014 at 08:39:21AM -0500, Prarit Bhargava wrote:
[...]
> +
> +	if (!alloc_cpumask_var(&online_new, GFP_KERNEL)){
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (!alloc_cpumask_var(&affinity_new, GFP_KERNEL)) {
> +		ret =3D -ENOMEM;
> +		goto free_online_new;
> +	}
> =20
This function is protected by stop_machine, which means the interrupts have
been disabled, so GFP_KERNEL is not reliable.

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS3ONJAAoJEI01n1+kOSLHDMYQAJN5dImUxLrp7eaH3Yq4qFwk
elAnhl4bhay3JLkRqaUhhfcCkV3r5WdODS+sclg46MEA+ocJBbNMeTfaOmwJfTVE
kWwWu/AMHTtIrKA6Lryx/nI5DgWy1uECjJlKlQ0Zf+n4yWnNh+9RsncXI2Gwv5DZ
STLkiXEKiD4Y3bqECbKR+MmGg81C775rzBBABGtH1fth0dU+Eg2VFj1bZZyNDOpV
MLYPBcurtL/Ac4QlzxKORIqmVtJ2Okh8o3F47gAV7eXdeCiPylbgHf2qWt1jYroG
ducRbghVVyEH/2HGpdcWzio8t9hdUnmj4VzkLzKSgT2NQqNDwI1vVum285XuL+tg
qYKbCvv1GG8z+SEFo0N2/Pbd2cW9KyNeqwHq15hYMgEUOGayp0QTiDHVN+ggqdjy
bCGd/lbCiR4gbNJPPYH4htI4nTiVDCulXlXG3SskOeNTI+JXrFV52ZJwFCN93YsQ
fk/t6TxP1rZ2+CPnAmhv0mvhFjfmqan8kJZtTeodgPTUAoVBmpr3CjBN+Pa8W/t3
0P7OKQdwW/6F/oPwA6vYw2g8wPvYUdwwD3e3UnSgdUWORRYwqOkCgXpKm6Jf4Q1y
d0oOBJLYtLb/iekA1oTMgdkUA29CUzsiAnvYcjNOuwdJ7gTCY14sjVQ1f0s3J2pb
8u/GPz4GH5S4RuZfwyXr
=DaBf
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
