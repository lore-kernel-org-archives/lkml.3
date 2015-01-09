Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbbAIOJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:09:12 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:36276 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbAIOJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:09:09 -0500
Date: Fri, 9 Jan 2015 15:09:04 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, John Stultz <john.stultz@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, marc.zyngier@arm.com
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
Message-ID: <20150109140902.GA7526@ulmo.nvidia.com>
References: <20141110095325.GC12126@ulmo>
 <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com>
 <alpine.DEB.2.11.1411132334400.3935@nanos>
 <CAOMFOmVziftM=pWGG-L9J-E6AHYAK7k9bmBcpS1adPboLciX9g@mail.gmail.com>
 <alpine.DEB.2.11.1411150115390.3909@nanos>
 <CAOMFOmV5=tes6Ak1eUKb2qircp8ba6jt6v-bg66Kp_-jYk9m2w@mail.gmail.com>
 <alpine.DEB.2.11.1411150154280.3909@nanos>
 <alpine.DEB.2.11.1411150212210.3909@nanos>
 <20150109094913.GB27845@ulmo>
 <20150109135907.GF12942@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20150109135907.GF12942@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 01:59:07PM +0000, Mark Rutland wrote:
> On Fri, Jan 09, 2015 at 09:49:14AM +0000, Thierry Reding wrote:
> > On Sat, Nov 15, 2014 at 02:38:00AM +0100, Thomas Gleixner wrote:
> > > On Sat, 15 Nov 2014, Thomas Gleixner wrote:
> > > > On Fri, 14 Nov 2014, Anatol Pomozov wrote:
> > > > > On Fri, Nov 14, 2014 at 4:18 PM, Thomas Gleixner <tglx@linutronix=
=2Ede> wrote:
> > > > > >> So what I suppose to do with my patch? If it does not work cou=
ld
> > > > > >> anyone provide patch that removes ARM arch dependency from
> > > > > >> tegra20_timer.c?
> > > > > >
> > > > > > Huch? You want other people to solve your problems?
> > > > >=20
> > > > > This is not the point. I provided patch that fixes the issue. Oth=
er
> > > > > people said that they have ideas how to do it different (and bett=
er)
> > > > > way. So I am asking to share these ideas represented as a patch.
> > > >=20
> > > > That's not the way it works.
> > > >=20
> > > > You sent a patch to solve an problem which you are facing.
> > > >=20
> > > > Now the people who review the patch think that there is a better
> > > > approach than moving code from arm/ to the timekeeping core code.
> > > >=20
> > > > So it's up to you to come up with a patch which solves the problem =
in
> > > > the right way.
> > >=20
> > > And just for the record this whole thing is just hilarious.
> > >=20
> > > ARM64 selects ARM_ARCH_TIMER which registers the architected timer as
> > > the primary clocksource.
> > >=20
> > > Now that timer has the following flag set:
> > >=20
> > >     CLOCK_SOURCE_SUSPEND_NONSTOP
> > >=20
> > > And that flag causes the core timekeeping code to use the clocksource
> > > to figure out the time which the machine spent in suspend.
> >=20
> > As I understand it the architected timer will be turned off along with
> > the rest of the CPU complex on Tegra. I'm not sure if that's specific to
> > Tegra or something that other SoCs may do as well.
>=20
> That doesn't sound right to me: the architecture specifies that the
> system counter must be implemented in an always-on power domain.
>=20
> Note that that only applies to the counter, not the timers (as the
> comparators can be turned off with the CPUs).

I'll let Paul comment on this, since I don't know the intimate details.
Of course if the system counter is indeed active across suspend/resume
then it doesn't seem like we'd need the Tegra timer at all on 64-bit.
Unless of course if we use it for something else.

Thierry

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr+D+AAoJEN0jrNd/PrOhmx8QALdxEZj6dRHdO0uIdaRYLH+P
xlRpN+ClAhVje3e+++oFoJ18Zw+RYuR2b5riBn07PULG9qxpvCnSg77rCZziSEzZ
RXTYplY27VB+VFwOsmeVPS28c3YxXAPNJxpDZM1ibnzF2htg9gKNoDBiepV63BKv
eSRf212/Fgc09z/Yyr7LaVFdFElOySNh5717S3m8x8MLkLQnMloorZy1qlnp4DGm
KV3m9QLUcnFfCJXna4YHzTAIaWfipX0CmXC+vWH15nZtexdV+yJXSJAx1Ak1vSpY
3RtSJ3asLoSVqfNFEZtvI9cgNMoXTsg4hpNnmjO9zsv7RTMgWSR5XwqYJIhkU6HF
opiP5EPeaG5ZTBbVOL6gw8XSCQsbJyOYRjDQRa4V/H83CcJQa2MnAWtizURGXcZx
ln2/ML2C5z8ILQOee/wRH7F8jmHrjktC3PFns0ffFlihZEt/K7+5kxT0KeHxQF+q
auYCirqgeul6pqcBpperZ6bI15shDMyZldeEup7eT6Mwn2NOApGLd+m7QQHF3kQj
lRpS+gfurwZ5FaK1tIjGejebB+L9vJcuTirKGSbF2sABC7eVyat6m8h4fj7EhTa8
TGyEhWWcji2LmMglTIk4NZ9lGPrCWKBU+HpSGDT9HVjElfnHjV0EERP4Yt8icC1T
nuYNUxQNoi2wAJHNd5Mo
=5LVO
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
