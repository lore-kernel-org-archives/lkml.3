Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3APMad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:30:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3APMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:30:31 -0500
Date: Wed, 16 Jan 2013 13:30:26 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH 1/2] pwm: pwm-tiehrpwm: Low power sleep support
Message-ID: <20130116123026.GA7132@avionic-0098.adnet.avionic-design.de>
References: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
 <1357823024-17585-2-git-send-email-avinashphilip@ti.com>
 <20130114070855.GA21994@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3EA5DF80@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA5DF80@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ziD1YWem8B30cXRKzHkEQcs5TXoKCZpsyz9M3DMSOh/
 GXmJPi+cWIBvAXondwxAvohYkerkLQx/tx0BD/EW8SICgady2Q
 7HxCz81iphJjTR0ufpadCLVI7l/CnWpCaHRQnA/ijp40AF4Ga+
 FUGo+iWH2CcEkFsIvH2u2mXAl+Lo2Td6yOn9z3zs/kIBO1aAL5
 dm7Q7NxCUZ6ZnFyKj+Aqh0Tzuh/p2kl8iMyVlNuepgWg5xfSap
 A37rUCcDTcgWHXvSbcUroqxcpNJEa2Frlrt61V5aIbxwzjX8fW
 I+nvDct1+7AYbcwC+Zm6BPbiq6YQzq0jhiHe0G7MFSS56jdTXN
 jgDuL52WqFY9dUwvneUG2mjCGI+SXlFaVlB//8IDaHaVj0GR0D
 H7lGIHWG7q8atfuJYaxQ67LuDWpthUJql4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 12:14:01PM +0000, Philip, Avinash wrote:
> On Mon, Jan 14, 2013 at 12:38:56, Thierry Reding wrote:
> > On Thu, Jan 10, 2013 at 06:33:43PM +0530, Philip Avinash wrote:
> > [...]
> > > diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
> > [...]
> > > +static int ehrpwm_pwm_suspend(struct device *dev)
> > > +{
> > > +	struct ehrpwm_pwm_chip *pc =3D dev_get_drvdata(dev);
> > > +
> > > +	ehrpwm_pwm_context_save(pc);
> > > +	pm_runtime_put_sync(dev);
> > > +	return 0;
> > > +}
> > > +
> > > +static int ehrpwm_pwm_resume(struct device *dev)
> > > +{
> > > +	struct ehrpwm_pwm_chip *pc =3D dev_get_drvdata(dev);
> > > +
> > > +	pm_runtime_get_sync(dev);
> > > +	ehrpwm_pwm_context_restore(pc);
> > > +	return 0;
> > > +}
> >=20
> > According to Documentation/power/runtime_pm.txt, the PM core runs the
> > pm_runtime_get_noresume() and pm_runtime_put_sync() before executing the
> > .suspend() and .resume() callbacks. Are you sure you need to call them
> > here explicitly?
>=20
> I understand the problem of calling pm_runtime_get_sync() from .resume().
> But this has to be called if pwm was running while going to suspend so th=
at
> pwm can continues to run after resume.

Okay. I misread the documentation and/or your patch. The documentation
says that the core calls pm_runtime_get_noresume() before executing the
=2Esuspend() callback so you're not in fact calling it twice. Sorry for
the confusion.

> So I will add check of test_bit(PWMF_ENABLED, &pwm->flags) before=20
> pm_runtime_get/put_sync calls.

Yes, that sounds reasonable.

Thierry

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9p1iAAoJEN0jrNd/PrOhAwQQAMLI/3Mxh+S88RwmGnKBzdJn
vg4UEsbX/0Gr75kzEKwuvXdH4u/lY9S/ZUg3nI54fgnhHUG6VLhXA13YNGR0FIag
ygDLHYiLXwsfrfOUOtrpXkLisuKVUapveilRSLxYFCdPlY7KFsIE8tvhiC7uEKev
VKhQV8476XRF7MlSj53BRL0jzdfdBS5NV5wSK+lKwPaopTn20HCcS7GKclEWuyl/
RW/BnndegEO9PIz6vHYiJBeIhYxiWIXJnGrKsTUPtRJBam27MRBUZ7Pt8vpaasMG
ZroF2mxaZsTyj736ryEBbRpvr4b/AqOBSnPX6vTfYL/HfSQGgVgTfhRO3WLpGhjJ
rNheQdO7ErYWQUW5nAypW8SHs2LybJtUV9Rqw3hpWElgAf1oGC+F2mEXTFtVhAVj
5mabTUgC5TIIeahbCtV/6cfrKxvfU4E1P5f0WOHRustT0UiVswF/v3C7uolkVLYg
heqVnEXh1lphfQHNsZ02fZ1MZkjMSUcnlXRy2u+ujzIehR9HmERP38qE6MsdKNBA
SBl4o5exlqlJ91yIF7UnbDtycp7F4DquQkH09JRt1FAC0tXjKnvnG470gnK0T9er
vqacEHblMy1fRiwzYXwjnAITmlbkvZ7SNtLqVtr7gLJXSQgmqTzBCQ2lriFLUv7O
lMDGTjpN2B9jHpPmA1VJ
=MJbn
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
