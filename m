Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbbAEJoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:44:30 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:27304 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133AbbAEJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:44:25 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 05 Jan 2015 09:44:23 +0000
Message-ID: <54AA5CEE.9050205@imgtec.com>
Date: Mon, 5 Jan 2015 09:44:14 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arch@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH repost 09/16] metag/uaccess: fix sparse errors
References: <1419499661-8566-1-git-send-email-mst@redhat.com> <1419499661-8566-10-git-send-email-mst@redhat.com> <54A6BC0E.50008@imgtec.com> <20150104105218.GA3208@redhat.com>
In-Reply-To: <20150104105218.GA3208@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="1GboLjus2fDQsPwR74cKSfuvli9oeWQX7"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1GboLjus2fDQsPwR74cKSfuvli9oeWQX7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/01/15 10:52, Michael S. Tsirkin wrote:
> On Fri, Jan 02, 2015 at 03:41:02PM +0000, James Hogan wrote:
>> Hi,
>>
>> On 25/12/14 09:29, Michael S. Tsirkin wrote:
>>> virtio wants to read bitwise types from userspace using get_user.  At=
 the
>>> moment this triggers sparse errors, since the value is passed through=
 an
>>> integer.
>>>
>>> Fix that up using __force.
>>
>> I still see these sparse warnings with metag even with your patch:
>>
>>   CHECK   drivers/vhost/vhost.c
>> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio3=
2
>> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio1=
6
>> drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio1=
6
>>
>> Which something like the following hunk fixes in a similar way to your=
s:
>>
>> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm=
/uaccess.h
>> index 0748b0a97986..594497053748 100644
>> --- a/arch/metag/include/asm/uaccess.h
>> +++ b/arch/metag/include/asm/uaccess.h
>> @@ -112,13 +112,17 @@ do {                                            =
                \
>>  	retval =3D 0;                                             \
>>  	switch (size) {                                         \
>>  	case 1:								\
>> -		retval =3D __put_user_asm_b((unsigned int)x, ptr); break;	\
>> +		retval =3D __put_user_asm_b((__force unsigned int)x, ptr); \
>> +		break;							\
>>  	case 2:								\
>> -		retval =3D __put_user_asm_w((unsigned int)x, ptr); break;	\
>> +		retval =3D __put_user_asm_w((__force unsigned int)x, ptr); \
>> +		break;							\
>>  	case 4:								\
>> -		retval =3D __put_user_asm_d((unsigned int)x, ptr); break;	\
>> +		retval =3D __put_user_asm_d((__force unsigned int)x, ptr); \
>> +		break;							\
>>  	case 8:								\
>> -		retval =3D __put_user_asm_l((unsigned long long)x, ptr); break; \
>> +		retval =3D __put_user_asm_l((__force unsigned long long)x, ptr); \
>> +		break;							\
>>  	default:							\
>>  		__put_user_bad();					\
>>  	}=09
>>
>> As far as I understand it, using __force on the value (as opposed to t=
he
>> pointer) is safe here, in the sense of not masking any genuine defects=
=2E
>> Do you agree? Do you want to apply that hunk with your patch too?
>=20
> what about this code:
>              u16 v =3D 0;
>              int rc =3D get_user(v, (__force __le16 __user *)p);
>=20
> it should trigger a warning, does it?

No, but it didn't previously either, and doesn't seem to with x86_64 eith=
er.

I tried __be16 too, since I presume you're referring to a discrepancy
between the native byte order of v (u16) and the foreign byte order of
*p (__be16)?

Cheers
James

>=20
>=20
>=20
>> Note, this change also suppresses warnings for writing a pointer to
>> userland due to the casts to unsigned int / unsigned long long, such a=
s
>> the following (each 4 times due to 4 cases above):
>>
>> kernel/signal.c:2740:25: warning: cast removes address space of expres=
sion
>> kernel/signal.c:2747:24: warning: cast removes address space of expres=
sion
>> kernel/signal.c:2760:24: warning: cast removes address space of expres=
sion
>> kernel/signal.c:2761:24: warning: cast removes address space of expres=
sion
>> kernel/signal.c:2775:24: warning: cast removes address space of expres=
sion
>> kernel/signal.c:2779:24: warning: cast removes address space of expres=
sion
>> kernel/signal.c:3202:25: warning: cast removes address space of expres=
sion
>> kernel/signal.c:3225:17: warning: cast removes address space of expres=
sion
>> kernel/futex.c:2769:16: warning: cast removes address space of express=
ion
>>
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>  arch/metag/include/asm/uaccess.h | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/as=
m/uaccess.h
>>> index 0748b0a..c314b45 100644
>>> --- a/arch/metag/include/asm/uaccess.h
>>> +++ b/arch/metag/include/asm/uaccess.h
>>> @@ -135,7 +135,7 @@ extern long __get_user_bad(void);
>>>  ({                                                              \
>>>  	long __gu_err, __gu_val;                                \
>>>  	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
>>> -	(x) =3D (__typeof__(*(ptr)))__gu_val;                     \
>>> +	(x) =3D (__force __typeof__(*(ptr)))__gu_val;                     \=

>>
>> Can you adjust the position of the \ to line up please
>>
>>>  	__gu_err;                                               \
>>>  })
>>> =20
>>> @@ -145,7 +145,7 @@ extern long __get_user_bad(void);
>>>  	const __typeof__(*(ptr)) __user *__gu_addr =3D (ptr);		\
>>>  	if (access_ok(VERIFY_READ, __gu_addr, size))			\
>>>  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
>>> -	(x) =3D (__typeof__(*(ptr)))__gu_val;                             \=

>>> +	(x) =3D (__force __typeof__(*(ptr)))__gu_val;                      =
       \
>>
>> same here (this one causes a checkpatch error due to 80 column limit)
>>
>>>  	__gu_err;                                                       \
>>>  })
>>> =20
>>>
>>
>> With those changes,
>> Acked-by: James Hogan <james.hogan@imgtec.com>
>>
>> Cheers
>> James
>>
>=20
>=20


--1GboLjus2fDQsPwR74cKSfuvli9oeWQX7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUqlz1AAoJEGwLaZPeOHZ68q0QALx1pLxBsFB3QM8N7/cY7OVq
AG5e4nJueWbnhc1pcar+EvLIfDY+K7Qo1pv7OXV52HqO6ZTZmTmTEnlN7Za5TIGT
EW6urGwzv5GM0kisWSVp8JdrEL23MhBw7V4nvojRYVh5ZmYiTl//A7JIHt5Ydls1
rdOGfGGk8VUQD+FkcrcdJ3Ic+ff+DnoNAN9iahOdUOq/MWbrT6Db721azM8ls8yr
QgEe8NkBkJu5S8nzCGR4y3onYsdtrHosjSMp6XnHKYH2yTa79hUT9ARY3Fr525ut
9sJLsnAcYobT7lmN9pbTGNvoqIVRHOw8/ZKBrGlJk4a5uDoyFTTzGU5Y80VzFNbx
2lHAomvR6ta9hacfyd/B8mq92g2wBNFLy9Rx4fXSlkxEG6Ux3S/3jqvTqg2Ywcs9
VJXkX4/xq6eKIUh4Sz5K65nPR3MrvFWt79XstWR2HSRvE8z4zmPpeEVQhD9r0fnR
b+8eAWUD1991RRdk11XpEMDH+ZxkEKCf619tIb3SxoyYyr288S7G+bb/SDJq55yX
wNlQEz8JIeyo4bQmZDxiNMGjncLbVTJH7ECHgrWO10x+IPcrOeoTCZPSNVJFdQfh
szurniONBAbgxxDrsROJw/eLfp3BOGhAiq8wGZQcLWCDg0TdAvDspqCYjIOoLd2X
3rV61cHM5hiBx+jSJM58
=mQsg
-----END PGP SIGNATURE-----

--1GboLjus2fDQsPwR74cKSfuvli9oeWQX7--
