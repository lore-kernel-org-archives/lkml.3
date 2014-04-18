Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaDRLqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:46:02 -0400
Received: from mail.ovgu.de ([141.44.1.66]:58104 "EHLO mail.ovgu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaDRLp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:45:59 -0400
Message-ID: <53511066.70005@st.ovgu.de>
Date: Fri, 18 Apr 2014 13:45:42 +0200
From: Matthias Graf <matthias.graf@st.ovgu.de>
Organization: student.uni-magdeburg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        alexander.deucher@amd.com
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
References: <532C727F.1080803@st.ovgu.de> <20140321172742.GA2846@pd.tnic> <532C97DF.9010201@st.ovgu.de> <20140321201352.GC1338@pd.tnic> <533069E4.10002@st.ovgu.de> <533C1B47.8080709@st.ovgu.de> <20140416142232.GF16741@pd.tnic> <534F73F6.7050804@st.ovgu.de> <20140417130207.GB4321@pd.tnic> <5350EDAE.8020101@st.ovgu.de> <20140418094523.GB4385@pd.tnic>
In-Reply-To: <20140418094523.GB4385@pd.tnic>
X-Enigmail-Version: 1.6
OpenPGP: id=BE42F9BD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vSVbAG6hjiem04H9E31vN3Ra8aVRApEM4"
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODY_SIZE_5000_5999 0, BODY_SIZE_7000_LESS 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_SPECIFIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTYPE_HAS_BOUNDARY 0, __CTYPE_MULTIPART 0, __FORWARDED_MSG 0, __FRAUD_REFNUM 0, __FW_1LN_BOT_MSGID 0, __HAS_FROM 0, __HAS_MSGID 0, __IN_REP_TO 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __RDNS_POOLED_10 0, __SANE_MSGID 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0'
X-Spam-Score: Gauge=IIIIIIII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vSVbAG6hjiem04H9E31vN3Ra8aVRApEM4
Content-Type: multipart/mixed;
 boundary="------------030004070807030801030602"

This is a multi-part message in MIME format.
--------------030004070807030801030602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I applied your patch to linus' current master (3.15.0-rc1+) and indeed
it does solve the issue for me!

Thanks for your help.

I would appreciated if you keep me posted on updates.

Best,
Matthias

Am 18.04.2014 11:45, schrieb Borislav Petkov:
> On Fri, Apr 18, 2014 at 11:17:34AM +0200, Matthias Graf wrote:
>> Fine-grained bisection result:
>>
>> ab70b1dde73ff4525c3cd51090c233482c50f217 is the first bad commit
>> commit ab70b1dde73ff4525c3cd51090c233482c50f217
>> Author: Alex Deucher <alexander.deucher@amd.com>
>> Date:   Fri Nov 1 15:16:02 2013 -0400
>>
>>     drm/radeon: enable DPM by default on r7xx asics
>>
>>     Seems to be stable on them.
>>
>>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>
>> :040000 040000 f3262029b868df4d882f64b4deba6b9230e307ea
>> 1f1dfca42763703a56e3cc82bb103608a24be94e M	drivers
>>
>>
>> Result is reasonable: I have a RV770 chip.
>=20
> Yes it is.
>=20
>> (Additional) Bug Report for Reference:
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1085785
>>
>> Thanks for the instructions Borislav! At first, I was not completely
>> sure what you expected me to do (this is my first kernel bug report :)=
).
>=20
> And you're doing good so far! :-)
>=20
>> If there is anymore more I can help you with, let me know.
>=20
> Ok, now we want to confirm that this patch is *actually* the culprit by=

> reverting it. Simply pull Linus' master branch to have the latest tree,=

> and then do:
>=20
> $ git checkout -b radeon-revert master
>=20
> so that you land on a throwaway branch where we can play. Then normally=
 you
> would do
>=20
> $ git revert ab70b1dde73ff4525c3cd51090c233482c50f217
>=20
> but that causes conflicts so I did it for you, see below. Simply apply
> this patch ontop *without* doing the revert with git. Then build, boot
> and test. We want to see whether it still generates those ROB timeout
> machine checks. If all looks ok, then we're pretty sure we need to talk=

> about DPM with your GPU on your platform with Alex. :-)
>=20
> Feel free to ask any questions should something be not clear.
>=20
> Thanks.
>=20
> ---
> From 0790e872f6d3c986d9ed36b850fd9d799dc422f9 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Fri, 18 Apr 2014 11:43:12 +0200
> Subject: [PATCH] Revert "drm/radeon: enable DPM by default on r7xx asic=
s"
>=20
> This reverts commit ab70b1dde73ff4525c3cd51090c233482c50f217.
>=20
> Conflicts:
> 	drivers/gpu/drm/radeon/radeon_pm.c
> ---
>  drivers/gpu/drm/radeon/radeon_pm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeo=
n/radeon_pm.c
> index ee738a524639..af693c4746da 100644
> --- a/drivers/gpu/drm/radeon/radeon_pm.c
> +++ b/drivers/gpu/drm/radeon/radeon_pm.c
> @@ -1257,6 +1257,10 @@ int radeon_pm_init(struct radeon_device *rdev)
>  	case CHIP_RV670:
>  	case CHIP_RS780:
>  	case CHIP_RS880:
> +	case CHIP_RV770:
> +	case CHIP_RV730:
> +	case CHIP_RV710:
> +	case CHIP_RV740:
>  	case CHIP_BARTS:
>  	case CHIP_TURKS:
>  	case CHIP_CAICOS:
> @@ -1273,10 +1277,6 @@ int radeon_pm_init(struct radeon_device *rdev)
>  		else
>  			rdev->pm.pm_method =3D PM_METHOD_PROFILE;
>  		break;
> -	case CHIP_RV770:
> -	case CHIP_RV730:
> -	case CHIP_RV710:
> -	case CHIP_RV740:
>  	case CHIP_CEDAR:
>  	case CHIP_REDWOOD:
>  	case CHIP_JUNIPER:
>=20

--------------030004070807030801030602
Content-Type: text/x-patch;
 name="dpmRevert.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dpmRevert.diff"

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/=
radeon_pm.c
index ee738a524639..af693c4746da 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1257,6 +1257,10 @@ int radeon_pm_init(struct radeon_device *rdev)
 	case CHIP_RV670:
 	case CHIP_RS780:
 	case CHIP_RS880:
+	case CHIP_RV770:
+	case CHIP_RV730:
+	case CHIP_RV710:
+	case CHIP_RV740:
 	case CHIP_BARTS:
 	case CHIP_TURKS:
 	case CHIP_CAICOS:
@@ -1273,10 +1277,6 @@ int radeon_pm_init(struct radeon_device *rdev)
 		else
 			rdev->pm.pm_method =3D PM_METHOD_PROFILE;
 		break;
-	case CHIP_RV770:
-	case CHIP_RV730:
-	case CHIP_RV710:
-	case CHIP_RV740:
 	case CHIP_CEDAR:
 	case CHIP_REDWOOD:
 	case CHIP_JUNIPER:

--------------030004070807030801030602--

--vSVbAG6hjiem04H9E31vN3Ra8aVRApEM4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTURBnAAoJELO00SK+Qvm93H8H/1VPew7CYSpoEJDTN+G3GmME
rwcjCK5vZbtmKZpnjBELhJjQ2noaoLTFCp7NmJ5hZcNuR0TxgOa9IKDsg+K3Xaye
RnlT+N+L1JKKePzn5CT377XNsFhhutHHPCDyYjbIDwW7FZU9/YnTTTnpAFqM+vrw
zWfKhcWiYSdpHqvvPiVwXuQ/fOFu0ikGI1J/BZuoosZIE/Dj4EHYseT+SHNzf8ws
jKwb+cGgcAhHC4GRyz684UBfdBJOxmKSK210EmmRxwzr6tnlObiQyeotBUE9Te1i
GNW4qX0tv4nlXYT+3J2anVxUE3HiUPsePEHFgE9O561YTNafNyIe+HGIxdgTR8A=
=yCzb
-----END PGP SIGNATURE-----

--vSVbAG6hjiem04H9E31vN3Ra8aVRApEM4--
