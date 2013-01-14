Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3ANX5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3ANX5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:57:54 -0500
Message-ID: <50F49B7E.50906@redhat.com>
Date: Mon, 14 Jan 2013 16:57:50 -0700
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Backlund <tmb@mageia.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvirt-list@redhat.com
Subject: Re: [libvirt] if_bridge.h: include in6.h for struct in6_addr use
References: <50F2FF1B.3020708@mageia.org> <50F313A5.3020707@mageia.org>
In-Reply-To: <50F313A5.3020707@mageia.org>
X-Enigmail-Version: 1.5.0
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2CKNCDINEWXHVLUWTDLAE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2CKNCDINEWXHVLUWTDLAE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/13/2013 01:05 PM, Thomas Backlund wrote:
> Thomas Backlund skrev 13.1.2013 20:38:
>> patch both inline and attached as thunderbird tends to mess up ...
>=20
>> -----
>>
>> if_bridge.h uses struct in6_addr ip6; but does not include the in6.h
>> header.
>>
>> Found by trying to build libvirt and connman against 3.8-rc3 headers.
>>
>=20
> Ok,
> ignore this patch, it's not the correct fix as it introduces
> redefinitions...
>=20
> Btw, the error that I hit that made me suggest this fix was libvirt
> config check bailing out:
>=20
> config.log:/usr/include/linux/if_bridge.h:173:20: error: field 'ip6' ha=
s
> incomplete type

Hmm, just now noticing this thread, after independently hitting and and
having to work around the same problem in libvirt:
https://www.redhat.com/archives/libvir-list/2013-January/msg00930.html
https://bugzilla.redhat.com/show_bug.cgi?id=3D895141

>> --- linux-3.8-rc3/include/uapi/linux/if_bridge.h        2013-01-13
>> 20:09:54.257271755 +0200
>> +++ linux-3.8-rc3.fix/include/uapi/linux/if_bridge.h    2013-01-13
>> 20:15:04.153676151 +0200
>> @@ -14,6 +14,7 @@
>>   #define _UAPI_LINUX_IF_BRIDGE_H
>>
>>   #include <linux/types.h>
>> +#include <linux/in6.h>
>>

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2CKNCDINEWXHVLUWTDLAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJQ9Jt+AAoJEKeha0olJ0Nqn1sH/2QgflI38ZZg8GVqA0F2NfKs
E+EYVZ6YqVfoD4iTZkFsrXO/1qnCb7UTqdFgaAnqPToPBLy84ktZukFBJ0LpYWdE
4FaFC+3lAF4bYPWt3S0Cnk1+yF38EQ36/IGjO5qXfvKKHUIWc6iHEVkYNCQSh+qI
KLl7DSsxL7eJc3Ixg3/UpNw7k7ggW9atfb/NZWAelmcHwfyWs5wAnamz8/AeFvnk
83N3e/ficntK2GJW9r0VOc/2mDq4H81/o5uoBCUVr1YpbVghOplp1L9iGOPNwqGp
BW50YXQFQzh/zXBtWS9oDfqxS7gnZUrMMYFWkNgnp6PMk2TOVkYWHl7MQ+6CyO4=
=Tun9
-----END PGP SIGNATURE-----

------enig2CKNCDINEWXHVLUWTDLAE--
