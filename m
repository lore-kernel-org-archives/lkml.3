Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaKPRPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 12:15:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43617 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754797AbaKPRPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 12:15:04 -0500
Date: Sun, 16 Nov 2014 18:13:14 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141116171314.GN6414@lukather>
References: <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
 <20141031100522.GA8655@gondor.apana.org.au>
 <20141103093446.GG11263@lukather>
 <20141103103528.GA30154@gondor.apana.org.au>
 <20141106142633.GK2989@lukather>
 <20141106143217.GA3636@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+utxuhC6KVTvgNz"
Content-Disposition: inline
In-Reply-To: <20141106143217.GA3636@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+utxuhC6KVTvgNz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 10:32:18PM +0800, Herbert Xu wrote:
> On Thu, Nov 06, 2014 at 03:26:33PM +0100, Maxime Ripard wrote:
> >=20
> > But you still haven't explain why the driver, while it doesn't handle
> > the user space buffer at any time, should be worried that the data the
> > framework has given him are actually mapped.
>=20
> Encryption is used by IPsec and SKBs can be allocated in highmem.
> algif also exposes all ciphers to user-space memory which can also
> be in highmem.

Ok. We keep going in circles here.

I know that algif handles userspace memory that can be in
highmem. What I don't get, is that just like a *driver* doesn't have
to call copy_from_user, why would it need to call kmap...

That's something that should be in the framework itself, not the
driver. And the argument that most drivers use DMA seems like a broken
assumption.

But hey, you're the one that will maintain this mess, so I guess you
have the final word.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--m+utxuhC6KVTvgNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUaNsqAAoJEBx+YmzsjxAg9vgP+IU8hDK3gJJOytYQo3W3a15a
uhIELk8oJwM13juoNz2ZofzzuuO1ZKyy3vxMl+qnFdcsJvz3eAkMmLF/0D0HXlwC
ORafGw/BIzF9zoUSl99SliSaPsshtbKGS0itpiswbXpvfkFotnDuSwFckVCbhN/K
ez/Jc/uH6LsviGOEzpTa506ISXwpAxE+QpG7e/bcUDxUN66j0Xhz7e9eGhMSQXGu
z494yGS75QB6K1aI/ckaWTZFMhQJCF/5eOCbV/nwG3942xHx5LzB7m6bvo4wKEMR
G10q7FA+SwkKqSdCn+nw7k67Zyt5LWnHk58IdyUUUgoeLYmkdGO5t/kkMtfRA8Ou
lBFR0qDJvNn0x/Xh7szkVqKOeXH/jArk4HHBkJ2frH1HYdIbVwzZk+Zfk/ckm4dX
75JigGIJvMYVDA9+k6Xy+C3yYgPDp9PJYqcqaXQHWxGGIkk9zqPz8qTPKz0NPCX+
IMV19Hb/wlfbTcnNewFqsYwo6wMU+v18odZYkzfEpbywwfpRztHV0NOdCACGa6W3
8ciE+ctUXlulfqAVrSkUPvHQYpsZTaEueVhJI89yiBG9kJTe770dultEH7DjVyRW
ZwpXZglNMhZU2C5o5NOZyMIVOmeGbVSQPTnIFTbPeaem3KyYA43YLH4jt3TVAr19
AxGnRmvnanGdskF7UX4=
=tuhn
-----END PGP SIGNATURE-----

--m+utxuhC6KVTvgNz--
