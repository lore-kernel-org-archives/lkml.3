Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaDYKNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:13:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaDYKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:13:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        James Bottomley <JBottomley@Parallels.com>
Subject: Re: [PATCH 3.11 052/182] [SCSI] fix our current target reap infrastructure
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
	<1398329507-5911-53-git-send-email-luis.henriques@canonical.com>
	<1398391948.7767.182.camel@deadeye.wl.decadent.org.uk>
Date: Fri, 25 Apr 2014 11:13:29 +0100
In-Reply-To: <1398391948.7767.182.camel@deadeye.wl.decadent.org.uk> (Ben
	Hutchings's message of "Fri, 25 Apr 2014 03:12:28 +0100")
Message-ID: <87a9b9d8dy.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ben Hutchings <ben@decadent.org.uk> writes:

> On Thu, 2014-04-24 at 09:49 +0100, Luis Henriques wrote:
>> 3.11.10.9 -stable review patch.  If anyone has any objections, please le=
t me know.
>>=20
>> ------------------
>>=20
>> From: James Bottomley <JBottomley@Parallels.com>
>>=20
>> commit e63ed0d7a98014fdfc2cfeb3f6dada313dcabb59 upstream.
>>=20
>> This patch eliminates the reap_ref and replaces it with a proper kref.
>> On last put of this kref, the target is removed from visibility in
>> sysfs.  The final call to scsi_target_reap() for the device is done from
>> __scsi_remove_device() and only if the device was made visible.  This
>> ensures that the target disappears as soon as the last device is gone
>> rather than waiting until final release of the device (which is often
>> too long).
>>=20
>> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
>> Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> [...]
>
> This and the next patch were commented "delay backport by 2 months for
> field testing".
>
> Ben.

Thanks Ben.  I'll drop both patches from the 3.11 queue.

Cheers,
=2D-=20
Lu=C3=ADs

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWjVKAAoJENt0rrj9ziT8Zb0P/0pJGHq4MzdJVib0PnUQL3JN
LomTs7mFHkwxHU7aCOR1gi2kth/Mfcjy+30xlAUvy1Whcjm1JAH3F/BxZITzB8sS
NfIyYPF8ZIpb0yIbR99gQZNK18ygTc7d6gr9blh3sGaoVHSr8sObNs1ltMZMJgaV
BA7N7HOLgIw8Hgv6BMsHipXJBFImMQ+D5G1fWNd7ztOssh4gzfSAW5bS8I1qxEv5
FSlUeRSZnPngLYAHguLO+qFYCWQ9NLfrlwSwoUZB149eqrVQ8oRHf4H+bW4j94MI
41gvl+bi1n1RkxsYVZJH+8ymxGD+R5sfpWDsUHscfyyI4ycEHVklBVES4qDp+90s
vOfOJTW6d0QDk2YKhMsGhnz/4diCQO1pBEXzucfX/lF/FkPkn4TK2Rz9pClOqCvr
XrdL9A1dBElWFN7iKhkQpr2T+r1tH7ZToyRaTX93cEQ3FRmYGuLPPjKJFAUuHXUv
jYMcx11ZiMk6jBTbfvBJbzZZypIm1J9fKhg5kWy6CdDb4aEobn7rOxiR/NUsDQiH
Xvd6YPp8kYompMTh7qMS0hrFyGHQ9zNtirbyS2ivMTPYJ3ifOlYVsr6zGmcbvx8k
1DDpkw+as3sh6P6up/zjzXBg6dFyqKk9+uHQe1OINGD4eqHJbGyppD6fvwg2df4D
9LM/sW6Q9K5YNtTGIlLS
=pu68
-----END PGP SIGNATURE-----
--=-=-=--
