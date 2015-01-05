Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbbAEPJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:09:41 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39471 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbAEPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:09:39 -0500
Date: Mon, 5 Jan 2015 16:09:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Lucas Stach <dev@lynxeye.de>, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150105150932.GG12010@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zGQnqpIoxlsbsOfg"
Content-Disposition: inline
In-Reply-To: <549B7638.2010405@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zGQnqpIoxlsbsOfg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
> On 12/24/2014 09:16 PM, Lucas Stach wrote:
> >Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> >>The Tegra124 and later Tegra SoCs have a sepatate rail gating register
> >>to enable/disable the clamp. The original function
> >>tegra_powergate_remove_clamping() is not sufficient for the enable
> >>function. So add a new function which is dedicated to the GPU rail
> >>gating. Also don't refer to the powergate ID since the GPU ID makes no
> >>sense here.
> >>
> >>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> >To be honest I don't see the point of this patch.
> >You are bloating the PMC interface by introducing another exported
> >function that does nothing different than what the current function
> >already does.
> >
> >If you need a way to assert the clamp I would have expected you to
> >introduce a common function to do this for all power partitions.
> I thought about adding an tegra_powergate_assert_clamping(), but that
> doesn't make sense to all the power partitions except GPU. Note the
> difference in TRM. Any suggestion for the common function?

I don't think extending the powergate API is useful at this point. We've
long had an open TODO item to replace this with a generic API. I did
some prototyping a while ago to use generic power domains for this, that
way all the details and dependencies between the partitions could be
properly modeled.

Can you take a look at my staging/powergate branch here:

	https://github.com/thierryreding/linux/commits/staging/powergate

and see if you can use that instead? The idea is to completely hide the
details of power partitions from drivers and use runtime PM instead.

Also adding Peter whom I had discussed this with earlier. Can we finally
get this converted? I'd rather not keep complicating this custom API to
avoid making the conversion even more difficult.

Thierry

--zGQnqpIoxlsbsOfg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUqqksAAoJEN0jrNd/PrOh9IQP/06/s1WNBwdKN36x3wBgK7sa
Gw4BMvJWZcZQ9+Hz/dg/6BzrFHwx+cK+Mpx+fiDkx00TCey7blspXk+D/R25G0jr
OsAiw4eERfBPRQKvRtdLMv/LP51D2dkx/P+Fl/KqDWDPMLGXryv1EhPL3m6knNQh
fYUEh7Be68bV2jtyrtcnGGPPDLDe1i0EB6WNWNLMTD03cxAqf6gkpuwV3eS3i3/e
astnISvfUQ87b8bRdkbsDzT0LPccCthyV12xLSep/dVjnDPlFxdFQC9HEYJGUcrT
iyuNLMrooIXWznzSFmjjVyn09V6OGwW3h0mj7uCLRWY2vZewB+x5c16y+h1EpOlM
6LdBEns/Z1/Sii5cdjPCUeQ/JGCKV+eER3t+pkgY13FW8jceE+xdBx1rmwTf6pjy
4BkPViJgLkDYeD+90ZSNQvPFrHzCcefa+iQ/HuCUmLzo6EDl94Inb1B6gjhMKeBh
MOnY5IpzkFtwQmTL3m1+45RLXd/oDcVjSRR7eG4SR+yk1CMaGbAHNJVj8QLvC1Sw
0EFMzte8s7QhlaQVS4mb/6c9KfQUTZXjGqifIVzhBmWN06lkTYOeuKxV3qXBFQpW
vywD18RUddAAUgGNtIzQMwDYr+FLAGkWToyiGe+6fsYNMOLgDmhcwXAAnDBDJQ4d
utQCuy9RSR6B9mM+2Ipk
=fb4R
-----END PGP SIGNATURE-----

--zGQnqpIoxlsbsOfg--
