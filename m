Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946301Ab3BHL2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:28:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58342 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946244Ab3BHL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:28:49 -0500
Date: Fri, 8 Feb 2013 11:28:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Message-ID: <20130208112848.GM8879@opensource.wolfsonmicro.com>
References: <1359695098-3630-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+utxuhC6KVTvgNz"
Content-Disposition: inline
In-Reply-To: <1359695098-3630-1-git-send-email-j-keerthy@ti.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+utxuhC6KVTvgNz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 01, 2013 at 10:34:58AM +0530, J Keerthy wrote:

> +++ b/drivers/regulator/core.c
> @@ -81,6 +81,8 @@ struct regulator {
>  	int uA_load;
>  	int min_uV;
>  	int max_uV;
> +	int curr_min_uV;
> +	int curr_max_uV;

This change makes sense but I don't see why we need to add these to
struct regulator - why not just store the values locally for unwinding?

--m+utxuhC6KVTvgNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOFnAAoJELSic+t+oim9YcwP/2SLP14wPi+VXtWnbbF66a/b
d0+SdBHOmAide/Eoh22J8ui45GotOIcLW7qZqwuiN7IKFHiWMt3MSxtmDdRWwcSx
0+Z2/Tk/Ovis97v1tnfAWTum4M9ulfFzSo2JIGqZbRAy2pkC04TogIEGeqOYihGM
fBc7zI61hnuGnux57ite93ml8jHq1LrozR5jU2jESkktolsBufxoxotUBMM5BZcq
Q269CH1ELY4y+NwmxynP1VO1Smkqx4cuGNEtHfYcH76hPcQUFtY4dDD578WTVTC0
M1xQ/PDXF8SJ11MIX/5+s1pUR2WaXdkLCcWMYwGpe+u6c5KmCksKbbGR146XuO73
Tz3oWBIzonjkPHA7IqVn78XitCDbVIC7pG82Tp4bGq3ZvcTS7CkY9gtcbN4Z5Pfz
M8uFoYkdyaDCNZI2TvvL2qF+FlkKJNiRwhO+tCdFpDqe8wyeH3kijkIBIpJ8CyJI
NnY2UanhAzuZRYoaVeoUKaCRjSddokuJgwQee2pkiKFWwZlvioBG6oP4ZR6YplqN
ZwAJ9WWuCAKX1zkrw4XQkiLMaDnjASjrcnWciy0FlOJ6dMHljJ6OXRIdVbBUnLWJ
x3BmhLMeJWNMXUZVYhXEe1w07a8l4K3jAtDKJ8bROiKtMiJqMMXAHTUtqDc3ModI
zLDuIMxeXqHO2V0/N6Qi
=i5U6
-----END PGP SIGNATURE-----

--m+utxuhC6KVTvgNz--
