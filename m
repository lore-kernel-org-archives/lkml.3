Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaKTI56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:57:58 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55970 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbaKTI5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:57:55 -0500
Date: Thu, 20 Nov 2014 09:57:52 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Hai Li <hali@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 1/2] drm/msm: Register irq handler for each sub-system in
 mdss
Message-ID: <20141120085750.GB23043@ulmo>
References: <1416004955-28749-1-git-send-email-hali@codeaurora.org>
 <CAF6AEGuFK=ZdaKF8hOwHyQOcmMR+ZMQjbwf+hL3pZm_O+t1K0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <CAF6AEGuFK=ZdaKF8hOwHyQOcmMR+ZMQjbwf+hL3pZm_O+t1K0w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 16, 2014 at 09:18:47AM -0500, Rob Clark wrote:
> On Fri, Nov 14, 2014 at 5:42 PM, Hai Li <hali@codeaurora.org> wrote:
> > All the sub-systems in mdss share the same irq. This change provides
> > the sub-systems with the interfaces to register/unregister their own
> > irq handlers.
> >
> > With this change, struct mdp5_kms does not have to keep the hdmi or
> > edp context.
> >
>=20
> So, I think the point of this is to better deal w/ different hw
> variants which do or do-not have hdmi, edp, dsi, etc..
>=20
> But, just playing devil's advocate here, it seems like it would be
> simpler to instead just do something like:
>=20
>     if (priv->hdmi && (intr & MDP5_HW_INTR_STATUS_INTR_HDMI))
>         hdmi_irq(0, priv->hdmi);
>=20
>     if (priv->edp && (intr & MDP5_HW_INTR_STATUS_INTR_EDP))
>         edp_irq(0, priv->edp);
>=20
>     ... etc ...
>=20
> It is a little less elegant.  But it is also less lines of code.  I
> guess there will be plenty of necessary complexity as we add support
> for all mdp5 features.  So avoiding some unnecessary complexity might
> be a good thing in the long run.
>=20
> If we really did want to make it more dynamic, we could always extend
> 'struct mdp_irq' to take both an irq mask and an initiator id, I
> suppose.  I'm not sure if that is overkill.  AFAICT we really only
> have 5 different subsystems to dispatch to (mdp5 itself, and
> dsi0/dsi1/hdmi/edp), so simply adding some if-not-null checks in
> mdp5_irq() seems pretty reasonable to me.

To me this just seems like a regular interrupt multiplexer, so
implementing it as an irq_chip would be the most appropriate. That way
you get all the goodness of a well-tested code base for free and you can
simply pass in the request_{threaded_,}irq()'s dev parameter.

Thierry

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUba0OAAoJEN0jrNd/PrOhiSEP/0mzuHBJvlbT+lmMDJz/jaDz
fhZvlYzO24stAmB+v29tL/Q59VhIxN7Ziisp3zFy6gBqUO2RhAWmoaqxFE/smEgd
OeidITjt1cQjsHKLUOJq2xxDErsFRo5Fp5j0J7EBYZT0dQeYR4alt2J63pcKG9qL
6boE3tqXRMnurn72jfdqp4I/atr688bBAZYLyjt1yAK/ZVuJISPLDokZQytdOfhA
IWBc/5TipHpJxywXRx6ibiywelaS1Ufu3z6OKKrsEyimAWPQi9dXA6Nd0u0MPQNR
FRVWKROU09qlRz1d5vmWk7ntrx3uNKhLIZx02OnRGDEYhG6rC1q31Eyra22yL8Oi
CqwoxcyhvxHo9Wwbxq7izopV3tXtir41hrDhVQKhKeETvAqtJHiw8EJqvyMAIXUO
5pRGRalRlE+5jRfp38mEGgd8DwlUxbZqZa4ciTA7Tsgj0r8U9G06WqCr2e+wEZY9
uUug3HgBJ0THxTOPiz+wjx9rlaW7FhIfIyhtZh17UXkvsauhYUgWqdUYB4jBAlnj
5r3cAIBCGXsp+R+dgd/P7lSMk/KYga+HHLDxN/NOrNREd1s5049HAXjH/uUWPnsv
JSGet5XFDwJgbjqVfVnQaE082lpMa++dlidV5HxAc/p4cy5nsb5g32Sz4EfO4Now
gGH+ta/GWr6zeBmrguE/
=0Lj0
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
