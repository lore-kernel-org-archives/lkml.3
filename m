Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaHUH5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:57:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33901 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaHUH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:57:08 -0400
Message-ID: <53F5A648.6060904@canonical.com>
Date: Thu, 21 Aug 2014 09:56:56 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Slava Pestov <sp@datera.io>
CC: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] bcache: prevent crash on changing writeback_running
References: <1408453293-17917-1-git-send-email-stefan.bader@canonical.com> <CACHGV4J8pQM7pt+0NXJL60OJHxMUQu2S9U_DnKFh0BW0=1XpuA@mail.gmail.com>
In-Reply-To: <CACHGV4J8pQM7pt+0NXJL60OJHxMUQu2S9U_DnKFh0BW0=1XpuA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Gt1dHuxcd41p5h4tfoN4VresMqljECsjO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Gt1dHuxcd41p5h4tfoN4VresMqljECsjO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 19.08.2014 20:03, Slava Pestov wrote:
> Thanks, this is now in our development branch.

Thanks. :) This kind of brings up another question: how are stable patche=
s
handled for bcache. Someone handling them centrally like for the network =
stack
or tagging for stable and if that missed, individual proposals?

I am asking because it looks like for all kernels between 3.13..3.16 (inc=
lusive)
the set of

a664d0f05a2ec02c8f042db536d84d15d6e19e81
  bcache: fix crash on shutdown in passthrough mode
9e5c353510b26500bd6b8309823ac9ef2837b761
  bcache: fix uninterruptible sleep in writeback thread

plus the one I did would be useful. Right now I only tested with 3.13 wit=
h those
and at least avoid the lockdep warnings and crashes I saw before. I only =
see an
unexplainable load of 1 when idle but having one bcache device configured=
 in a
VM (Xen or KVM). Since writeback should be fixed, maybe gc...

-Stefan
>=20
> On Tue, Aug 19, 2014 at 6:01 AM, Stefan Bader
> <stefan.bader@canonical.com> wrote:
>> commit a664d0f05a2ec02c8f042db536d84d15d6e19e81
>>     bcache: fix crash on shutdown in passthrough mode
>>
>> added a safeguard in the shutdown case. At least while not being
>> attached it is also possible to trigger a kernel bug by writing into
>> writeback_running. This change  adds the same check before trying to
>> wake up the thread for that case.
>>
>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>> ---
>>  drivers/md/bcache/writeback.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeba=
ck.h
>> index 0a9dab1..073a042 100644
>> --- a/drivers/md/bcache/writeback.h
>> +++ b/drivers/md/bcache/writeback.h
>> @@ -63,7 +63,8 @@ static inline bool should_writeback(struct cached_de=
v *dc, struct bio *bio,
>>
>>  static inline void bch_writeback_queue(struct cached_dev *dc)
>>  {
>> -       wake_up_process(dc->writeback_thread);
>> +       if (!IS_ERR_OR_NULL(dc->writeback_thread))
>> +               wake_up_process(dc->writeback_thread);
>>  }
>>
>>  static inline void bch_writeback_add(struct cached_dev *dc)
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--Gt1dHuxcd41p5h4tfoN4VresMqljECsjO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT9aZRAAoJEOhnXe7L7s6jn3gP/1LEAcf81q6w1/3Uz0noWiSw
8yEhKclYc3ZbkIPb1dhVAASA0FpqQMSXWc3uKZNQnI3zjlnQyVwdICHPgVtkY7uT
WkYV4X3fYzvnKDvEKVENxBJitk8NG5XKcvdmuxKy16NV8X0vJk9LukNzDPvIE2hT
eoXyXA9JwFPY65oXJiX7Q8s7yjHs7Ja7+iHmWQiaeyF9XKGHg4Ad+GHBA7EGtIGf
xivLn/jYCJcPu+A0CmvSD084k54BDviFbsGGiLbSbkhLFrubA2jM0tH2FdoxJzTf
wOBUcY3Lvk0oHgffq8e+gV3zz92rpFcLUMDVLoCE1MoyBfTZJenyXv9WBKKwcPzE
lDmIqDMG9sbKGMvCgqIgBuL/Lbq8Cn4wAv4677uDZG0w6eLDzRSF3g/Z13mZCjyh
qXFTMhH6AKhYKwwaoaNP3kQiXdPlVWfLgLxKngvihj5q9pPIO9woJ5hUbWqNLKq+
6J0BIMkj7UZBnrUsD80+eXTA7XzboG72hMg6iniJydZYt6l+a9z6QehqbEKkOUKR
F+DU27+zVRr4VmqggLAXW5t9CkIKzR0LcQyg2aqprGuwLnP1nrC1BNtx5D+s+wtI
SUbADRLfBE7KjbdPSGOevM9BLttMMy4++j+zJP9hUZCrheV9Lv10sMcNTzScoXlQ
HbU7gaQ+40zoDx1QpOdB
=bTwn
-----END PGP SIGNATURE-----

--Gt1dHuxcd41p5h4tfoN4VresMqljECsjO--
