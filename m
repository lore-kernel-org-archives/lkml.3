Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3B1ARo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:17:44 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:19703 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B1ARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:17:43 -0500
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4lBo2mGrr2y5FyCzOIoND8eg+8rnLDwqmjazdGNPuw=
X-RZG-CLASS-ID: mo05
Message-ID: <512EA21F.1090807@samba.org>
Date: Thu, 28 Feb 2013 01:17:35 +0100
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Chiluk <dave.chiluk@canonical.com>
CC: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Dave Chiluk <chiluk@canonical.com>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com> <512DE8A6.9030000@samba.org> <20130227083419.0af9deaf@corrin.poochiereds.net> <512E8787.6070709@canonical.com> <CAH2r5mvM=OX+F4uqMh_c24DXLxwgRX2UzX3bsYqM00JPzbtjqA@mail.gmail.com> <512E8C31.8070106@canonical.com>
In-Reply-To: <512E8C31.8070106@canonical.com>
X-Enigmail-Version: 1.4.6
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA8F5C99EC5A91F242B2054A9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA8F5C99EC5A91F242B2054A9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 27.02.2013 23:44, schrieb Dave Chiluk:
> On 02/27/2013 04:40 PM, Steve French wrote:
>> On Wed, Feb 27, 2013 at 4:24 PM, Dave Chiluk <dave.chiluk@canonical.co=
m> wrote:
>>> On 02/27/2013 10:34 AM, Jeff Layton wrote:
>>>> On Wed, 27 Feb 2013 12:06:14 +0100
>>>> "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
>>>>
>>>>> Hi Dave,
>>>>>
>>>>>> When messages are currently in queue awaiting a response, decrease=
 amount of
>>>>>> time before attempting cifs_reconnect to SMB_MAX_RTT =3D 10 second=
s. The current
>>>>>> wait time before attempting to reconnect is currently 2*SMB_ECHO_I=
NTERVAL(120
>>>>>> seconds) since the last response was recieved.  This does not take=
 into account
>>>>>> the fact that messages waiting for a response should be serviced w=
ithin a
>>>>>> reasonable round trip time.
>>>>>
>>>>> Wouldn't that mean that the client will disconnect a good connectio=
n,
>>>>> if the server doesn't response within 10 seconds?
>>>>> Reads and Writes can take longer than 10 seconds...
>>>>>
>>>>
>>>> Where does this magic value of 10s come from? Note that a slow serve=
r
>>>> can take *minutes* to respond to writes that are long past the EOF.
>>> It comes from the desire to decrease the reconnection delay to someth=
ing
>>> better than a random number between 60 and 120 seconds.  I am not
>>> committed to this number, and it is open for discussion.  Additionall=
y
>>> if you look closely at the logic it's not 10 seconds per request, but=

>>> actually when requests have been in flight for more than 10 seconds m=
ake
>>> sure we've heard from the server in the last 10 seconds.
>>>
>>> Can you explain more fully your use case of writes that are long past=

>>> the EOF?  Perhaps with a test-case or script that I can test?  As far=
 as
>>> I know writes long past EOF will just result in a sparse file, and
>>> return in a reasonable round trip time *(that's at least what I'm see=
ing
>>> with my testing).  dd if=3D/dev/zero of=3D/mnt/cifs/a bs=3D1M count=3D=
100
>>> seek=3D100000, starts receiving responses from the server in about .0=
5
>>> seconds with subsequent responses following at roughly .002-.01 secon=
d
>>> intervals.  This is well within my 10 second value.
>>
>> Note that not all Linux file systems support sparse files and
>> certainly there are cifs servers running on operating systems other
>> than Linux which have popular file systems which don't support sparse
>> files (e.g. FAT32 but there are many others) - in any case, writes
>> after end of file can take a LONG time if sparse files are not
>> supported and I don't know a good way for the client to know that
>> attribute of the server file system ahead of time (although we could
>> attempt to set the sparse flag, servers can and do lie)
>>
>=20
> It doesn't matter how long it takes for the entire operation to
> complete, just so long as the server acks something in less than 10
> seconds.  Now the question becomes, is there an OS out there that
> doesn't ack the request or doesn't ack the progress regularly.

This kind of ack can only be at the tcp layer not at the smb layer.

metze


--------------enigA8F5C99EC5A91F242B2054A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlEuoiMACgkQm70gjA5TCD9z6gCgs2oLeY/LRp934BskZey5EtEg
ZoEAoIa8EapakViT8R9nn5xlpt646+Qs
=/ZDC
-----END PGP SIGNATURE-----

--------------enigA8F5C99EC5A91F242B2054A9--
