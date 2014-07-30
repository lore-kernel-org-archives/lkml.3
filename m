Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaG3JfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:35:05 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38831 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaG3JfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:35:01 -0400
Date: Wed, 30 Jul 2014 11:34:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 8/8] clk: tegra: Add EMC clock driver
Message-ID: <20140730093456.GA29590@ulmo>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-9-git-send-email-mperttunen@nvidia.com>
 <53CE97F2.80300@wwwdotorg.org>
 <53D75FA7.1030300@nvidia.com>
 <20140729201939.4627.79710@quantum>
 <53D81CD4.5010307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <53D81CD4.5010307@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 04:14:44PM -0600, Stephen Warren wrote:
> On 07/29/2014 02:19 PM, Mike Turquette wrote:
> >Quoting Mikko Perttunen (2014-07-29 01:47:35)
> >>On 22/07/14 19:57, Stephen Warren wrote:
> >>>On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> >>>>+static int emc_debug_rate_set(void *data, u64 rate)
> >>>>+{
> >>>>+    struct tegra_emc *tegra =3D data;
> >>>>+
> >>>>+    return clk_set_rate(tegra->hw.clk, rate);
> >>>>+}
> >>>>+
> >>>>+DEFINE_SIMPLE_ATTRIBUTE(emc_debug_rate_fops, emc_debug_rate_get,
> >>>>+                    emc_debug_rate_set, "%lld\n");
> >>>
> >>>I think the rate can already be obtained through
> >>>...debug/clock/clock_summary. I'm not sure about changing the rate, but
> >>>shouldn't that be a feature of the common clock core, not individual
> >>>drivers?
> >>
> >>The core doesn't allow writing to the rate debugfs files, so this is the
> >>only way to trigger an EMC clock change for now. I agree that the core
> >>might be a better place. I don't know if there are any philosophical
> >>objections to that. I'd like to keep this in until a possible core
> >>feature addition. Mike, any comments?
> >
> >Yes, there is a philosophical rejection to exposing rate-change knobs to
> >userspace through debugfs. These can and will ship in real products
> >(typically Android) with lots of nasty userspace hacks, and also
> >represent pretty dangerous things to expose to userspace. I have always
> >maintained that such knobs should remain out of tree or, with the advent
> >of the custom debugfs entries, should be burden of the clock drivers.
>=20
> That argument seems a bit inconsistent.
>=20
> I can see the argument to disallow code that lets user-space fiddle with
> clocks. However, if that argument holds, then surely it must apply to eit=
her
> the clock core *or* a clock driver; the end effect of allowing the code in
> either place is that people will be able to implement the user-space hacks
> you want to avoid. Yet, if we allow the code because it's a useful debug
> tool, then surely it should be in the clock core so we don't implement it
> redundantly in each clock driver.
>=20
> We could always taint the kernel if the feature is used. Admittedly that
> wouldn't stop people using the feature as a hack in Android/product kerne=
ls,
> but at least nobody would have to unknowingly debug problems due to such
> manipulation, in the context of an upstream kernel.

Not merging this feature upstream won't stop anybody from implementing
it as a hack in Android/product kernels either. If it's useful then
somebody will implement it in whatever downstream kernel they use. And
if it's useful to more than one vendor then we'll end up with a copy of
the implementation (and derivations on top) in each vendor's tree.

debugfs requires superuser privileges anyway, in which case you could
equally well write userspace software that directly bangs on the clock
controller registers.

Thierry

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2LxAAAoJEN0jrNd/PrOhxZoQAJk1fYmviE/GShQrR/7rWR2b
N+s9LxHjuqJGQBlqHlXWCE8Nr0WxwnIFgAU0SSqBXatgK/2rm5u0ZXYI8qtwHffF
FE0f3s6fRoQ48Gp9vAn6OwAlJoR+eJGf4hKEwLNW3oQmv7XhogRk0/Q2AI6v2B1c
+zJ8xNEbeoDb0qc3sNNbCzICmcEERtZ1IPS8a1FX8EZ58AtNCi+x5kVqRKfsZPEN
rnxlKK9+gT8kNIsnVtJUWlM8deLgLxJl/FWqHj+ckKSNREBf787KN+jSHhv7Q53r
Vr7sihutdQNcFYXpFMMD2xepkZ+jyxwkQBi+egEfduAr4pGujAxySVhRC/0f/XXP
ca3Ggy9bvkdt4bUGvfEyAT4ySMGtsdWlTqHarnoaCjPmd479LbFyhkljIIVcljqe
xTVZK5BXihAoVTxVMivPX0P3f8vW2uEX19WeAV/2RVv3dz81Q5CR9DsfLpHdcdJa
JiPFvzt+RQGuJIQq1+N+w93NAe0vIb2EUyATZ3aEazpPX/txEEE6sKEWAMRMV+Xg
a4HlRPpBSNgYyA6nbqVUd72lLC6wk1kCF3LROV3bSLjG/urM6NXl/hqE6JFhngky
UkRoLYeqKQ9Ds/EQFTB8y9D68dz/yAsKm3rpNadlBz1PkfgT9McHiGLCCUsVU8Mn
D2VmKh7SjAdTPbkuIV9V
=tuJw
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
