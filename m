Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbaLLKzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:55:37 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:53560 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933987AbaLLKzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:55:35 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 12 Dec 2014 10:55:33 +0000
Message-ID: <548AC9A4.5020802@imgtec.com>
Date: Fri, 12 Dec 2014 10:55:32 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sifan Naeem <Sifan.Naeem@imgtec.com>,
        "mchehab@osg.samsung.com" <mchehab@osg.samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>
Subject: Re: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com> <1417707523-7730-4-git-send-email-sifan.naeem@imgtec.com> <5485DD40.60500@imgtec.com> <A0E307549471DA4DBAF2DE2DE6CBFB7E49564260@hhmail02.hh.imgtec.org>
In-Reply-To: <A0E307549471DA4DBAF2DE2DE6CBFB7E49564260@hhmail02.hh.imgtec.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="oHLHVrpXtAkm3xO5W9uKSkDB67Xch045H"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oHLHVrpXtAkm3xO5W9uKSkDB67Xch045H
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Sifan,

On 11/12/14 18:54, Sifan Naeem wrote:
>>> +/*
>>> + * Timer function to re-enable the current protocol after it had bee=
n
>>> + * cleared when invalid interrupts were generated due to a quirk in
>>> +the
>>> + * img-ir decoder.
>>> + */
>>> +static void img_ir_suspend_timer(unsigned long arg) {
>>> +	struct img_ir_priv *priv =3D (struct img_ir_priv *)arg;
>>> +
>>> +	img_ir_write(priv, IMG_IR_IRQ_CLEAR,
>>> +			IMG_IR_IRQ_ALL & ~IMG_IR_IRQ_EDGE);
>>> +
>>> +	/* Don't set IRQ if it has changed in a different context. */
>>
>> Should you even be clearing IRQs in that case? Maybe safer to just tre=
at that
>> case as a "return immediately without touching anything" sort of situa=
tion.
>>
> don't have to clear it for this work around to work, so will remove.
>=20
>>> +	if ((priv->hw.suspend_irqen & IMG_IR_IRQ_EDGE) =3D=3D
>>> +				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
>>> +		img_ir_write(priv, IMG_IR_IRQ_ENABLE, priv-
>>> hw.suspend_irqen);
>>> +	/* enable */
>>> +	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl); }

To clarify, I was only referring to the case where the irq mask has
changed unexpectedly. If it hasn't changed then it would seem to make
sense to clear pending interrupts (i.e. the ones we've been
intentionally ignoring) before re-enabling them.

When you say it works without, do you mean there never are pending
interrupts (if you don't press any other buttons on the remote)?

Cheers
James


--oHLHVrpXtAkm3xO5W9uKSkDB67Xch045H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUismkAAoJEGwLaZPeOHZ6xeQP+wY9vPK/I8cu3ToqexrVpPkF
ep/gPutNBXMyPN1GWScpmLnIb8t8biAvrVwNf9aoXmv0OdOq+luhv2/pZC+WRcSq
MoaSM8hgvBmajU1KM+n1nlHfa7StPwHXzwIpbvDLXTgVY0XmLucr0M38gBnOAlCW
JvYg7ZZl/hMOcpBwerk9QdQ7SE5xH/0mW4gFioDi2mXsGtrZTzOCPfwKindEkK3G
CO8iVCI5hpHlRvw8KcIjz3z8hm/txx17liyvNJSL+6ZybdFAAjxfOgaz2sqPu9hl
fGoQZtGrbAX/iI6pjm2yADlYI06zMV9yD+KTnxkj7nERjfSARJwr2+kL3u7qgw7f
ymSy84XGSVRVUi/tgyh4FJcCLwmcDC0XGZP9Tl0vtlUE9PU7rVhs5WLcUrcPiPbY
EL7D5Hif4ITACbQwNMlOXybF6xdx5Eu6HZvEr8G4mJpJPfMFl3Pj0rZAnylov3WO
dcpJNbyYmxQoIyZ7stKtN3BEOyhD2iDMeh3EmODVYHxa5uy4FlH/Pm7AynbV+VzN
F3FC6D3Y/K648mIdCv5lPzQGtDEaeyi3BABgzS/dNxs5tLMRwtfqrrx6ogC+mTRu
zs9pVCOETun2hXH165zd+p6lJ++PpPKrtAAyixduud+1tK8ggMeMP1lGvyaBOR64
BROO8nGgQvFUwkTFipdj
=wHwg
-----END PGP SIGNATURE-----

--oHLHVrpXtAkm3xO5W9uKSkDB67Xch045H--
