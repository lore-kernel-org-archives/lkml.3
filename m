Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaEGI0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:26:06 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48987 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaEGI0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:26:04 -0400
Date: Wed, 7 May 2014 10:24:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>, linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: spear: fix check on pwmchip_add() return value
Message-ID: <20140507082410.GC6362@ulmo>
References: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
 <CAOh2x=mWqa=p2d1kRjf0_37DiioJZOJm3Ewv2xpMrNjPy69rvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <CAOh2x=mWqa=p2d1kRjf0_37DiioJZOJm3Ewv2xpMrNjPy69rvA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 11:37:25AM +0530, Viresh Kumar wrote:
> On Tue, May 6, 2014 at 2:59 AM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> > pwmchip_add() returns zero on success and a negative value on error,
> > so the condition of the check must be inverted.
> >
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > ---
> >  drivers/pwm/pwm-spear.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> > index cb2d4f0..945556d 100644
> > --- a/drivers/pwm/pwm-spear.c
> > +++ b/drivers/pwm/pwm-spear.c
> > @@ -222,7 +222,7 @@ static int spear_pwm_probe(struct platform_device *pdev)
> >         }
> >
> >         ret = pwmchip_add(&pc->chip);
> > -       if (!ret) {
> > +       if (ret < 0) {
> >                 clk_unprepare(pc->clk);
> >                 dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> >         }

So the current code would run clk_unprepare() on success, but not on
failure. Does that cause any harm? Is the device still usable after
this? I'm asking because I'm not sure if this is linux-next material
or should be a fix for 3.15 (and possibly backported to stable).

Thierry

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTae2qAAoJEN0jrNd/PrOh4ZQP/0xZLQM2wcWotQwr2jhN7wkp
8vJYtQ+zRV0L9Hp63czDZP4A89+MohcfEorhqAZ/vkwaiNwUni3A30fxlK0filY5
QhsASEixdJX13QucrcU0T3OqmtfqUjyYzaypvfy6B5fqKs3MBDVk8Jain8JxMkWV
QLUTSLRmtFnNCIY0yL4Is7ZFEclQWgS9r6q7TKM+M34RN/1BuMiui17S2BgtEloQ
JDAt5s46M/3tW1Zd622a6MmfvxJVHKZJOMDkVqD9YEw/hcd5jrIUA94NAf/u7E6v
yIQVYIB6SQnlfWOBXzfO5+aI82bg0XOr4X58wccJvxlNK9OwXevyohen6vIzV9pe
LwRPQz1Diwflo+lUVQYHAA71W6aHlnTBeo8SKqPvdqxZI7/WbM4/9EccfbpPe9R9
h+3rt5H30mw3xpxlKI86Qf0yEB7XNpNCdNgDsBELseWNmunzX0OfNse+JNg8838j
lqjJiGN0VarIYPYbyJPxieiJU7nr98ljCc26qJZKgtRp0cI7YE/2qoaKQetxWv0N
vSZw/SzluRJpKjDSPcnX8dves07qb1/JAsBuyvMmzBuW/94t5OuMoGo7LhvOWd+q
3GjTMJEvBOivYpvlmDFwa9AD4q92o+esP/F9yDZQr2J4RPt8AMwkC9w+3pS45Gcm
8NAwn5g0rv2a+wTK61bK
=/WTE
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
