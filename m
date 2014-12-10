Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaLJNtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:49:55 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34719 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836AbaLJNtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:49:52 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        ext4 development <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING2...
In-Reply-To: <871toikt7c.fsf@openvz.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org> <871toikt7c.fsf@openvz.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 10 Dec 2014 16:49:18 +0300
Message-ID: <87zjavehsx.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hello. Someone please take care of this patch.

W/o that patch unprivileged user may abuse system resources simply by spawn=
ing
wast number of unkilable busyloops (works on ext2/ext3):

truncate --size 1T test
for ((i=3D0;i<1024;i++))
do
       filefrag test > /dev/null &
done

Dmitry Monakhov <dmonakhov@openvz.org> writes:
> Andrew can you please get this patch. IMHO it is simple and clean.
> BTW:
>
>> __generic_block_fiemap may spin very long time for large sparse files.
>>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/ioctl.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ioctl.c b/fs/ioctl.c
>> index 8ac3fad..6fbeb68 100644
>> --- a/fs/ioctl.c
>> +++ b/fs/ioctl.c
>> @@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode *inode,
>>  				past_eof =3D true;
>>  		}
>>  		cond_resched();
>> +		if (fatal_signal_pending(current)) {
>> +			ret =3D -EINTR;
>> +			break;
>> +		}
>> +
>>  	} while (1);
>>=20=20
>>  	/* If ret is 1 then we just hit the end of the extent array */
>> --=20
>> 1.7.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUiE9eAAoJELhyPTmIL6kBa5wH/2kIcEhdOeo2/zSozyqI3rNi
2j0y3jeyVLICgfyMu46xkyZyE4aqpMSN/eOmPtQzsnVOOGKiInHMP0x3Lb8ZQrLV
w6ZzmWq8+62LaJ6INkdLIXHLHsI224GvfiVlfnjxgijvs23m0v1hG6G2Yt27+Vnf
bCoMINOKVdDpc12auUPWFxmaCepNw80bb68STMs7LXl3uQatt6ait4s4zuEj/x1K
+pnLFdWQfySDGATvouNfRszNq+n51rV5125uN44v1XhEgcA1X49DOc8YMYEarX7I
HRZaXWCSZOLkbv/Fow+NVwnIhV/gbyc6dCxF3/hkquQaaKxH4iDhskiIJMHRrww=
=aLYz
-----END PGP SIGNATURE-----
--=-=-=--
