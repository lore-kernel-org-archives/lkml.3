Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKBWte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:49:34 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKBWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:49:33 -0500
Message-ID: <5456B4F8.1000608@nod.at>
Date: Sun, 02 Nov 2014 23:49:28 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, hch@infradead.org,
        axboe@fb.com, dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <5456A787.5060104@free-electrons.com> <5456AE72.1010409@nod.at> <5456AFEA.6000507@free-electrons.com>
In-Reply-To: <5456AFEA.6000507@free-electrons.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RLADkB1G3OeBfodXpuxBf5DIn5a57ifWP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RLADkB1G3OeBfodXpuxBf5DIn5a57ifWP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 02.11.2014 um 23:27 schrieb Ezequiel Garcia:
> Wow. Where did you run this and on top of what storage device?

nandsim, to make sure that the MTD is not our bottleneck.

> I'm still interested in the memory footprint, UBI is already heavy enou=
gh.

AFAICT blk-mq allocates one struct ubiblock_pdu per device.
As all IO is done via scattergather the memory footprint should be good.
But I'm sure Christoph can tell you the glory details.

>>> I kind of like the negative diffstat, but the code doesn't look clean=
er
>>> or simpler.
>>>
>>> In other words, we need a good reason before we agree on making this
>>> "zen style" driver more complex.
>>
>> After reading my patch again I think we could move ubiblock_read_to_sg=
()
>> to kapi.c or io.c. It is rather generic and maybe we can tun more UBI =
users to
>> scattergather such that less vmalloc()s are needed.
>>
>> This would also make the diffstat nicer...
>>
>=20
> Yes, any additional effort to make the current patch any simpler would
> be great. In its current form it seems rather cumbersome to me.

Why cumbersome? It changes the way the driver works as blk-mq works diffe=
rently.
If you look at other blk-mq conversion patches you'll notice that they al=
l change
a lot.

> If you can re-submit something better and put a more verbose commit log=
,
> I'd really appreciate it :)

First I wait for a review. I'm not sure whether I'm used blk-ml correctly=
=2E

Thanks,
//richard



--RLADkB1G3OeBfodXpuxBf5DIn5a57ifWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUVrT4AAoJEPmeIjfg4UaaJKMP/2cUppM2KAs1iyRAkd5Kbtd/
1yYkCKVzTfQsy3q2CrbjzcRBiMx/KgemdXCfeKSGdMYHnAMWOgb1lPi1+AAg6AcU
sEGFowPELPl60iEfCacLUNZEYVwkgpjP9zUSWQ6f8KYWcEkNUWViKNim8qcy+jiu
OkjeaN5PfvS6CwJ55J4yIsPIWTZmL3P4dZxiUKxAhzoG5AdVDAfyg+SBruMywyjJ
hoXtTLUHzy/wx2YSwfFb/fyzGqHJg/ioAuEMtDvwBzhoWoTBSG8x/9apm3k2UyB6
C9P9ihofDu8c8lpbF8iNxLa57wnFw/mE73VIlmz1+AGB7X+Ox/nr6C4XnM+w0HGr
4rEQW90xG/W0vD4g2I3zLSUawxwvKPpO2Bp+Q9OjaJzQM7C/N1zJkIOsG3nHxtqf
QYQFB28b9Gba59KxOmPJiYU/qtcY5LbKoyRs8A06hP3RxL9orb6DMP9Y5XkND9M1
1yQMPtZtCEnNjsXJnVuWp/e9smbk+1IBFRgp1crvsaqjT18qXcJhI2HKJ8vQMzCq
hSgcoRGbtNsVGDh7QJe/hPpDnnVuKxgCXR6CHJ+uHGAeCOMVH6cSSE+c3Zl3KoXu
XcDBXQlJtYz+S8hjT5HrvKlsxVnkuZTrMOwodJfZe0LlmzaFC1doI24SjlcZ7CUE
t5kQ/BsgGCkMQnCS7zAh
=teV/
-----END PGP SIGNATURE-----

--RLADkB1G3OeBfodXpuxBf5DIn5a57ifWP--
