Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaGHJZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:25:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHJZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:25:21 -0400
Date: Tue, 8 Jul 2014 11:25:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Message-ID: <20140708092513.GB6758@twins.programming.kicks-ass.net>
References: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9uH70MWbZgudpa7t"
Content-Disposition: inline
In-Reply-To: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9uH70MWbZgudpa7t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 07, 2014 at 06:34:25AM -0700, kan.liang@intel.com wrote:
> +	/*
> +	 * Access LBR MSR may cause #GP under certain circumstances.
> +	 * E.g. KVM doesn't support LBR MSR
> +	 * Check all LBT MSR here.
> +	 * Disable LBR access if any LBR MSRs can not be accessed.
> +	 */
> +	if (x86_pmu.lbr_nr) {
> +		x86_pmu.lbr_msr_access = check_msr(x86_pmu.lbr_tos);
> +		for (i = 0; i < x86_pmu.lbr_nr; i++) {
> +			x86_pmu.lbr_msr_access &=
> +				check_msr(x86_pmu.lbr_from + i);
> +			x86_pmu.lbr_msr_access &=
> +				check_msr(x86_pmu.lbr_to + i);
> +		}
> +	}

So I was going to refer you to an email I send earlier telling you that
this was wrong, but then found it got stuck in a mailqueue on my laptop
:-(

In any case its wrong; just clear lbr_nr and kill lbr_msr_access. We
already check lbr_nr in all the right places and you added
lbr_msr_access to far too few of them (also the fact that every place
you check lbr_msr_access already had an lbr_nr test should've been a
clue).



--9uH70MWbZgudpa7t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu7j5AAoJEHZH4aRLwOS6tJIP/10OHJ0vI/W9HhrRX0yGPLUA
LdDfzUYzY4nrymxYi3j6qBvnyXoF28jSRJegx4bUOn1Dyw+jPV9hkLU2XaaHbfPF
tDooilqwC6BLvnKtd9I/dJjXstUSqNDdhOumiXU+Duq6E65LfuRwjeyuvyQj7WXZ
i3NKY3OEenrHb6bUf42xLARdB1JYt9OBTrKzzuqSbAfIstmERFByySmIE0oQwxvX
7pN7LUOzMd0HF+eL9xZpdIAZtBaAOuhewiibtK/+FHKyJtqVXtYpXFWW6zdQ7swd
64BjJG5B26AyWumbNbNPrLgVzivBWS9oVMZ00wc9AFsafckODXMNdPN/4xVGKOl+
Z/dXXzXJU/W+xJ7R7qxX2UMgFegJKpzQTK/ymVzaI2X32Ibt8tsY+1BGFHoM50V0
HnCZMvEXGOF2sYfPZ8w8FVD/WPSkDmQoI9EJl5kCLv3JCBxaStWtzMmuW0jv2Gr7
+mnpiL2geemfRGGZej4OPqaxNWo8bzm1y4y14RZWmUv9wR1wLZle0qSa14TTN1ws
mKSGeD9ijyZMgv1EfphNJLIgAgElolz3ijmWcYFIQPsIt3jYCwhAOugorxa8BNYn
y3veXZvo6qDTsaYz/J5k015h63M8WRtaTFrykRmw95PKiMJQvu21+sGYxlB/1uqu
oAedFwlR8xAzVk2jPiBd
=ecZb
-----END PGP SIGNATURE-----

--9uH70MWbZgudpa7t--
