Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab3BHTIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:08:25 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:56931 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760288Ab3BHTIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:08:24 -0500
Date: Fri, 8 Feb 2013 14:08:19 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.2.38
Message-ID: <20130208190819.GA16894@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
 <20130207173630.GA8355@roll>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20130207173630.GA8355@roll>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	I just wanted to give a heads up so you knew where I'm at and that I
haven't forgotten to do the bisection. Well, I'm doing the bisection - and
it's having me chase wild geese. This bug is apparently not always occuring
when it's possible for it to, confusing the issue.

	Currently I'm recompiling 3.2.37 from scratch to ensure that my
environment or hardware hasn't changed somehow since I originally built it
and is causing some of my kernel compiles to miscompile or something.  If
that build turns out okay I'll try bisecting again and see if I get anywhere
different than before.

Despite it obviously leading off into wild goose chasing territory, I think
it's possible this could be illuminating for someone with more experience
with bisect than I, so I'm including the bisect log below.

git bisect start
# bad: [8eedd52017a07a5bae2aded2b5023bfba5971af9] Linux 3.2.38
git bisect bad 8eedd52017a07a5bae2aded2b5023bfba5971af9
# good: [2d18772602ba45629dfd4ffe1878ecb26fb3d3ed] Linux 3.2.37
git bisect good 2d18772602ba45629dfd4ffe1878ecb26fb3d3ed
# good: [157bb66c87286abc3dad2ed19a8cfb130ef24573] USB: option: add TP-LINK HSUPA Modem MA180
git bisect good 157bb66c87286abc3dad2ed19a8cfb130ef24573
# good: [6fad7bfb8aef9a8688d3d3b3ea917b3c7d1fc8b7] can: ti_hecc: fix invalid error codes
git bisect good 6fad7bfb8aef9a8688d3d3b3ea917b3c7d1fc8b7
# good: [8bdb5d1a2d352d58ac99be529bb8c006dfb9be83] sd: Reshuffle init_sd to avoid crash
git bisect good 8bdb5d1a2d352d58ac99be529bb8c006dfb9be83
# bad: [8a6d0db2f6a06c5fdfb7a208002d0f9961d1ad41] intel-iommu: Prevent devices with RMRRs from being placed into SI Domain
git bisect bad 8a6d0db2f6a06c5fdfb7a208002d0f9961d1ad41
# bad: [756a6d71c4f566f840cf4e04fe2540e6927d2613] x86: Use enum instead of literals for trap values
git bisect bad 756a6d71c4f566f840cf4e04fe2540e6927d2613
# good: [9a1f08a1a192f9177d7063d903773aed800b840f] drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
git bisect good 9a1f08a1a192f9177d7063d903773aed800b840f
# bad: [a423a71dafbcd05bc263f9eb42c142e4b869ed95] drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
git bisect bad a423a71dafbcd05bc263f9eb42c142e4b869ed95

Now, here's the thing - that last bad entry is the one that bisect is
convinced is the bad patch. Problem is, I don't have that hardware, so it
strains belief that it could be the cause. I even went so far as to checkout
a clean copy of 3.2.38 and reverse apply that particular patch for testing
on top of it - and I still have the problem.

Any suggestions on how to proceed would be appreciated in case I've missed
some git magic that would make this easier.

Tim McGrath

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBURVNI5EncCrqzVruAQK8lAf/cnSywDM0aTNYHmhlTidyxkAGakLBA120
RX9KhsWXIepyZsXvcdQeRsgZK/94dRMmKo0slJ6IEy10BOza/PLV7jfL4+vkRWG3
yt5pXB5k/Sx0vJPb9IRAI6q04ADy0NiaEQ7yFbDsyr0KRFhwpg8BQPrj9HGDTjCF
bOg5hHuT5krlW4+VINSTpBLkdWKjWr7PMwPVpzW+bGZrlHn8Kml1Jj/cxpcfn8+N
M/+4Odbq197YTz+8xhJrjh066CVGqsS612el7ytXCI0/GvrvjF7J3fPDpwPf5p+7
GheQI8YdrjqF1UXcIvui/COxM735A2D9/wnkNZQoIvL5I3cIBUDXXA==
=ajhw
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
