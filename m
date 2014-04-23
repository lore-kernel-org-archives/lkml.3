Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbaDWNw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:52:57 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:55781 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaDWNwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:52:34 -0400
Message-ID: <5357C59E.8080400@monstr.eu>
Date: Wed, 23 Apr 2014 15:52:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 14/21] of/fdt: create common debugfs
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com> <1398215901-25609-15-git-send-email-robherring2@gmail.com>
In-Reply-To: <1398215901-25609-15-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="88UUtkXqPO4B5klRm7exJsF1Uu6jmCtbo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--88UUtkXqPO4B5klRm7exJsF1Uu6jmCtbo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 03:18 AM, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
>=20
> Both powerpc and microblaze have the same FDT blob in debugfs feature.
> Move this to common location and remove the powerpc and microblaze
> implementations. This feature could become more useful when FDT
> overlay support is added.
>=20
> This changes the path of the blob from "$arch/flat-device-tree" to
> "device-tree/flat-device-tree".
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
> v2: move to after libfdt conversion
>=20
>  arch/microblaze/kernel/prom.c | 31 -------------------------------
>  arch/powerpc/kernel/prom.c    | 21 ---------------------
>  drivers/of/fdt.c              | 24 ++++++++++++++++++++++++
>  3 files changed, 24 insertions(+), 52 deletions(-)
>=20
> diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/pro=
m.c
> index c766306..68f0999 100644
> --- a/arch/microblaze/kernel/prom.c
> +++ b/arch/microblaze/kernel/prom.c
> @@ -114,34 +114,3 @@ void __init early_init_devtree(void *params)
> =20
>  	pr_debug(" <- early_init_devtree()\n");
>  }
> -
> -/*******
> - *
> - * New implementation of the OF "find" APIs, return a refcounted
> - * object, call of_node_put() when done.  The device tree and list
> - * are protected by a rw_lock.
> - *
> - * Note that property management will need some locking as well,
> - * this isn't dealt with yet.
> - *
> - *******/
> -
> -#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
> -static struct debugfs_blob_wrapper flat_dt_blob;
> -
> -static int __init export_flat_device_tree(void)
> -{
> -	struct dentry *d;
> -
> -	flat_dt_blob.data =3D initial_boot_params;
> -	flat_dt_blob.size =3D initial_boot_params->totalsize;
> -
> -	d =3D debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
> -				of_debugfs_root, &flat_dt_blob);
> -	if (!d)
> -		return 1;
> -
> -	return 0;
> -}
> -device_initcall(export_flat_device_tree);
> -#endif
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index f971134..03624ce 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -29,7 +29,6 @@
>  #include <linux/bitops.h>
>  #include <linux/export.h>
>  #include <linux/kexec.h>
> -#include <linux/debugfs.h>
>  #include <linux/irq.h>
>  #include <linux/memblock.h>
>  #include <linux/of.h>
> @@ -924,23 +923,3 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
>  {
>  	return (int)phys_id =3D=3D get_hard_smp_processor_id(cpu);
>  }
> -
> -#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
> -static struct debugfs_blob_wrapper flat_dt_blob;
> -
> -static int __init export_flat_device_tree(void)
> -{
> -	struct dentry *d;
> -
> -	flat_dt_blob.data =3D initial_boot_params;
> -	flat_dt_blob.size =3D be32_to_cpu(initial_boot_params->totalsize);
> -
> -	d =3D debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
> -				powerpc_debugfs_root, &flat_dt_blob);
> -	if (!d)
> -		return 1;
> -
> -	return 0;
> -}
> -__initcall(export_flat_device_tree);
> -#endif
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 0b38a6a..4129f74 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -20,6 +20,7 @@
>  #include <linux/errno.h>
>  #include <linux/slab.h>
>  #include <linux/libfdt.h>
> +#include <linux/debugfs.h>
> =20
>  #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
>  #include <asm/page.h>
> @@ -916,4 +917,27 @@ void __init unflatten_and_copy_device_tree(void)
>  	unflatten_device_tree();
>  }
> =20
> +#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
> +static struct debugfs_blob_wrapper flat_dt_blob;
> +
> +static int __init of_flat_dt_debugfs_export_fdt(void)
> +{
> +	struct dentry *d =3D debugfs_create_dir("device-tree", NULL);
> +
> +	if (!d)
> +		return -ENOENT;
> +
> +	flat_dt_blob.data =3D initial_boot_params;
> +	flat_dt_blob.size =3D fdt_totalsize(initial_boot_params);

As I wrote in different patch. I would move this to the end of this
series and
flat_dt_blob.size =3D of_get_flat_dt_size();

> +
> +	d =3D debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
> +				d, &flat_dt_blob);
> +	if (!d)
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +module_init(of_flat_dt_debugfs_export_fdt);
> +#endif
> +
>  #endif /* CONFIG_OF_EARLY_FLATTREE */
>=20

Other than comment above:
For Microblaze:
Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--88UUtkXqPO4B5klRm7exJsF1Uu6jmCtbo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXxZ4ACgkQykllyylKDCF3RQCfXnnWAfDfmGWypy71NoANLTHj
ciIAniVfzjzk3tzlgxXG9bABc6s9tMI8
=CNyh
-----END PGP SIGNATURE-----

--88UUtkXqPO4B5klRm7exJsF1Uu6jmCtbo--
