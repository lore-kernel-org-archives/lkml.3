Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3GXG0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:26:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:5140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3GXG0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:26:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,733,1367996400"; 
   d="asc'?scan'208";a="272416943"
Date: Wed, 24 Jul 2013 02:16:26 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Message-ID: <20130724061626.GA18995@gchen.bj.intel.com>
Mail-Followup-To: Tony Luck <tony.luck@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@suse.de>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
References: <0104420@agluck-desk.sc.intel.com>
 <CA+8MBbLkWZKwG40XMXCV75Vr=6pKq9rijRamt7=qALhc72SCTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <CA+8MBbLkWZKwG40XMXCV75Vr=6pKq9rijRamt7=qALhc72SCTQ@mail.gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2013 at 03:51:14PM -0700, Tony Luck wrote:
> Date: Tue, 23 Jul 2013 15:51:14 -0700
> From: Tony Luck <tony.luck@gmail.com>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
>  "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
>  parsing 'UC' errors.
>=20
> Gah ... there is another bug in that unaffected thread entry.  The check =
for
> MCG_STATUS should be for RIPV=3D1 *and* EIPV=3D0
>=20

I set "MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)" becase
I want it to cover Non-Affected Logical Processors (1,0)
and Affected Logical Processor/Recoverable continuable (1,1).

I think both of them are continuable so they should be as
*KEEP*.

> gmail will mess this patch up ... but should still be readable.
>=20
> -Tony
>=20
> ---
>=20
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> b/arch/x86/kernel/cpu/mcheck/mce-severity
> index 7f6ab4e..48f0fd2 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -112,7 +112,7 @@ static struct severity {
>         MCESEV(
>                 KEEP, "Action required but unaffected thread is continuab=
le",
>                 SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR,
> MCI_UC_SAR|MCI_ADDR),
> -               MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
> +               MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, MCG_STATUS_RIPV)
>                 ),
>         MCESEV(
>                 AR, "Action required: data load error in a user process",

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR73E6AAoJEI01n1+kOSLH+boP/iqNZhALD2LFFKeaeNn7ZRst
1b7fWeOClGDZu56NqpNcuKr7ZyWBuhe4CjLDprDwMKAWrHKmSNH/2FeG5t2kf51W
7Oxg/R104ZtYkbs/izfcxaKRcUN84Tb05wcQjWSN/Axi1IsGiAmGGllrhscAJGvK
nRju4FlsrBvtLZzmQB9DRqR5Sin7ej4laikq4BRLI28VimxnICGlgL6MoQJQ7IfS
1/ZQRjXjEPsdoZYaEjoEbPHVgg5NlO7PGdqAXFIaaFMLdI/asxUkym0YSmqbko+Z
yzJK3IukxQdOWAecM0Dxs9mNTuB6AguiKDPoIQcNyBS2uT4ayk731X+5eNFfk6rW
8QiuxH98fJPY4zwNffGD228g71PrfEGvV8mrDZGcKwTI9FKuX4JvDIZ2RDsXlSOt
7+ZO0e3JpVrVudZQ9r+r5s/aZDZtFi4VrNLIfgqKHannolmx0dxTUu5Di2nb5FZD
hWNN8G5pjxAKnxt11ELQDmu86s2QZDHZUcKc4XXsZLe2MxEVV4L/Z1vznxQ1ulXP
DE7FnYTSMcIqnjv3bWf1gIAHdvUBuB2ykemUHz+LdcJmumGkG4z530HNrq68eZ64
YZCZiHAdku8cMFJ7iSc/1j355BY6HVt7c1BmvgYWmS0tJi2xB4g+GWTThS1w1mHq
3qvoLDBtb8YS3ndderh2
=7Afw
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
