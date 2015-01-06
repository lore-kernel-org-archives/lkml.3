Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbbAFOXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:23:25 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56756 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbAFOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:23:23 -0500
Date: Tue, 6 Jan 2015 15:23:18 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150106142317.GK31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <54AB445D.7010303@nvidia.com>
 <20150106111538.GB31830@ulmo.nvidia.com>
 <54ABCEF7.5080909@nvidia.com>
 <20150106132930.GH31830@ulmo.nvidia.com>
 <20150106135110.GA18076@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mZBmBd1ZkdwT1ny"
Content-Disposition: inline
In-Reply-To: <20150106135110.GA18076@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mZBmBd1ZkdwT1ny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 09:51:11PM +0800, Vince Hsu wrote:
> On 02:29:32PM Jan 06, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Tue, Jan 06, 2015 at 08:03:03PM +0800, Vince Hsu wrote:
> > > On 01/06/2015 07:15 PM, Thierry Reding wrote:
> > > >> Old Signed by an unknown key
> > > >
> > > >On Tue, Jan 06, 2015 at 10:11:41AM +0800, Vince Hsu wrote:
> > > >>On 01/05/2015 11:09 PM, Thierry Reding wrote:
> > > >>>>Old Signed by an unknown key
> > > >>>On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
> > > >>>>On 12/24/2014 09:16 PM, Lucas Stach wrote:
> > > >>>>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> > > >>>>>>The Tegra124 and later Tegra SoCs have a sepatate rail gating r=
egister
> > > >>>>>>to enable/disable the clamp. The original function
> > > >>>>>>tegra_powergate_remove_clamping() is not sufficient for the ena=
ble
> > > >>>>>>function. So add a new function which is dedicated to the GPU r=
ail
> > > >>>>>>gating. Also don't refer to the powergate ID since the GPU ID m=
akes no
> > > >>>>>>sense here.
> > > >>>>>>
> > > >>>>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> > > >>>>>To be honest I don't see the point of this patch.
> > > >>>>>You are bloating the PMC interface by introducing another export=
ed
> > > >>>>>function that does nothing different than what the current funct=
ion
> > > >>>>>already does.
> > > >>>>>
> > > >>>>>If you need a way to assert the clamp I would have expected you =
to
> > > >>>>>introduce a common function to do this for all power partitions.
> > > >>>>I thought about adding an tegra_powergate_assert_clamping(), but =
that
> > > >>>>doesn't make sense to all the power partitions except GPU. Note t=
he
> > > >>>>difference in TRM. Any suggestion for the common function?
> > > >>>I don't think extending the powergate API is useful at this point.=
 We've
> > > >>>long had an open TODO item to replace this with a generic API. I d=
id
> > > >>>some prototyping a while ago to use generic power domains for this=
, that
> > > >>>way all the details and dependencies between the partitions could =
be
> > > >>>properly modeled.
> > > >>>
> > > >>>Can you take a look at my staging/powergate branch here:
> > > >>>
> > > >>>	https://github.com/thierryreding/linux/commits/staging/powergate
> > > >>>
> > > >>>and see if you can use that instead? The idea is to completely hid=
e the
> > > >>>details of power partitions from drivers and use runtime PM instea=
d.
> > > >>You generic power domains work is exactly what we want for powergate
> > > >>eventually. :) I recall we used your prototyping in somewhere inter=
nal tree.
> > > >>We have to add more to complete it though, e.g. power domain depend=
ency, mc
> > > >>flush, and clamping register difference like this patch does.
> > > >>
> > > >>But I have a question here. Since the GK20A is not powered on/off b=
y the PMC
> > > >>except the clamping control, and GK20A has its own power rail, do w=
e really
> > > >>want to hide the power sequence in the generic powergate code? We s=
till have
> > > >>to control the voltage level in the GK20A driver through the regula=
tor
> > > >>framework. It seems weird to me if we put the regulator_{enable|dis=
able}
> > > >>somewhere other than the GK20A driver.
> > > >I think we want both. The power domain to control the power partition
> > > >and the regulator in the gk20a driver for the voltage control.
> > > Do you mean excluding the power sequence of GK20A from the generic po=
wer
> > > domain?
> >=20
> > No, what I mean is move the power gating into the PMC driver as part of
> > the generic power domain implementation. At the same time, keep the
> > control of the regulator within the gk20a driver. That way we can use
> > runtime PM to control the powergating but we can still control the GPU
> > voltage within Nouveau.
> Okay. Do you insist to introduce the generic power domain at this moment?
> If so, I can try to continue your previous work and rebase this series on
> that. That might take some time though.

Yes, I'm leaning strongly towards doing that conversion now. The problem
with extending the reset API with flushing is that it will make the
conversion more difficult than it already is. I'm not even sure we can
go through with the conversion without breaking DT ABI stability yet
again. We may be able to do so by keeping the current code as fallback
if we can determine that no power domain is added (dev->pm_domain?). But
adding tegra_mc_flush() calls everywhere now will mean that we have to
keep even more fallback code, basically forever.

I know this is going to take some time, but the longer we defer this the
more work it will become. And we've already been pushing this back for
over a year.

Thierry

--5mZBmBd1ZkdwT1ny
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq+/VAAoJEN0jrNd/PrOhe+oQALQSwJnNBynhuBP24oLj1NIZ
Wk/K/t3jKvstnAbjg/tYUKVsh8Y3ZTwIDQdmYLl1li9kMLkdduFMxzfaIzr/I+ky
MthKNvTe/mwmPsNSR8ZPLGHeghySErTmSS8AjFO6DO3/CDaysrq1vyk9GM7jYQFz
WY/pjvqlPRKPV06ufIeu2ISirwUL5GGAIkIzdSj+5ORK+u7sWYPA3V+rprlWMhxu
w+OP266N8ZSbrcVIbLU01xD/zTMPUR4kn2tbRvTJAjLNCWoZiYo2uKUyFqXDk2ym
5NkB+LB4eJUETyg+XUa9s6kSD/J1RX2Q/OTiqq2tS49I670z/7B6jvYbLbi1RzHU
BAABYp8Ee2NLthVdmw0OT24D7P6yHHeL3L+T5eSywCuy8Y2/vF1NBmxXL6DbcShq
CLmhz9sJz1SabMB9TYE/05wHgj78JvUZSqvH1Knt7pQGGSQZ75C6cJDcQojGH+L8
/Qzu2xP8ghua4zktfOdpLZLPlXJoP5AGI+Lb3FDJZ2QINO/y3wQqm8+Smqu5B4mj
+Uh4y1dWpiO9ToXPaT9nXLzmUk0P5ZUxpFDf+2Tske68MXSH2+3HoasZZsC0IIJ6
N2bCKbf/gEcrJeFQdGdCvwfV9U50zKgGOxIT0DTdDSOrIp2/YILLFHd++tfHweA5
bkJfj+6WkSPDbw4BKVjS
=ruv6
-----END PGP SIGNATURE-----

--5mZBmBd1ZkdwT1ny--
