Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaK1XWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:22:20 -0500
Received: from bues.ch ([80.190.117.144]:47214 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaK1XWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:22:19 -0500
Date: Sat, 29 Nov 2014 00:21:48 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Nicholas Krause <xerofoify@gmail.com>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] drivers:net:wireless: Add mutex locking for function,
 b43_op_beacon_set_time in main.c
Message-ID: <20141129002148.1beb21d9@wiggum>
In-Reply-To: <CACna6rxmOC0h9hOpa=5iWFM1THQ8Q4hCi8MnmqkZJbB_U0PJ0A@mail.gmail.com>
References: <1417213013-19758-1-git-send-email-xerofoify@gmail.com>
	<CACna6rxmOC0h9hOpa=5iWFM1THQ8Q4hCi8MnmqkZJbB_U0PJ0A@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/a9VZzheb11hdlXkyH8hfJby"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/a9VZzheb11hdlXkyH8hfJby
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Nov 2014 23:40:46 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> > @@ -5094,8 +5094,9 @@ static int b43_op_beacon_set_tim(struct ieee80211=
_hw *hw,
> >  {
> >         struct b43_wl *wl =3D hw_to_b43_wl(hw);
> >
> > -       /* FIXME: add locking */
> > +       mutex_lock(&wl->mutex);
> >         b43_update_templates(wl);
> > +       mutex_unlock(&wl->mutex);
> >
> >         return 0;
> >  }
>=20
> Does anyone remember why this simple solution wasn't implemented
> earlier? Michael?

I think the callback used to be (is?) in atomic context.

> Nicholas: did you test it anyhow?

--=20
Michael

--Sig_/a9VZzheb11hdlXkyH8hfJby
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUeQOPAAoJEPUyvh2QjYsOko8P/j/erXMBLKii9IzxSByO5DCs
jxsXn8p4OBE+e5K8uVEr7CSorMlzZCU+D7Vi9h6OiUS5TnXikKx1O2fE9SRLnm4A
N7pc/3b1HuIUCtnOdQYIRJjFglU4Ng8TV4UHJwKtCEehlgIBp3DgaR9yECv+BCd1
cYZxWy5+Acdh/OLMEdy73vNcSYAKxiJ8ViU1fSJCVuCxRN0Z5LP/DG0Hy2dnO7c/
/TLBkbQ8JBkzyi0k6nczEVdR5/5K8X9EN3BzE0ZsJny0BRzsQKTcQvOdMx9CaFJn
X2zP9X2PtYLCgyl33Vr0YLXX03VXNLzgzR68g6xOa2h0tKlylMB2gYuCr0S2NR2i
F63MhHNRYgSMnbHxCH9IAJQstVZe3p0pArnriAElNCMJbMBnI5nWy+sHsqjdOp/L
3sL5fWwWgMvtkVeTnrTZFZ+fA2cwK2+MSRPvc11N5v3dDnZBdkfUkgW7fEdWQP0J
/XJCNWecIW0PtpNT1xsm2WEtaq75boGgfcGW8+HXAdVTy97a4H5+5Zwn2ZpRYWst
ClN1W34bvm9akcPxUpDp/GZMd0ij7jeo112nXVKBEwQNO/HMgq2w6FyvnJoBQrk/
CBybaHhL4bj5+DclI8YeDATI6DPOrPBZD2ospmAqxm8w+vUpd7/2Q0Upn5QfIAey
uRCU1p7D7b28DFDvN8zB
=ef5U
-----END PGP SIGNATURE-----

--Sig_/a9VZzheb11hdlXkyH8hfJby--
