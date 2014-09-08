Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaIHNMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:12:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaIHNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:12:46 -0400
Date: Mon, 8 Sep 2014 15:12:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 02/22] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20140908131230.GE6758@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140908070242.GS19379@twins.programming.kicks-ass.net>
 <87lhpuuztj.fsf@ashishki-desk.ger.corp.intel.com>
 <20140908113422.GD6758@twins.programming.kicks-ass.net>
 <87a96auv9s.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1EkNNaW82TX7EOeM"
Content-Disposition: inline
In-Reply-To: <87a96auv9s.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1EkNNaW82TX7EOeM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2014 at 03:55:11PM +0300, Alexander Shishkin wrote:

> Fair enough. Then I'd like to disable the ACTIVE ones before freeing AUX
> stuff and then re-enabling them since perf_event_{en,dis}able() already
> provide the convenient cross-cpu calls, which would also avoid
> concurrency between pmu::{add,del} callbacks and this unmap path. Makes
> sense?

But why? The buffer stuff is RCU freed, so if the hardware observes
pages and does get_page_unless_zero() on them its good. The memory will
not be freed from underneath the hardware writer because of the
get_page().

Then when the buffer is full and we 'swap', we'll find there is no next
buffer. At that point we can not provide a new buffer, effectively
stopping the hardware writes and release the old buffer, freeing the
memory.



--1EkNNaW82TX7EOeM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDas+AAoJEHZH4aRLwOS6ZlYP/079srURkOb/C0/8R/NkIljm
aCXJVewpnWEqGoA5WVI63iuTCX1pAgwCzBCVPAGuHDjPgYon6v9B8GlzKAP1DfVT
gdgXe//F8UATKNpMMxTvvetqny8DMz7NO+aU2Sm/NCKeHvpNens0ky/bvSIwROh2
9zOKKsTtH3MSq1Duu/QFg29CcsYjEe1GxbUUxEH4/tymGwKIUrzapi8jJtbPec/d
lF2GYVVhL0Kn5crgsI0jYJNRlzsE8WALFdf/lmoqqJePUkpmuiq+p8jsBsVERWCN
y48hKrjTJZQMU0+l9MBa0mVXx7e3mibqCoPJ9/Kxcc4J+38Qbzoex7jS+D6fn65u
wev//JAYkxLzecFQKHKvG29E2WuhpJOCytnMPjEGyty0vZwB56iPbYiq71+e0SBW
BH6/t24mjwORt4exJS/mz6NPgc1N0VI3aD0A+gAKpy0FpkdLda87vdtqCHxgJW/t
HvDxdSRXM4Okquwmo3ghQusBxhtvna1qhPUxNxcpgpOtOtVvu1e4Q/yN7ihsV/6C
XwE60PovBDKS3VzQwZbKETDApO+n07GFv4BbdwoObpL4HuC9ivlwx+W3A+BYkXpE
koCjrsg3xyoP+AvWBFR+Engk213hxbhivTnwdjNXWytIP9UpQIe6VpJASHnmUdwv
h01l8coTj4F58J3OB1+D
=I7ja
-----END PGP SIGNATURE-----

--1EkNNaW82TX7EOeM--
