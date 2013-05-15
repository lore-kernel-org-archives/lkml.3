Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab3EOOkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759181Ab3EOOkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:40:17 -0400
Message-ID: <51939E49.1040209@redhat.com>
Date: Wed, 15 May 2013 08:40:09 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: allow empty symlink targets
References: <1358427833-3847-1-git-send-email-P@draigBrady.com> <50F8252C.2060404@draigBrady.com> <519381D8.5080206@draigBrady.com>
In-Reply-To: <519381D8.5080206@draigBrady.com>
X-Enigmail-Version: 1.5.1
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2HLSRUJGSTCNUVHKFFPES"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HLSRUJGSTCNUVHKFFPES
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/15/2013 06:38 AM, P=C3=A1draig Brady wrote:
> On 01/17/2013 04:22 PM, P=C3=A1draig Brady wrote:
>> On 01/17/2013 01:03 PM, P=C3=A1draig Brady wrote:
>>> The discussion leading to this is at http://bugs.gnu.org/13447
>>> In summary other systems allow an empty target for a symlink,
>>> and POSIX specifies that it should be allowed?
>>
>> In relation to this, Eric Blake said:
>>
>>> In today's Austin Group meeting, I was tasked to open a new bug that
>>> would state specifically how the empty symlink is resolved; the inten=
t
>>> is to allow both Solaris behavior (current directory) and BSD behavio=
r
>>> (ENOENT).  Meanwhile, everyone was in agreement that the Linux kernel=

>>> has a bug for rejecting the creation of an empty symlink, but once th=
at
>>> bug is fixed, then Linux can choose either Solaris or BSD behavior fo=
r
>>> how to resolve such a symlink.
>>>
>>> It will probably be a bug report similar to this one, which regarded =
how
>>> to handle a symlink containing just slashes:
>>> http://austingroupbugs.net/view.php?id=3D541
>=20
> Following up from http://austingroupbugs.net/view.php?id=3D649
> It seems POSIX will now allow the current Linux behavior of returning E=
NOENT,

Huh?  Linux currently doesn't allow the creation of an empty symlink.
That link mentions the current BSD behavior of returning ENOENT when
resolving such a symlink (that is, what stat() does when chasing through
an empty symlink, provided such a symlink is first created).

> or the Solaris behavior of allowing empty symlink targets.

The point made in that bug report is that Linux is buggy for not
allowing symlink() to create an empty symlink in the first place; once
you allow the creation of an empty symlink, then how to handle such a
symlink in stat() is up to you whether to copy Solaris' or BSD's example.=


--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2HLSRUJGSTCNUVHKFFPES
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJRk55JAAoJEKeha0olJ0Nqo94IAJKlIEOlSKoxzPNU1WEJVGl1
OXoYtzRK3q3pBK9oygDaRJiedntF8TP+3fKYcMujlR6zeu+Y2AqR1muNkpUO4677
aWVd3RuWqduq0b6WG6rme5QQAL/x2A6XQss0GAFr9lIjG0s3OOt9iGPbMGkpG4+0
CiiDOBwtFWx38gq4D6jNJ0AolQYSUkV3ronnuVjqEqeTX1ScB6711bpJRUQROhq2
nPgSxVpuhgwxx8A/oZ2ZOFL1CTSSbtWokKUmoQF17ZIAYo2tAroiNysgDFvS9TPF
eXpblJXcEvNGtKHqKwRJguXFWgCv1crkpjogSEo2JEf4BhwLsVUr3FXlQtHSVdU=
=JKix
-----END PGP SIGNATURE-----

------enig2HLSRUJGSTCNUVHKFFPES--
