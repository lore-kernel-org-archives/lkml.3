Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbbAFN3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:29:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60620 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbbAFN3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:29:37 -0500
Date: Tue, 6 Jan 2015 14:29:32 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150106132930.GH31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <54AB445D.7010303@nvidia.com>
 <20150106111538.GB31830@ulmo.nvidia.com>
 <54ABCEF7.5080909@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EemXnrF2ob+xzFeB"
Content-Disposition: inline
In-Reply-To: <54ABCEF7.5080909@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 08:03:03PM +0800, Vince Hsu wrote:
> On 01/06/2015 07:15 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Tue, Jan 06, 2015 at 10:11:41AM +0800, Vince Hsu wrote:
> >>On 01/05/2015 11:09 PM, Thierry Reding wrote:
> >>>>Old Signed by an unknown key
> >>>On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
> >>>>On 12/24/2014 09:16 PM, Lucas Stach wrote:
> >>>>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> >>>>>>The Tegra124 and later Tegra SoCs have a sepatate rail gating register
> >>>>>>to enable/disable the clamp. The original function
> >>>>>>tegra_powergate_remove_clamping() is not sufficient for the enable
> >>>>>>function. So add a new function which is dedicated to the GPU rail
> >>>>>>gating. Also don't refer to the powergate ID since the GPU ID makes no
> >>>>>>sense here.
> >>>>>>
> >>>>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> >>>>>To be honest I don't see the point of this patch.
> >>>>>You are bloating the PMC interface by introducing another exported
> >>>>>function that does nothing different than what the current function
> >>>>>already does.
> >>>>>
> >>>>>If you need a way to assert the clamp I would have expected you to
> >>>>>introduce a common function to do this for all power partitions.
> >>>>I thought about adding an tegra_powergate_assert_clamping(), but that
> >>>>doesn't make sense to all the power partitions except GPU. Note the
> >>>>difference in TRM. Any suggestion for the common function?
> >>>I don't think extending the powergate API is useful at this point. We've
> >>>long had an open TODO item to replace this with a generic API. I did
> >>>some prototyping a while ago to use generic power domains for this, that
> >>>way all the details and dependencies between the partitions could be
> >>>properly modeled.
> >>>
> >>>Can you take a look at my staging/powergate branch here:
> >>>
> >>>	https://github.com/thierryreding/linux/commits/staging/powergate
> >>>
> >>>and see if you can use that instead? The idea is to completely hide the
> >>>details of power partitions from drivers and use runtime PM instead.
> >>You generic power domains work is exactly what we want for powergate
> >>eventually. :) I recall we used your prototyping in somewhere internal tree.
> >>We have to add more to complete it though, e.g. power domain dependency, mc
> >>flush, and clamping register difference like this patch does.
> >>
> >>But I have a question here. Since the GK20A is not powered on/off by the PMC
> >>except the clamping control, and GK20A has its own power rail, do we really
> >>want to hide the power sequence in the generic powergate code? We still have
> >>to control the voltage level in the GK20A driver through the regulator
> >>framework. It seems weird to me if we put the regulator_{enable|disable}
> >>somewhere other than the GK20A driver.
> >I think we want both. The power domain to control the power partition
> >and the regulator in the gk20a driver for the voltage control.
> Do you mean excluding the power sequence of GK20A from the generic power
> domain?

No, what I mean is move the power gating into the PMC driver as part of
the generic power domain implementation. At the same time, keep the
control of the regulator within the gk20a driver. That way we can use
runtime PM to control the powergating but we can still control the GPU
voltage within Nouveau.

Thierry

--EemXnrF2ob+xzFeB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq+M6AAoJEN0jrNd/PrOhm7AQAJ5MnHuzkk861QJ7FjpQ7jw9
BMJhdgtzHBkBA0D6jHubWU1O6G7XHOFlp99D2t+XuKiHwW9c6qslIjNQeK5c4+/r
gDXgEdkI++MA2kE8HgwhqnUadxvDA8kaOtwxO6+gskfYopnh0V+AxODcdRa3vBAH
ugF0briydpi5vYUuceQw2WZRXWBoIrNkf3R15txtNBHwskbXyFlKvPeKDfJ9LljT
9tLhn1+mrDj36S/9HCBQBMrc4yMUoiwrdvBd40XUPVpNnEisirCeeNaoEX7Lv5NO
0U/QdXtRHzPURSeCNcdbVlzSsC1Vesu5uCdQCWpgXot3bkvCAvzuN72TTI34w/vG
pF4xt2YwVzMsC5z+b7lI4ESrMAqolvYFraagbxMy/dQeAXRmF0TCqPbfJ7p7i/fB
z4XPptksUjjtt48nW92krCL5pD/i7T7qBDsHO9MOg7iuXOS2+kUxuTSVBgJjeAEZ
819OL9gQFhSDcvgOb4113lkCOCYe/3DWeHAbuwe6PbN2mJjNzwNInrkYdt1Z8rFd
C6sEZc+W+BiPwy0BENxQ58WScCiHVq8Inmrr+GuXiB6vxpbekHh9m2FLLFgyoQYS
vMSGtywC8LLMozsSBnYzuV2amy7GPU25LcJlqlXVNqgaBwHAN6eDfgod2YWPaCJ+
FsLu+shNq3/psWfQQUzC
=BicE
-----END PGP SIGNATURE-----

--EemXnrF2ob+xzFeB--
