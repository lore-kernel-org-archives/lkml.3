Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbaGYQ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:58:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:48472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaGYQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:58:20 -0400
Date: Fri, 25 Jul 2014 18:58:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140725165810.GG6758@twins.programming.kicks-ass.net>
References: <20140724212620.GO3935@laptop>
 <20140725124037.GL20603@laptop.programming.kicks-ass.net>
 <20140725132541.GT12054@laptop.lan>
 <2870044.iEzUSaptji@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x6I3On15oG0ucwLF"
Content-Disposition: inline
In-Reply-To: <2870044.iEzUSaptji@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x6I3On15oG0ucwLF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 07:03:38PM +0200, Rafael J. Wysocki wrote:
> So here's an idea.
>=20
> What about returning IRQ_NONE rather than IRQ_HANDLED for "suspended"
> interrupts (after all, that's what a sane driver would do for a
> suspended device I suppose)?
>=20
> If the line is really shared and the interrupt is taken care of by
> the other guy sharing the line, we'll be all fine.
>=20
> If that is not the case, on the other hand, and something's really
> broken, we'll end up disabling the interrupt and marking it as
> IRQS_SPURIOUS_DISABLED (if I understand things correctly).
>=20
> But then, we can re-enable it and clear the IRQS_SPURIOUS_DISABLED
> flag at the resume_device_irqs() time so the driver can use it again.
> And we'll have a trace of the breakage in dmesg, so possibly we can
> go forth and fix the bad guy.
>=20
> Would that make sense?

Works for me..=20

--x6I3On15oG0ucwLF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0oyhAAoJEHZH4aRLwOS62hwP/RA9M2thJ65Ak6iwKnuaj4NQ
xAU/ZxiDISJl89pJS5DjdjSAukpBHrxhwR0nKuq721hug9ZOtkIJ+GQww/k39q62
GoYlhKcxifnqCvkC1my8xsRQKaiwvO4rpeh0UNAvgSz/t/RDGt6kuO0XjeJE6UD4
PClvbUfTKRYSRkBwOXdxemm+/WlMqGznFJVtxIUpuWnZQN2JOVbwmi0rjMDKWk/8
523N0jOV8hPBBdEcNXKDVBErkX6JXoPCeTvoDVE7xMslwJspfvbmKgKz0mDcbAH9
0yWpjSCbp7FWPLedI8TlWJkYf+lOJEoWc+gUz1s1nQ0eJ96HOM4fpF2fGbE0WF04
YZHfN2yD5HP7CzCTJMN4NubwrF17jy8gtacQ6CWgrpm2GdT6xhfOljHixAhDE55Q
dcWMMfVzeeGMCmrnqgEGjgrgTFiD/hYg8r0DJLlJp8xY01dURHP1wFWTQfecfaVu
8T9RJziEx1ReRwhvVrbdb99C/vo9EzH4Bb5pUDxLhNS7DJNamvunu5KHFl5uFwfm
HBex9AApnovUR5HyIQA8QnW9zVtUx+KYHFaF9NzglWbokvDL6XOGAVkj0IKI7Pa8
K9RdKdOCS3bHd9XWyqIopwN40Xs7yOzURhrkqh8V1/YIckQjwQGM+D1OFwwoQM7N
jrpzWEidWjmLp/d9OIlH
=J5lO
-----END PGP SIGNATURE-----

--x6I3On15oG0ucwLF--
