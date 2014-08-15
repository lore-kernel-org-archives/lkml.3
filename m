Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaHOGTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:19:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbaHOGTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:19:35 -0400
Date: Fri, 15 Aug 2014 08:19:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, arjan@linux.intel.com,
        mingo@kernel.org, len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        dirk.brandewie@gmail.com
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
Message-ID: <20140815061917.GX19379@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
 <20140814205143.GY6758@twins.programming.kicks-ass.net>
 <CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4St3GbU430LdqTT"
Content-Disposition: inline
In-Reply-To: <CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4St3GbU430LdqTT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 05:56:10PM -0400, Ashwin Chaugule wrote:
> Hi Peter,
>=20
> On 14 August 2014 16:51, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, Aug 14, 2014 at 03:57:07PM -0400, Ashwin Chaugule wrote:
> >>
> >>
> >> What is CPPC:
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> CPPC is the new interface for CPU performance control between the OS a=
nd the
> >> platform defined in ACPI 5.0+. The interface is built on an abstract
> >> representation of CPU performance rather than raw frequency.  Basic op=
eration
> >> consists of:
> >
> > Why do we want this? Typically we've ignored ACPI and gone straight to
> > MSR access, intel_pstate and intel_idle were created especially to avoid
> > ACPI, so why return to it.
> >
> > Also, the whole interface sounds like trainwreck (one would not expect
> > anything else from ACPI).
> >
> > So _why_?
>=20
> The overall idea is that tying the notion of CPU performance to CPU
> frequency is no longer true these days.[1]. So, using some direction
> from an OS , the platforms want to be able to decide how to adjust CPU
> performance by using knowledge that may be very platform specific.
> e.g. through the use of performance counters, thermal budgets and
> other system specific constraints. So, CPPC describes a way for the OS
> to request performance within certain bounds and then letting the
> platform optimize it within those constraints. Expressing CPU
> performance in an abstract way, should also help keep things uniform
> across various architecture implementations.

> [1]- https://plus.google.com/+ArjanvandeVen/posts/dLn9T4ehywL
> [2] - http://git.linaro.org/people/ashwin.chaugule/leg-kernel.git/blob/23=
6d901d31fb06fda798880c9ca09d65123c5dd9:/drivers/cpufreq/cppc_x86.c

Yeah, I'm so not clicking in that; if you want to make an argument make
it here.

In any case; that's all nice and shiny that the 'hardware' works like
that. But have these people considered how we're supposed to use it?

How should we know what to do with a new task? Do we stack it on a busy
CPU, do we wake an idle cpu and how are we going to tell which is the
'best' option.

How are we going to do DVFS like accounting if we don't know wtf the
hardware can or will do.

And how can you design these interfaces and hardware without at least
partially knowing the answer to these questions.

--G4St3GbU430LdqTT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7aZfAAoJEHZH4aRLwOS68dQP/AvYGHK+LWcJyfXt96UAiNTX
cyR2JK/KFivHf4dii+B/ghxdZW2TTthby+TaKUfn3EhudXB6i5nljc1aSD/6JUTB
vr0B2RTtqJUh7Z5l26ewL9lMfSSYMjM4EbziTMbDNjo2LsaT1oCoP0t5CrH9/glM
IiJUuDl/b77YpP2O5ouIRoot9GvtoSkt4F3Qfundp3wJ+Wqh6uEBIuIzK+xZ3egv
ahXWJ3Q5ljS2AL6C7YtNzzdEwKEICCxEg95Peewklp++pq0ck2GwxI7o9zPg2/Nb
NcPosid1dEfIzEO4n8XeIQu2CzJ9XxRwBu7Zu8jJ2gcU8kjbitM+HboE0LTHxjll
gRGpeup5O4iZOONsG4lMDZaZOduUix21bu7fNt/SY1aGRrp7rWUvw5QIBAsOLHmn
w4Gkq/5cqX8QbdQCZWHnxxHzpr7HfVGxNy5WySy92531+l3AgkupvvVTGrq4wr8m
xvl0oh+JbUED8UhJ6y1nDLvzVBL+ivHKCwM2VrKhZKUP99654ab+hDOtZbZSavJj
hk+qJXae7TiHjkDdHlpcNkX8xn6RzZROU7QtLHOmzHM2ZMJUirXp7C9AVytiQF4b
bTdE9sJsLyQBjfClY0uNIXDvw0mDRJ8GoGcmxsx1F4Ug7ck+1wqp5BYjbnSs88wb
f0znhuY0VfeH482EDd/Q
=CLmc
-----END PGP SIGNATURE-----

--G4St3GbU430LdqTT--
