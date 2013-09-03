Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab3ICSwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:52:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3ICSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:52:08 -0400
Message-ID: <1378234316.20316.403.camel@fourier>
Subject: Re: [PATCH] drm/i915: i915.disable_pch_pwm overrides PCH_PWM_ENABLE
 quirk
From: Kamal Mostafa <kamal@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 11:51:56 -0700
In-Reply-To: <CAKMK7uHUr-qw491-kPjX=qHE+wtcYHC-bMyGehHDuF7w0Jkp7w@mail.gmail.com>
References: <1378229848-29113-1-git-send-email-kamal@canonical.com>
	 <CAKMK7uHUr-qw491-kPjX=qHE+wtcYHC-bMyGehHDuF7w0Jkp7w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FtuG/ICUXMHUSAHm5dKH"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FtuG/ICUXMHUSAHm5dKH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-09-03 at 19:50 +0200, Daniel Vetter wrote:
> On Tue, Sep 3, 2013 at 7:37 PM, Kamal Mostafa <kamal@canonical.com> wrote=
:
> > BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D47941
> >
> > Some BIOS configurations of Dell XPS13 are adversely affected by e85843=
b
> > ("drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight") so provi=
de a
> > boot param to inhibit the quirk, or force it on.
> >
> > i915.disable_pch_pwm can be set to
> >  -1: auto (default; allows the disabling of pch_pwm by dmi quirk table =
match)
> >   0: inhibits the disabling of pch_pwm (overrides dmi quirk table match=
)
> >   1: forces the disabling of pch_pwm
> >
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>=20
> Nack. Piling quirk over quirk isn't the right approach

I understand your reluctance, but this isn't actually any new quirk
functionality, just a way to manually enable/disable the original
PCH_PWM_ENABLE quirk.  I think this is the least crazy approach,
because:

Most XPS13 configurations do need the quirk (and maybe some other yet to
be identified machines also), but dmi matching cannot discern the one
particular XPS13 configuration ("Ivy Bridge booting UEFI mode without
Legacy Option ROM") that is adversely affected by it.  We could
alternately consider trying to detect that specific configuration with
code in i915, but that seemed a lot crazier (and less generally useful)
than just providing an override switch for rare or yet-to-be-discovered
configurations.

Hmmm.  What if we had a pair of boot params "i915.quirks_set" and
"i915.quirks_mask" boot params that could be used to manually set or
mask _all_ the bits in dev_priv->quirks?  Such params would surely come
in handy for cases just like this one, and would be useful for testing
future machines easily.  (Would you take that if I submitted it?)


>  and I think I
> should just revert the pch_pwm enable quirk again.
> -Daniel

But reverting the original quirk would break ALL the XPS13
configurations, which nobody is requesting.  Please don't revert the
quirk.  At most, you might want to disable the Ivy Bridge dmi match (but
I don't recommend this either):

        /* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
        { 0x0166, 0x1028, 0x058b, quirk_no_pcm_pwm_enable },

 -Kamal

--=-FtuG/ICUXMHUSAHm5dKH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJSJi/NAAoJEHqwmdxYrXhZdYgP/0VcZju2kElOu2n4bHDR1twL
dz3O9xBfnKzJVsrG9PUEIKPxYJDeYupBiMSLhEFnL/1mmQUfbbutQr5mvt6pXzvv
12gc1n8oGZhlK0TCNrfBPmYx9aclErU9yCoARn/OWEixkYqsd+fHnLAJV1b1M10v
GnHPWSxmmnLLI3vwiGlubQtRviRBvs8dpTHThzD5qiccOtS1Uh2nF/bIhFC63aHx
ah9yEi0YX8Exx/O511eKqFMAe42qQ9dLdSFXyivsMB8uBkgPiAjYRwAyqI6IkXpE
glK9GDVV/QQNpdhgfvSBs5yUtUwrPCNKg4Q+VXCblE1BuFJ7Qp9Yhqnw2deGcxsw
RdzvEvqEN62Pipfz1R9gGu2Nvu8ko5kKbSyUKQ1v3hotMOf/V8gJ44X4SoFIA+Sh
OmVMaxfi+asp2JJZry420fue1vRB43dvY24Mk3YgJlju8A1HSFU88SCMbAjbGsMJ
rEPXAfhqjhqKfw+9B2MhoAxUQ0/dIXAcLTbHl+ZxWMua3gmkyQ+imb3ial921Prq
UcvCz6+oOwHm8ndvSkl9DS9wUmnTw1N7B8HojBuIthiRonQyEVSjjwGDcz9gPFc4
/qKVh/2OJ/45TPtDeXfshrQ/toUeAlprbVl7KTiWyU+tCYt+sw+vD0RG+lFCgql6
IxQw9ipSq7tWJvGbrgmP
=ifz6
-----END PGP SIGNATURE-----

--=-FtuG/ICUXMHUSAHm5dKH--

