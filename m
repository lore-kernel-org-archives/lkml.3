Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3AaINN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:13:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3AaINK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:13:10 -0500
Date: Thu, 31 Jan 2013 09:13:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] dma: pl330: Convert to devm_ioremap_resource()
Message-ID: <20130131081305.GB3171@avionic-0098.mockup.avionic-design.de>
References: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
 <20130131072808.GA2041@avionic-0098.mockup.avionic-design.de>
 <CAK9yfHy3qV1b5c586ToHONBu3BQdkdM4hYbvJcofZ=kL70rZjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <CAK9yfHy3qV1b5c586ToHONBu3BQdkdM4hYbvJcofZ=kL70rZjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:F0uMLAvphNXtCtV7r6PIwYx9bwz4vP9ge7veWFUQGJZ
 kzS6bX+qx+dJ5I2UUEhkESgrOW1ZgwFxbR8ofJUYF7BohniyYs
 fn1y0Oszb4RU4yVLoOYmvK87DsUF9Ww/mULVzvNQfnbzDox6F1
 KyXd77u5P702zmsFMq++vmzrW9rkQP0g+RW61tmNuXapi2bJ85
 Bfdo07f1Uo3vsfRb1gI8uoOajGXGTLAnXtQeF16e3Ja1Nwh2yn
 ewOlbnItS4T6PXpNqeyNJljr54QgVmH98UNuan2gXtlfCao6UT
 AXigWwHcGyHlgmGmCKxhaElLl9YczE5GYgzk+gIUIsK//VsG5Z
 xz0gykhDzjKeXJKufcWYveB1D5VKHf52tXa2BBKDOYrOunem3s
 6DIvewL7PxOmq56jKht3gzc0GeX1bEOlgY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 01:39:59PM +0530, Sachin Kamat wrote:
> On 31 January 2013 12:58, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Thu, Jan 31, 2013 at 12:37:04PM +0530, Sachin Kamat wrote:
> >> Use the newly introduced devm_ioremap_resource() instead of
> >> devm_request_and_ioremap() which provides more consistent error handli=
ng.
> >>
> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> >> Cc: Vinod Koul <vinod.koul@intel.com>
> >> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> ---
> >> This change is based against linux-next tree (20130128).
> >> This change however introduces the followign sparse warning:
> >> drivers/dma/pl330.c:2883:22: warning: incorrect type in argument 1 (di=
fferent address spaces)
> >> drivers/dma/pl330.c:2883:22:    expected void const *ptr
> >> drivers/dma/pl330.c:2883:22:    got void [noderef] <asn:2>*base
> >> drivers/dma/pl330.c:2884:34: warning: incorrect type in argument 1 (di=
fferent address spaces)
> >> drivers/dma/pl330.c:2884:34:    expected void const *ptr
> >> drivers/dma/pl330.c:2884:34:    got void [noderef] <asn:2>*base
> >
> > Yes, those are false positives. They can be fixed with the two patches I
> > posted a few hours ago, starting here:
> >
> >         https://lkml.org/lkml/2013/1/30/455
>=20
> OK. That's great.
> >
> > Note that the first patch is against sparse. The problem, in a nutshell,
> > is that sparse complains that the pointer address spaces and noderef
> > attributes differ. In the case of the IS_ERR() function and friends the
> > attributes aren't relevant because only the pointer value is only used
> > arithmetically. Unfortunately there is no way you can cast away these
> > attributes without causing other warnings, so the solution is somewhat
> > more complex.
>=20
> Thanks for the explaination.
> However, is the patch for the dma relevant?

Yes, I forgot to add my Reviewed-by. Done now.

Thierry

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCieRAAoJEN0jrNd/PrOh9rcP/1zye52YG4Q0LPwAmVuOgqHY
BUbez/KFd6R65TK9gZEX0kgOeH+XPRur/kTD6qHase+SyuDlXRAURlIUKg5M3rwa
bGeVOE/1UNSU7kq+j1o6NG7AqmE2m6ZgI+wz8AJxuIRWkYRX2fqH3crOqwVkK/Mc
gIeTFxShjclY9WjhENc9rfULJlImC/ra2waH93Gbx2Q2sQdqApnz5b0HZ/wLFRz5
t+O84wVlgyVgDIBCcvCuYUaWRaqNAkoqaK5D4MH2cLHjtLib8S3bOsP4hwhztmd0
X86/oZa5dHXfm9EJhVgXb5L2UfZRaxHE0buqGIXmgI3ywqDiCnIMh2wtw8CwXxhR
2Aa7PW8UlJd3RFeh6QlOgULdoShbsK+iEXeDDF8W70Pu8cQGEBKjHWW70eCwZWHe
ZUc/dVF5suX34wWC3ENgiF7ACQGafB4zrGQsS3aIqkVInqE6ediKu6lV1UyvnOrv
LyxL3yjvxzYGIILiJUQL2WVDz1ACvpOcfL3ji2xJnVk+F+cUiB+QEVIGd58BDsPJ
XypOpC7d1ctyEL6QM2kfnOHJHb4DF7Mm/PK+ulz+WXFZCZPADVGZegUMqQDog5e4
5IaeODywsPnp/SoLZbvilvtF/4MpfhfgBjuSp/MJ5mnBlqKeCNRPVYJ5DlWTMf8M
uSC9qU+SSmCCoN2DhamB
=YpKH
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
