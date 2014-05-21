Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaEUIRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:17:34 -0400
Received: from sauhun.de ([89.238.76.85]:46035 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaEUIRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:17:32 -0400
Date: Wed, 21 May 2014 10:17:27 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
Message-ID: <20140521081727.GE2708@katana>
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
 <1394779348-4084-1-git-send-email-mike.looijmans@topic.nl>
 <20140324161432.GA7524@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ffoCPvUAPMgSXi6H"
Content-Disposition: inline
In-Reply-To: <20140324161432.GA7524@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ffoCPvUAPMgSXi6H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >  		dev_err(dev->dev, "controller timed out\n");
> >  		davinci_i2c_recover_bus(dev);
> >  		i2c_davinci_init(dev);
> > @@ -384,7 +384,6 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, stru=
ct i2c_msg *msg, int stop)
> >  	if (dev->buf_len) {
> >  		/* This should be 0 if all bytes were transferred
> >  		 * or dev->cmd_err denotes an error.
> > -		 * A signal may have aborted the transfer.
> >  		 */
> >  		if (r >=3D 0) {
> >  			dev_err(dev->dev, "abnormal termination buf_len=3D%i\n",
> > @@ -436,22 +435,24 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct=
 i2c_msg msgs[], int num)
> >  	ret =3D i2c_davinci_wait_bus_not_busy(dev, 1);
> >  	if (ret < 0) {
> >  		dev_warn(dev->dev, "timeout waiting for bus ready\n");
> > -		return ret;
> > +		goto error;
>=20
> You are fixing the error path here to include the completion? This is a
> seperate patch IMO.

Is my remark true? I still prefer the seperate patch, but we may also
simply update the commit message.



--ffoCPvUAPMgSXi6H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfGEXAAoJEBQN5MwUoCm2Fh4QAKVBRFy811+w6TIAEi0HYAhu
GwkCAGXGzWx0SseCP1y5eAJnHLgElsxG9riSwe82sNuG2OOeAQvTHmNlVcx9ym5+
ZU/SaWSid0d+EYXvc7iMpvy4VvO2M7nzJcLT9uopAG7RVapCldmeK9g591rZyIiK
Ml3KPvf5uZYtKyeHCpDqKUuJUtCsudRWXmRwVBGF5xx8Qpb+RcNu/epAFQuh4FPI
L26VJOeTY0T4dV08BBJwaEwI+wDd9lI1zBKfeMZ+aZsGww8Kj+8ABsq6VBEAQ8bj
pVy46fQHr+dUaRDCli7wSaatIlJB9a6l2I4GlbwkPQ9XSqDMekPP/jiXAzBzdxRM
AVUW2gjHkE9IAqekPvv/2jrrEuvVPbe/6whBvGtrOmo6/46+QabZrlf4+BBST9On
eXPY83gPIBtsnAvCdAzecd8HCsNnm/fSQHcKZqZO5HzUK0O2jBE9hGIu2Arq2Dda
CO5eAlTQLj7ON88qwD+x2DuJ5muZQcQhIPlkbWg4j2n5rwFEuF5WDv8y6Kpf+jJS
V6Joo+1Dc4Nd7IUwIVE0dHOEvjWDoG4uY8l42wsv1ZhzbfuO7c0z5hDhqq2h7fQg
r9XeO5pI+S2Mn1EjvVCTld4WTx/tAg4lswxfHaIQaY/+8UlR0wWuLLXR8Lm62IXu
Apm96xTa1MKCpYAxS5SG
=n973
-----END PGP SIGNATURE-----

--ffoCPvUAPMgSXi6H--
