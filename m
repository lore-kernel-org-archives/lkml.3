Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaHRI5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:57:32 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56694 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaHRI52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:57:28 -0400
Date: Mon, 18 Aug 2014 10:57:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-pwm@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] pwm: Fix period and polarity in pwm_get() for
 non-perfect matches
Message-ID: <20140818085722.GE31171@ulmo>
References: <1407943133-18170-1-git-send-email-geert+renesas@glider.be>
 <20140818082039.GA31171@ulmo>
 <CAMuHMdVLA4xRGKrsyGTokZvRWkNAFyNv+_JycavfpibO8GXkkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVLA4xRGKrsyGTokZvRWkNAFyNv+_JycavfpibO8GXkkQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 10:38:00AM +0200, Geert Uytterhoeven wrote:
> Hi Thierry,
>=20
> On Mon, Aug 18, 2014 at 10:20 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > Could we achieve the same by storing a pointer to the best match and
> > then use that instead of p? Perhaps something like this:
> >
> >         struct pwm_lookup *entry;
> >
> >         ...
> >
> >                 if (match > best) {
> >                         chip =3D pwmchip_find_by_name(p->provider);
> >                         entry =3D p;
> >
> >                         if (match !=3D 3)
> >                                 best =3D match;
> >                         else
> >                                 break;
> >                 }
> >
> >         ...
> >
> >         if (chip)
> >                 pwm =3D pwm_request_from_chip(chip, entry->index,
> >                                             con_id ?: dev_id);
> >         if (IS_ERR(pwm))
> >                 return pwm;
> >
> >         pwm_set_period(pwm, entry->period);
> >         pwm_set_polarity(pwm, entry->polarity);
> >
> > ?
>=20
> That's possible. But that will add complexity, as you have to move the
> "mutex_unlock(&pwm_lookup_lock);" after the last user of "entry" again,
> and add a goto for the IS_ERR(pwm) case.
> So I'm not sure it's worth the effort.

Oh, right. It would've been nice to avoid all the temporary variables,
but we can always refactor if that turns out to become too messy. I'll
apply this one for now.

I'll shorten the SHA-1 in the Fixes: line to 12 characters if you don't
mind to match the guidelines in Documentation/SubmittingPatches.

Thierry

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8b/yAAoJEN0jrNd/PrOhzz8QAKuW3G6rd528uRZAFG1NFX0i
VkZBtkbz86Z+f4b4d3ZDYmDDiwLlPNc2bpkCvXOBG1m/7/Ck2VWOrsSdy00/hmc1
sdmWVjmrq3OoK6BDj4J+76dSjHhbCpe3yUk1E/fs2U1XurcmFuQtmUcZIlBLMfCZ
Dsgker/tZgiKklKmaOp+HpasZj3PH/sBXw8Qh2pny2JjUeOw6GLpGgBtE8RA+nqn
78E2PTOZns7EBqTmuYJA6oHFBp2GPs2ONYuaqcGvQPJ+Wp36E4oOMZfP63JtD51j
eJ3Glhm57cOKcaTQz/jbDxQOwiaSpG+66M1wBzCZQJ78Oh3nAkJLHvoVwyJPon6o
rPbwbqbtA2Jx/JV5xIif8EmwZNlQ3gYh49sXiUTewMEmesdkn5jJ22QsFDyRi4pF
ZT11cpFo+qydH81ytjLASEdKTze/0wPK+pCXcI/muHbhWbyyTwtmgjdj7hWnecrm
yKzDns+0kRHzuQ7KvQIV1jKmx1is08xLlr8jWkEMglJ5qZptH3ZcxvtepUjOSDfl
OvK45uTx9A10YNczx9zVQZQnhR7V4d8q9+nqksOjcUMFfCLGfi2NVd3hPrscYOoM
ELlRr7dTChjshGsdNM1wArYLlt1RwZ7Iy/H7fbf9V2dgwVM+1ha/pFor1/kdJuOf
4jQx2UI6zoN0eeyJ3m+e
=U2RX
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
