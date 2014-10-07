Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaJGLJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:09:07 -0400
Received: from ozlabs.org ([103.22.144.67]:49084 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaJGLJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:09:05 -0400
Date: Tue, 7 Oct 2014 22:08:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Subject: Re: [PATCH v3 01/16] powerpc/cell: Move spu_handle_mm_fault() out
 of cell platform
Message-ID: <20141007220855.75b64a57@canb.auug.org.au>
In-Reply-To: <1412678902-18672-2-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
	<1412678902-18672-2-git-send-email-mikey@neuling.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5Mn39_SXGJ4L86bW5KiabNZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5Mn39_SXGJ4L86bW5KiabNZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mikey,

On Tue,  7 Oct 2014 21:48:07 +1100 Michael Neuling <mikey@neuling.org> wrot=
e:
>
> diff --git a/arch/powerpc/include/asm/copro.h b/arch/powerpc/include/asm/=
copro.h
> new file mode 100644
> index 0000000..2858108
> --- /dev/null
> +++ b/arch/powerpc/include/asm/copro.h
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright 2014 IBM Corp.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _ASM_POWERPC_COPRO_H
> +#define _ASM_POWERPC_COPRO_H
> +
> +int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
> +			  unsigned long dsisr, unsigned *flt);
> +
> +int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsi=
d);

This function is otherwise not included in this patch, so it should
probably be removed (as the next patch removes it anyway).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5Mn39_SXGJ4L86bW5KiabNZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUM8nNAAoJEMDTa8Ir7ZwVHqoQAJHLMnHM8SXXlGzS7t39h1hH
bQOom5cvmHAH+8a6j5JBzMUx9FoQz05nhdJlFcr3Bku9ZyU9jVgpdaMhYa3OeNSk
xehqH50e/RavicrYj7gF0qroCRSPt1vaFbnrPj0mNQKG2DOsn1bGmL8SkZERj5Lm
bhAXfSZwwgu8FYYxoYPYaxUNTl0E093NWoP+b2Tte6RD/egGgABQmhTuVdSWAVbX
+YiiDO90US8UYX7BSR6BJ4ea4/nv9QH4lh0E491knJBTTvzSKgRD4+imizF7YcAr
6Udb84ktJDgod8P5Y/7h8wi1y9X8Px64XnvVFnJ2+fatTbbC+cyF8n8vJKV6lK5N
pImyh0Y/6E+mqlvF5pYJ9uaVoNRlJaTO5JFNepgHNOL0HashpMT9FjMTu+SdiE3N
6VP16w2LLY7sF9lWXiAIKgRMr+pnpo2n/DtzsJzbEVBcPOlUM92HeReHHcDDxQ1j
u4e5iERYa8AyRfv7UzktgqVYMUlDwcm0Qk0uy9ScHIE2O3/L/kk93fsJnPWTZ99Y
MDcXuYMPQTXeuLZzHg+o+WkSdDT3XEE+3UDxVDkWPtvR4CVbvDKiaS43a0l0sajy
DZKVCjo9+etgkpCtGRzkYNufOQlp00rljSdbZ+EFht/g7ZKc+goN3HzoENZuiaUU
zb3KtqRddSkEcz5BiuYm
=L5aM
-----END PGP SIGNATURE-----

--Sig_/5Mn39_SXGJ4L86bW5KiabNZ--
