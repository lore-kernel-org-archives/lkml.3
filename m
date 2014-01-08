Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbaAHWyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:54:07 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59911 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757562AbaAHWx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:53:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Emil Goode <emilgoode@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ACPI: thermal: remove const from thermal_zone_device_ops declaration
Date: Thu, 09 Jan 2014 00:07:46 +0100
Message-ID: <3062913.xSrRXgZCY8@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52CC8EEB.9010604@ti.com>
References: <1389111895-23007-1-git-send-email-emilgoode@gmail.com> <52CC8EEB.9010604@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 07:34:03 PM Eduardo Valentin wrote:
> 
> --d38TXoq0sN4NKSKSmrSA0nrfhHhs3Hefk
> Content-Type: text/plain; charset=ISO-8859-1
> Content-Transfer-Encoding: quoted-printable
> 
> On 07-01-2014 12:24, Emil Goode wrote:
> > The following commit introduced the requirement to not declare
> > thermal_zone_device_ops structs as const in order to allow
> > changing the .get_temp callback.
> >=20
> > commit 4e5e4705bf69ea450f58fc709ac5888f321a9299
> > Author: Eduardo Valentin <eduardo.valentin@ti.com>
> > Date:   Wed Jul 3 15:35:39 2013 -0400
> >=20
> >     thermal: introduce device tree parser
> >=20
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> 
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

Queued up for 3.14, thanks!

> > ---
> >  drivers/acpi/thermal.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> > index 1fd21ad..8349a55 100644
> > --- a/drivers/acpi/thermal.c
> > +++ b/drivers/acpi/thermal.c
> > @@ -861,7 +861,7 @@ acpi_thermal_unbind_cooling_device(struct thermal_z=
> one_device *thermal,
> >  	return acpi_thermal_cooling_device_cb(thermal, cdev, false);
> >  }
> > =20
> > -static const struct thermal_zone_device_ops acpi_thermal_zone_ops =3D =
> {
> > +static struct thermal_zone_device_ops acpi_thermal_zone_ops =3D {
> >  	.bind =3D acpi_thermal_bind_cooling_device,
> >  	.unbind	=3D acpi_thermal_unbind_cooling_device,
> >  	.get_temp =3D thermal_get_temp,
> >=20
> 
> 
> --=20
> You have got to be excited about what you are doing. (L. Lamport)
> 
> Eduardo Valentin
> 
> 
> --d38TXoq0sN4NKSKSmrSA0nrfhHhs3Hefk
> Content-Type: application/pgp-signature; name="signature.asc"
> Content-Description: OpenPGP digital signature
> Content-Disposition: attachment; filename="signature.asc"
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.12 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iF4EAREIAAYFAlLMjvIACgkQCXcVR3XQvP3L6gD7B2J7f2SUQuZhpShZH/GNtjUm
> 66MHYjXagUB6rDRkCAQA/3/Hh35+smtAZvxKm/IX45BOmyC/z3qMulmA6Alsy52I
> =Cuu1
> -----END PGP SIGNATURE-----
> 
> --d38TXoq0sN4NKSKSmrSA0nrfhHhs3Hefk--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
