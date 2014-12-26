Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaLZNYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 08:24:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49933 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLZNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 08:24:40 -0500
Date: Fri, 26 Dec 2014 13:23:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Message-ID: <20141226132306.GC17800@sirena.org.uk>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org>
 <20141224171815.GD13399@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lz6jMTqI3BNRrqA1"
Content-Disposition: inline
In-Reply-To: <20141224171815.GD13399@e104818-lin.cambridge.arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.167.240.137
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lz6jMTqI3BNRrqA1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2014 at 05:18:15PM +0000, Catalin Marinas wrote:
> On Fri, Oct 17, 2014 at 02:37:14PM +0100, Hanjun Guo wrote:

> > +ACPI drivers should only look at one specific ASL object -- the _DSD o=
bject
> > +-- for device driver parameters (known in DT as "bindings", or "Device
> > +Properties" in ACPI).  Not all DT bindings will be recognized.=20

> This last sentence kind of implies that many of the DT bindings will be
> recognised. While it is useful to have some commonalities, I think this
> gives the wrong message that _DSD is a copy of DT. We should avoid this.

> > +so that they may be used on any operating system supporting ACPI.  Dev=
ice
> > +properties that have not been registered with the UEFI Forum should no=
t be
> > +used.

> More about this further down.

Indeed...

> > +Drivers should look for device properties in the _DSD object ONLY; the=
 _DSD
> > +object is described in the ACPI specification section 6.2.5, but more
> > +specifically, use the _DSD Device Properties UUID:

> > +   -- UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301

> > +   -- http://www.uefi.org/sites/default/files/resources/_DSD-device-pr=
operties-UUID.pdf)

> > +The kernel has an interface for looking up device properties in a mann=
er
> > +independent of whether DT or ACPI is being used and that interface sho=
uld
> > +be used;

> I haven't followed the _DSD kernel support but does it provide a common
> API to be shared with DT? I'm not entirely convinced it's a good idea.

Yes, it does.  I'm not entirely convinced about that either but it
really meets the goals of some of the users.  Right now I'm seeing
several user communities:

 - x86 server
 - x86 laptop
 - x86 embedded=20
 - ARM server

The _DSD/DT abstraction API is intended to meet the needs of the x86
embedded community, they are really only interested in Linux and just
want to be able to pick up Linux drivers that have been developed with
DT in mind and use them with the minimum fuss.  They are, to a good
approximation, not really interested in UEFI and ACPI per se.

> > it can eliminate some duplication of code paths in driver probing
> > +functions and discourage divergence between DT bindings and ACPI device
> > +properties.

> Given the current different mechanism of reviewing/approving bindings
> between DT and ACPI (kernel community vs UEFI forum), I don't see how we

Right now there is no real way of reviewing and approving bindings for
_DSD.

> encourage convergence (unless we state that _DSD are Linux-only, Windows
> should use a different mechanism like .inf files).

No, I don't think we want to encourage that.  It's what's happening
right now for the x86 laptop case and it's making things miserable for
people working with audio, what we end up with on the Linux side is
needing to have per-machine quirk tables which means that Linux has
little chance of working out of the box with unknown hardware.  It's bad
for users and not a lot of fun for developers.  What you're saying is
fine for the x86 embedded people but as soon as we want to run both
Windows and Linux on the same system we want to try to make sure that
the firmware itself describes the hardware.

Note also that there are already some non-_DSD ways of passing platform
data to ACPI devices (you can read at least integer properties easily)
so it's not just _DSD we have to consider here.

> > +The _DSD object is a very flexible mechanism in ACPI, as are the regis=
tered
> > +Device Properties.  This flexibility allows _DSD to cover more than ju=
st the
> > +generic server case and care should be taken in device drivers not to =
expect
> > +it to replicate highly specific embedded behaviour from DT.

> While this is all good, we need to be more specific on what "embedded
> behaviour" means. Maybe not for this document but the UEFI approval
> process for new properties doesn't give any hint on what is and is not
> sane (and I already disagree with some of the examples on uefi.org).

Right, though we also don't want the UEFI approval process to set down
standards that are too heavily tied to a specific view for ARM servers
since ARM servers are not the only users.

> My problems with _DSD:

> a) no clear guidance on what a good property means, whether it covers
>    just device specific information or it may include Linux behaviour
>    (like "linux,default-trigger", I don't think it should)

Right, though some people are going to want to do that.

> b) the Linux kernel community does not seem to be involved in the UEFI
>    forum _DSD review process. This means that we'll be faced with
>    patches against drivers to support UEFI-published _DSD properties.
>    I want to avoid such arguments, rejecting kernel code is too late
>    after _DSD properties have been published

I've been very concerned about this and chasing it up myself.  As far as
I have been able to tell there essentially is no UEFI forum _DSD review
process at this point, the brief bits that are there are essentially
placeholders rather than actual practical things which people expect to
be viable long term and were placed there in the interests of getting
the actual stuff that goes into the tables approved.  There was some
indication that there was an intention to have some discussion early
next year about doing it properly.

It'd certainly be good to get wider involvement from the kernel
community in that discussion, right now I'm a bit concerned that the
standardisation isn't going to be terribly effective in reaching
everyone it needs to or relevant to them.

Personally I'm mainly interested in making sure we can ideally
facilitate conversation with the Windows driver people and at worst can
set good practice standards for them which make life easier for Linux
when followed even if there's a degree of reverse engineerinng involved.

> The alternative to _DSD would be to program the hardware to some sane
> state. For example, I'm sure a MAC address can be written by firmware to
> some register and the driver can read and store it locally (I'm not even
> sure why we need MAC address in ACPI tables, this is not really a
> property of the hardware but a configuration that could be done in
> firmware).

On the other hand something like a MAC address is a useful placeholder
for discussion since there's no real debate about the technical aspects
of representing it allowing everyone to focus on the process.

> > +ASWG
> > +----
> > +The following areas are not yet fully defined for ARM in the 5.1 versi=
on
> > +of the ACPI specification and are expected to be worked through in the
> > +UEFI ACPI Specification Working Group (ASWG):

> > +   -- ACPI based CPU topology
> > +   -- ACPI based Power management
> > +   -- CPU idle control based on PSCI
> > +   -- CPU performance control (CPPC)
> > +   -- ACPI based SMMU
> > +   -- ITS support for GIC in MADT

> In addition to the above and _DSD requirements/banning, I would also add
> some clear statements around:

I'd not go that far with _DSD, I am unhappy with the current state of
the world but I'm not sure how relevant the process is going to be and
that anything more than a very strong disrecommendation is going to make
sense.

> Compatibility with older kernels: ACPI firmware must work, even though
> not fully optimal, with the earliest kernel version implementing the
> targeted ACPI spec. There may be a need for new drivers but otherwise
> adding things like CPU power management should not break older kernel
> versions. In addition, the ACPI firmware must also work with the latest
> kernel version.

The backwards compatibility thing sounds a bit strongly worded - I think
that's something the customers would probably sort out anyway to the
extent it's important.  It's obviously good to recommend that people
keep as much backwards compatibility as they can since if nothing else
it makes it easier for people to use their hardware but it doesn't seem
unreasonable to decide that supporting older kernels (or more to the
point older distro releases) isn't that interesting for whatever reason.

> I strongly consider that we need to be very strict with the Linux ACPI
> firmware and hardware requirements to avoid the need for supporting
> non-standard implementations as much as possible. This is, however, a
> live document, so we can relax it as we see fit (e.g. _DSD process
> clarified).

To the extent that it is specific to ARM server that should be fine,
however when it comes to actually enforcing standards for how the kernel
behaves then that's a different story - there are other communities with
different goals and interests.  This in turn means that there will be
things that actually practically work and that have become an ABI for
another community.  Once that happens I'm not sure it's constructive to
try to enforce not using them on ARM, and if people manage to ship
systems we care about it's game over anyway.

I don't know that it's reasonable to expect people to enforce this from
the kernel side - with my subsystem maintainer hat on I really don't
know that I care if some ACPI thing is being done for the benefit of an
ARM server or if it's being done for the benefit of an x86 embedded box
and I'm actually interested.

--Lz6jMTqI3BNRrqA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUnWE5AAoJECTWi3JdVIfQy5QH/iFLua955U23rMxMx/pr6iEC
2biH9Qmuc4JhN+qbI+Jodopg8Rg+ffHIJZlzhNcTod39rUsTU+q4NzFGqUqhAk8l
zq1PRR2KsizxeFS1hcbFqTYKgqcjaoqXqhL4PD9K7zx1NDmi72aH7iyLT7U8SU2k
SP2gATsbEfx2u2kG79zYTQwDID23dhAxqhHLFsm+7TH+pvvguRn0d6PcBsaNoQy9
16s9aZl+M7KUgdRFkOrUfWgGR9wN+f3KRe2AutK2jPA26n/ZI9unLHtl1y8SQLqK
el3NMwfK8SavoHt6Mjjx+SDH6dweX9b/yk1FgbJRWmdOO547k/qijJXy5v+TJac=
=LBsL
-----END PGP SIGNATURE-----

--Lz6jMTqI3BNRrqA1--
