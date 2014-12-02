Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaLBItv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:49:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLBIts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:49:48 -0500
Message-ID: <547D7D29.8000602@canonical.com>
Date: Tue, 02 Dec 2014 09:49:45 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Slava Pestov <sp@datera.io>
CC: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] bcache: prevent crash on changing writeback_running
References: <1408453293-17917-1-git-send-email-stefan.bader@canonical.com> <CACHGV4J8pQM7pt+0NXJL60OJHxMUQu2S9U_DnKFh0BW0=1XpuA@mail.gmail.com>
In-Reply-To: <CACHGV4J8pQM7pt+0NXJL60OJHxMUQu2S9U_DnKFh0BW0=1XpuA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="qdDUVglFDHIE23h9W6HH2rKf98aaXIFaN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qdDUVglFDHIE23h9W6HH2rKf98aaXIFaN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 19.08.2014 20:03, Slava Pestov wrote:
> Thanks, this is now in our development branch.

It has been a while but I just went back there and checked linux and linu=
x-next
but cannot find this change anywhere. I think it is a rather simple bugfi=
x. So I
start to wonder where it went and when it would get pushed.

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



--qdDUVglFDHIE23h9W6HH2rKf98aaXIFaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUfX0pAAoJEOhnXe7L7s6jyCgP/RSClzHGIlrqMrR4P9cYh2We
YYfDduKPwhwuLl6WtmtV05gGClcKXIYhnv62R0Z6E4r6F7b+LtT4XooYYi3gIHHk
GjPetA8EFoVEQD+JSvSVAKiuRAV4QKAHuzNtEbg3h3PRuoOx/2GuP64oM9RSLg/L
Xct421mlpf/xilSLq0KEQPXaUA/3CeyjXd/Z6Wz33gH6v6TPtlOyZAHfWvLOuA7Z
6/ZRegqw8NMnTVOc9CM4Rj6MRVmQYcD4pkF18fIt/DKpJaSDVjXTqSdIVS2k0A4E
POFT530lnC9QfRaaTIEAiCnXJH2fNfnG6ohuK3cTInqbpfPdN87Bf6HyLhO3v9e/
VyNWuyuCi7BTFholZvTSca98ttvkQNN9AqRVjeAkBIvXz+DuupUoyvo1PpIiq6Uk
ni/D13C2y7TMLfPJzJTbb5d7/oETRb5aa8bhxnj0WLzn/EU56nX1ZSdULLx3XVLM
3VMM/yqhNK3qOJ7RhWrhkI+gyvH80/o7+uiGZK61wHZuI/MPU97ZxM38zwzGTAko
PQHWhHSABmaglV7iuQWXe7ASm3wBTVW2/VdNcCz4BxYZteXySilXPhA3nB2Q/eDJ
SPqTiisYYUXl/0oEuAQa+aupAAOZ3ILYnrzKzakCO7RWvQAtXRn17r/FEadPUY/O
DF0d6IQLhAz5JLJSy3P8
=DGMF
-----END PGP SIGNATURE-----

--qdDUVglFDHIE23h9W6HH2rKf98aaXIFaN--
