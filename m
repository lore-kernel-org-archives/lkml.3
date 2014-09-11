Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaIKLVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:21:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58444 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIKLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:21:38 -0400
Date: Thu, 11 Sep 2014 13:21:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC 3/4] backlight: add kernel-internal backlight API
Message-ID: <20140911112133.GC552@ulmo>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
 <1410364463-12692-4-git-send-email-dh.herrmann@gmail.com>
 <20140911111000.GA552@ulmo>
 <CANq1E4S=0EHyLh6M_pA94QNgMzzj5NXpd6p7OMDTaQSW+Qd_bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <CANq1E4S=0EHyLh6M_pA94QNgMzzj5NXpd6p7OMDTaQSW+Qd_bQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2014 at 01:14:31PM +0200, David Herrmann wrote:
> Hi
>=20
> On Thu, Sep 11, 2014 at 1:10 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Wed, Sep 10, 2014 at 05:54:22PM +0200, David Herrmann wrote:
> > [...]
> >> +void backlight_set_brightness(struct backlight_device *bd, unsigned i=
nt value,
> >> +                           enum backlight_update_reason reason)
> >> +{
> >> +     mutex_lock(&bd->ops_lock);
> >> +     if (bd->ops) {
> >> +             value =3D clamp(value, 0U, (unsigned)bd->props.max_brigh=
tness);
> >
> > max_brightness should really be unsigned to begin with...
> >
> >> +             pr_debug("set brightness to %u\n", value);
> >
> > dev_dbg(&bd->dev, ...)?
>=20
> I agree with both comments, but I tried to be consistent with what
> brightness_store() does.

Fair enough, this can be cleaned up in separate patches.

> >> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> >> index adb14a8..bcc0dec 100644
> >> --- a/include/linux/backlight.h
> >> +++ b/include/linux/backlight.h
> >> @@ -141,6 +141,22 @@ extern bool backlight_device_registered(enum back=
light_type type);
> >>  extern int backlight_register_notifier(struct notifier_block *nb);
> >>  extern int backlight_unregister_notifier(struct notifier_block *nb);
> >>
> >> +struct backlight_device *backlight_device_lookup(const char *name);
> >> +void backlight_set_brightness(struct backlight_device *bd, unsigned i=
nt value,
> >> +                           enum backlight_update_reason reason);
> >> +
> >> +static inline void backlight_device_ref(struct backlight_device *bd)
> >> +{
> >> +     if (bd)
> >> +             get_device(&bd->dev);
> >> +}
> >
> > Perhaps for consistency with get_device() this should return bd? That
> > way you can chain things like so:
> >
> >         priv->backlight =3D backlight_device_ref(bd);
>=20
> Makes sense, will change it. Same is actually true for _unref(), which
> should return NULL unconditionally. This way, you can use:
>   priv->backlight =3D backlight_device_unref(priv->backlight);
> to release a reference and reset the pointer at the same time.

That looks somewhat odd to me. Wouldn't priv->backlight typically go
away after the unref anyway (presumably because priv is going to get
freed soon after)?

But I have no strong objections to returning NULL from _unref(), if code
doesn't need it it can always choose not to use the return value.

Thierry

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUEYW9AAoJEN0jrNd/PrOhHKgP/3LzIEj2f8vz5y2FHBf/s2+v
s/p0Zz3HzUG9RegLENUBDV9sGF55L6EZwkeJt+8pAbIwJExhw0bQj6J3mZPt0/dF
sUESSDejLS+KnhqjaaBSk45jvrbICLDOU2q3+oUiU/LcRHTU4RaAxG2i8ir1EDQm
4zzYPxxinYjr3zZW8krzNdqNCP6axvEaTtoXKR5UaAvceUvlNuAv6E5fmaqa4/2s
kJF8eBGzl0sIsKTTSn+7i3vCnUesz9foYtGCba7pLQwcmZcJAauJqaMW6zQV0icU
PANBiEC6TARB6DZTrvNDlvLx5ZAfjYhg3C3iVy1WdJTd70EHP4/WzUhCm5wrS9wP
mP928B/vTpjTkJZ6UnnhT8YR5qSIeL/rYa1/w6f/nJF2WBzKz1d5At/DZnGG/W4h
E8dg3ZHApaTiD4rrdekPE3Wh3YB4+niFq3BKzRiGekdOe16rJD5rDKVhbvNrcHJB
RKeaiI/vPPGd9KSmc/HDMIkjoullAPU2TE5wOv+Vu6XTh2QgkihURN+ei9STKN2/
xlTB0KLFsnfXRXy+LJXX9zPo490wdFKgZLIXaNd8Z7CnO9lcEz8xPv3iNzSIxAua
cdlPB+Qn36/vNPqZ9sAIses6peXCeCmr6laq9WIEY72KomCoNB4R/02VYqVfJ4xW
PypVRBGbbERBWolt53bR
=7BVq
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
