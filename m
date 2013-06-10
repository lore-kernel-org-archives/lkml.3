Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3FJACx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:02:53 -0400
Received: from sauhun.de ([89.238.76.85]:54660 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab3FJACw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:02:52 -0400
Date: Mon, 10 Jun 2013 02:04:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] pwm: devm: alloc correct pointer size
Message-ID: <20130610000446.GA2928@katana>
References: <1370291306-3276-1-git-send-email-wsa@the-dreams.de>
 <CAHp75Vcvhz892D4gytneptB4wLWPjfKmf5OXgnChXw338nLBAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <CAHp75Vcvhz892D4gytneptB4wLWPjfKmf5OXgnChXw338nLBAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2013 at 10:43:41PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 3, 2013 at 11:27 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > The allocated object should be the size of what the pointer is pointing
> > to and not the size of the pointer itself.
>=20
> All devm_* functions in this module use **ptr as a parameter (except
> allocation).
> May be we first should understand why it so?

Huh? **ptr is already created on the stack, but assigned the alloced
memory. Later, the mem it points to is set to 'pwm' which is then added
to devres. So, the alloced memory must be able to contain '*ptr' (or
*pwm which would be more readable IMO, but other subsystems also stick
to *ptr), no?


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRtRgeAAoJEBQN5MwUoCm2dwMP/icQJldmh/mBSpa1rP7LMX9Y
JcTnW031AOs2d+1Bmq5YOi7BSfDDNS+fmVlsRVggZOIMq1aMKJtx/VjLWLreCxHq
BbtSt24x5Yqjzxplv0ATXftx1ZZSU3N0vPeK+t5paoZsnkoec5rWAF8g+ASxkjie
Blrjd8Vr0I+uLyYrvIp0wkaGZSzPYNI5zlW9TwY8cjwgypo3BLhn+lOaFVPMCojc
/Q923r6SHfGBFfbclgN4gZ/yl6g04ZcJEZw40DgThMQKMdovyWcohk+DdP5MFHcq
53BG+vR7mnbGNODo4chzGStc5zWz8iSdL4bsI2pGum5DjD5VB/95sHcZg5VHR/Xe
wA+vvsfdKhscheOAwHiRUzVdTsZTUuGleObrCJ2Obdtu7g47ZgCVHGNBN/SyR6MF
SbzlirWjFhsqFI/a5Ut7DIPC1eB9vk/uM0KMNPWW6EcbpVImraNLCAF8EW5V6uLt
48wz6g+wCtOSVh9VKP0DrJF1Gsp6GulCTYkXali2dzrymqJbD5EeHBTYxrjChSpY
n5mUW2RB+huz10MLDoUWMR4uccmIGftmGHAi46zFTQNNO/j/h5znhbryeyw9wwFI
LFq3Wv23mw7wW6pgMJxuLcVyuKw1pPNPbBOkksayyBd5xvgo7xQSMlKdc54Erbin
o3eaUJp5UMcYNTA2W2cT
=8a4P
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
