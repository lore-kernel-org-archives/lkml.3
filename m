Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936613Ab3DIWpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:45:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34637 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645Ab3DIWpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:45:15 -0400
Message-ID: <1365547506.5814.36.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 097/102] efivars: explicitly calculate length of
 VariableName
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        Josh Boyer <jwboyer@redhat.com>, Michael Schroeder <mls@suse.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Matt Fleming <matt.fleming@intel.com>
Date: Tue, 09 Apr 2013 23:45:06 +0100
In-Reply-To: <1365414657-29191-98-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
	 <1365414657-29191-98-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o7gklyjIjDDu+ZPagIUe"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e0f7:a9f9:4e26:347a
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o7gklyjIjDDu+ZPagIUe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-08 at 10:50 +0100, Luis Henriques wrote:
> 3.5.7.10 -stable review patch.  If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Matt Fleming <matt.fleming@intel.com>
>=20
> commit ec50bd32f1672d38ddce10fb1841cbfda89cfe9a upstream.
>=20
> It's not wise to assume VariableNameSize represents the length of
> VariableName, as not all firmware updates VariableNameSize in the same
> way (some don't update it at all if EFI_SUCCESS is returned). There
> are even implementations out there that update VariableNameSize with
> values that are both larger than the string returned in VariableName
> and smaller than the buffer passed to GetNextVariableName(), which
> resulted in the following bug report from Michael Schroeder,
>=20
>   > On HP z220 system (firmware version 1.54), some EFI variables are
>   > incorrectly named :
>   >
>   > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
>   > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
>   > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
>   > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098=
032b8c
>   > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-0=
0e098032b8c
>=20
> The issue here is that because we blindly use VariableNameSize without
> verifying its value, we can potentially read garbage values from the
> buffer containing VariableName if VariableNameSize is larger than the
> length of VariableName.
>=20
> Since VariableName is a string, we can calculate its size by searching
> for the terminating NULL character.
>=20
> Reported-by: Frederic Crozat <fcrozat@suse.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Michael Schroeder <mls@suse.com>
> Cc: Lee, Chun-Yi <jlee@suse.com>
> Cc: Lingzhu Xiang <lxiang@redhat.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> [ Backported for 3.4-stable. Removed workqueue code added in a93bc0c 3.9-=
rc1. ]
[...]

I thought the workqueue addition was a worthwhile fix in its own right,
so for 3.2.y I cherry-picked that as well.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-o7gklyjIjDDu+ZPagIUe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUWSZ8ue/yOyVhhEJAQrkJBAAnVIauoF9C97UH/MuOnLTBfuiB1d/tLH3
w7q53oaq6smxNHbhH4RnwCLIIUK7B4ICOEjPhpZ90/RQHRGUSs53bTha780NpcN4
gp9G7DLeUNReFC7cJc/H8xiHsUkuJ1UqYUQ1hJV7ksU71NZBv61nVoWX14zyEyjR
WPTfNc8SK3WRDIMqYo3vrlkEpxKd1yb0xwQQXQxTrjtrH6dtYS45vuTOs2lkPQIo
QjJIWbsnGa1xkKryhaw3iE89LeIazy63LskrCawKohR3kfg58s1+P/U75//qWmx1
q/OcIVArzzqbD/FgGzSu/QOcik5aOIjlSCqXOMwFS8skFyg+Xrh67+7Kcr+8KcPh
S85UpPXXop8s+SatY86JfFdoMxRvYwfnyhs9yQ1VQI+3HrsRjxwZvJgO2lNbw/ae
T3O/i3iyFE+vI5gviiS/JoklWogZqA5FwGan9orXraaGxFtWvxiRFh71R0leLuPG
O2LX2hQwgitVFtEb8ayqChcF9scHMGh3EHY/XywghoDPiJqHuMLFVNzNUfJ7oPJx
qMZXvEMKhaVYFS85gBYbXmWizMn9bzNLOv0cz/e0A1cMlEENZUIEXov6pGSho+gQ
ROoN1cDY+ufCmvzw4kylrmsk0WWk8Yy/0ERjIkHqT+Hh3ZYL0pXZphe4gsCHldZw
aiO1p/dVhNk=
=YlKB
-----END PGP SIGNATURE-----

--=-o7gklyjIjDDu+ZPagIUe--
