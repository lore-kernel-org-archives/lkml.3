Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3CVDZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:25:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37673 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab3CVDZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:25:12 -0400
Message-ID: <1363922685.3728.21.camel@deadeye.wl.decadent.org.uk>
Subject: Re: PREEMPT_RT vs 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Ingo Molnar <mingo@elte.hu>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Fri, 22 Mar 2013 03:24:45 +0000
In-Reply-To: <1363919473.6345.88.camel@gandalf.local.home>
References: <1363914713.31336.191.camel@deadeye.wl.decadent.org.uk>
	 <1363919473.6345.88.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LHxlsCY0lY0WWjEFg7Vn"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9535:520b:eb30:917a
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LHxlsCY0lY0WWjEFg7Vn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-21 at 22:31 -0400, Steven Rostedt wrote:
> On Fri, 2013-03-22 at 01:11 +0000, Ben Hutchings wrote:
> > Commit b22affe0aef4 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
> > conflicts with the RT patches
> > hrtimer-fixup-hrtimer-callback-changes-for-preempt-r.patch and
> > peter_zijlstra-frob-hrtimer.patch, as they all change
> > hrtimer_enqueue_reprogram().  It seems that the changes in the RT
> > patches now belong in __hrtimer_start_range_ns().
> >=20
> > Since I haven't seen any RT releases in a while, here's what I came up
> > with for 3.2-rt:
>=20
> Note, I posted a fix on Tuesday:
>=20
> https://lkml.org/lkml/2013/3/19/369

Thanks.  I did search GMANE with some obvious terms but I think its
index is lagging.

> I'm waiting for Thomas to give his OK on it before releasing the series.
> He told me he'll have a look at it tomorrow. I've already ran the series
> through all my tests, and will post it immediately after I get the OK.
> Or if there's a issue I will have to fix it and rerun my tests.
>=20
>=20
> >=20
> > ---
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Fri, 3 Jul 2009 08:44:31 -0500
> > Subject: hrtimer: fixup hrtimer callback changes for preempt-rt
[...]
> > @@ -1011,6 +1023,26 @@ int __hrtimer_start_range_ns(struct hrti
> >  	 */
> >  	if (leftmost && new_base->cpu_base =3D=3D &__get_cpu_var(hrtimer_base=
s)
> >  		&& hrtimer_enqueue_reprogram(timer, new_base)) {
> > +#ifdef CONFIG_PREEMPT_RT_BASE
> > +	again:
>=20
> What kernel are you working with? I don't see anywhere the "again:"
> within a PREEMPT_RT_BASE block.

I'm rebasing the rt patch series generated with
'git format-patch v3.2.39..v3.2.39-rt59-rebase' on top of v3.2.41 (plus
Debian changes, which introduce some trivial textual conflicts).

So these patches were previously:

commit c495d005449523772e27a22fb74814dc3cebff8e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Jul 3 08:44:31 2009 -0500

    hrtimer: fixup hrtimer callback changes for preempt-rt

commit 80cc960e628509c72f63a7327a4dc22707a02b81
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Aug 12 17:39:54 2011 +0200

    hrtimer: Don't call the timer handler from hrtimer_start

[...]
> This is very similar to what I came up with.
[...]
> Yep, looks like we are on the right track  :-)
[...]

Good to hear.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-LHxlsCY0lY0WWjEFg7Vn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUvO/ee/yOyVhhEJAQqEMQ/7BRsyB7tf8HV/uEwemk++ojQAtIZfZMrA
cjkQkbbi/GsYHxz5FqXu0X+FzeZUdz+G/oLQxRlmNGqEFUo4pURCysiuiLHgv4ml
e/RHbWpAFoT/zaAcjvTeWChmw8zgsKiSBlXY5+RTksyEXv9zmGXgpabhQxk3CRPm
mCNNuRsF+lpB5d45rZY5LPXhedyWzS2WivCk3Ix+eIrTvOjO/HgCJ0wKy+hfDtfG
uxEIW3J2J99J8GrvElXIB4ZneGfRmvJLC3a70Se1tgKhG3GsRgR46I/XS2+HIVoS
MCdiKoH4UKhlyu1yuJFJSCtStH8loMub/k5sn50B7EraxX/vBWdhJ3SHbh4w1DEs
9+sEQuFTo71gEvb/CWwqY3XDW217QORzgjcQtOdqYqz2GjTK2TFko6Nwp0+PfaIq
Eq8QFBCBLrJSqY3MXeB/yjbrAdHuQ9zUGrxPWHoVxO0Vk2ynSHRnk5M7TxT5GGHH
bRS5Bjx+1VyiwwWXPsZMAtM2wFzw+p1gVrKFw7H191xCTCQcvUVbxh3yXztZz1gT
RhdWpJnIiGiQDk66zePSyuK59T80cTmFY6RjdCeVvVuhRfq3EVJd8VifydQ48z21
2av0NCX4Rqj4JXjYDwcDYXLN9g/paNa/QHyHn0Ix2Il2l+WtP/FGcCmiiP2VbNv/
J6VMlwlZZK8=
=ZffS
-----END PGP SIGNATURE-----

--=-LHxlsCY0lY0WWjEFg7Vn--
