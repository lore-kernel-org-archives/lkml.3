Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab3DAPnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:43:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51897 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758726Ab3DAPnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:43:03 -0400
Message-ID: <1364830967.3557.90.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/2] efi: Determine how much space is used by boot
 services-only variables
From: Ben Hutchings <ben@decadent.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, jwboyer@redhat.com, linux-efi@vger.kernel.org,
        seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
        x86@kernel.org
Date: Mon, 01 Apr 2013 16:42:47 +0100
In-Reply-To: <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Axxx66Hgs5PL/rHcoQYJ"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:8b3:8e02:718c:5f0d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Axxx66Hgs5PL/rHcoQYJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-01 at 11:13 -0400, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot service=
s.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the resul=
ts
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfu=
lly,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stu=
b
> up to the efivars code, letting us calculate a reasonably accurate value.

Good thinking.

> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
[...]
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -71,6 +71,10 @@ static efi_system_table_t efi_systab __initdata;
> =20
>  unsigned long x86_efi_facility;
> =20
> +u64 efi_var_store_size;
> +u64 efi_var_remaining_size;
> +u64 efi_var_max_var_size;
[...]
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
[...]
> @@ -2133,6 +2158,10 @@ efivars_init(void)
>  	ops.get_next_variable =3D efi.get_next_variable;
>  	ops.query_variable_info =3D efi.query_variable_info;
> =20
> +#ifdef CONFIG_X86
> +	boot_used_size =3D efi_var_store_size - efi_var_remaining_size;
> +#endif

efivars can be built as a module, but these aren't exported.

Ben.

>  	error =3D register_efivars(&__efivars, &ops, efi_kobj);
>  	if (error)
>  		goto err_put;

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-Axxx66Hgs5PL/rHcoQYJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVmq9+e/yOyVhhEJAQpZTg/+J0pfOg26xDd8udCaG3lzcp4ESRmdTImZ
YxCKkP24f1xnLSJWgB6THAmLSAnIFJAxm0hvt+pMo4vMCtaC/o1Or/Z3xzRdaqJo
nYzl8eY7U4cv4rMhwN/BvVCanJi4HqPlEA8fcB59kjeJMUpQkVW23MojsvuNEZ5S
T9UjLbtnxxcs8ZH0xNxgDCFyFWTzKL1wPHcUvLgpzA2RFz/72ikSKdUmAXvdzXZx
omMP9ogg4U+/WahFhNq8qTIAV+tGvu3YiVPoH+iwoZlgLwna9uTb3tOv1emkUReD
r2AcgW6W3FWgL/BvbAGaq8gtj0CW6xqqkcCVuTQt5NxEfs19oEM6/dUaLWFeWlcA
P4c6zwv2WQ8tIm3PqTuB4tHxOaDLnXJ8ajAn6WTxtnUkgxS+npM5sBBQayp4RcYV
P/ftjwszkm/3HVSRZOraIVJF4v8Gsx34lIe7BQZbd6XUSYvQ9jpDBnF4dKKSIvnm
ufnJrFqBjx9n/NHneBgyGiQvXj7rxBerd7qNxgS0H+PmYk+1W02/r5/t4zpXt1Of
p8sIsaht4c+bU5a91vgpb2kJwryovrJl5Pe+xUTEvYGSqNR8Lh+bbWv7ecR/OtDF
NQfoB6rw3LR6ZzFe+kpOmZfWwHQANzjnp4KBrWl5u3hBxtmzlZKKdC4S7NtfQcds
Abfn4W1764U=
=BTKV
-----END PGP SIGNATURE-----

--=-Axxx66Hgs5PL/rHcoQYJ--
