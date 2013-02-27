Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3B0LMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:12:23 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:17422 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3B0LMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:12:21 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 06:12:21 EST
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4lBo2mGrr2y5FyCzOIoND8eg+8rnLDwqmjazdGNPuw=
X-RZG-CLASS-ID: mo05
Message-ID: <512DE8A6.9030000@samba.org>
Date: Wed, 27 Feb 2013 12:06:14 +0100
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Chiluk <chiluk@canonical.com>
CC: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
In-Reply-To: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
X-Enigmail-Version: 1.4.6
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BE9327F652E0EF9B90395E1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BE9327F652E0EF9B90395E1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Dave,

> When messages are currently in queue awaiting a response, decrease amou=
nt of
> time before attempting cifs_reconnect to SMB_MAX_RTT =3D 10 seconds. Th=
e current
> wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERV=
AL(120
> seconds) since the last response was recieved.  This does not take into=
 account
> the fact that messages waiting for a response should be serviced within=
 a
> reasonable round trip time.

Wouldn't that mean that the client will disconnect a good connection,
if the server doesn't response within 10 seconds?
Reads and Writes can take longer than 10 seconds...

> This fixes the issue where user moves from wired to wireless or vice ve=
rsa
> causing the mount to hang for 120 seconds, when it could reconnect cons=
iderably
> faster.  After this fix it will take SMB_MAX_RTT (10 seconds) from the =
last
> time the user attempted to access the volume or SMB_MAX_RTT after the l=
ast
> echo.  The worst case of the latter scenario being
> 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130 secon=
ds).
> Statistically speaking it would normally reconnect sooner.  However in =
the best
> case where the user changes nics, and immediately tries to access the c=
ifs
> share it will take SMB_MAX_RTT=3D10 seconds.

I think it would be better to detect the broken connection
by using an AF_NETLINK socket listening for RTM_DELADDR
messages?

metze


--------------enig5BE9327F652E0EF9B90395E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlEt6KoACgkQm70gjA5TCD+2JgCdHpfZdm+EiffVKKpb+5EDWlay
QtsAoIgq32yYqMQqWosNZf04SHW8J/Ur
=B+VR
-----END PGP SIGNATURE-----

--------------enig5BE9327F652E0EF9B90395E1--
