Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaAYC0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 21:26:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:33962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaAYC0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 21:26:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,716,1384329600"; 
   d="asc'?scan'208";a="472170830"
Date: Fri, 24 Jan 2014 21:05:52 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] x86: allocate cpumask during check irq vectors
Message-ID: <20140125020552.GB1508@gchen.bj.intel.com>
References: <1390594267-16739-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1390594267-16739-1-git-send-email-yinghai@kernel.org>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 12:11:07PM -0800, Yinghai Lu wrote:
> Date:	Fri, 24 Jan 2014 12:11:07 -0800
> From: Yinghai Lu <yinghai@kernel.org>
> To: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
>  linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Prarit
>  Bhargava <prarit@redhat.com>
> Subject: [PATCH] x86: allocate cpumask during check irq vectors
> X-Mailer: git-send-email 1.8.4
>=20
> Fix warning:
> arch/x86/kernel/irq.c: In function check_irq_vectors_for_cpu_disable:
> arch/x86/kernel/irq.c:337:1: warning: the frame size of 2052 bytes is lar=
ger than 2048 bytes
>=20
> when NR_CPUS=3D8192
>=20
> We should use zalloc_cpumask_var() instead.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Prarit Bhargava <prarit@redhat.com>
>=20
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index dbb6087..b114ee4 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -277,11 +277,14 @@ int check_irq_vectors_for_cpu_disable(void)
>  	unsigned int this_cpu, vector, this_count, count;
>  	struct irq_desc *desc;
>  	struct irq_data *data;
> -	struct cpumask affinity_new, online_new;
> +	cpumask_var_t affinity_new, online_new;
> +
> +	zalloc_cpumask_var(&affinity_new, GFP_KERNEL);
> +	zalloc_cpumask_var(&online_new, GFP_KERNEL);
> =20
Hi, Yinghai

The original author Prarit Bhargava had committed a similar
patch and I ever said this function is protected by stop_machine
so GFP_KERNEL is not reliable. It should be GFP_ATOMIC.


--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4xwAAAoJEI01n1+kOSLH+TcQAKhQsdmBUIoidWASpqyyOQxt
rdplmWlD0Rz8nVcMeoaDeXxjoVyEo1+QLBpuVd3MowVrS4iKSPOWOZqyMBBAiBgj
xGamGNULxB0yj/Adj2rilkAqS9Oyy/veSM7n47CuY+iiFUsDtA0SewyYhAPv8O3A
lJKbXc42sxiUWMhW/7i3+EasSvW/zdwxhW7CUM/aVSy9U4IWD1xUV/qs2K9uOoM2
93v4rlYziGdaPpTpICuYpjE+hP/YAAHgox/b4eGPIepkHYcvTbWRw1RnaF5tvs4D
L4d9EYYS/2w4lHeuxmrMaVvUM87nEYsvVB3unh1vUrCKK0zITym07mL7ndZT3v37
1C81uhMZzbuSMZRuZh1aXuZZ6Wz9Wjp9Pq2e4IHR7xAGO6Sk2WY5CZGZzTV+sOTF
Ks0OUqvv+/+T3MmRDBhyULpPVYcU6f6FFMObT9X/gZ7SsGtwg50W8u0HsU6w5CO0
Kfx9U1gpDUNa3tulLpNuVa0PNuP5BFj+pMJI9GZoHugm/ahaEz4dDoWZg6dz3txR
OGUHz3yHesJ0JBx1Ykm6nova6BlEhe1a4L82J1rTHSMErcAyD1lXlLRxWAAmp2g3
+Q0SN1ji3T20k8YgmIGtVawuN5ERBye5JRfW/xX3M5xLFG8T2OKt1XoeTiX7Hw0c
zwiUjcHm0OxXfImOEmwM
=dH1M
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
