Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3FGRGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:06:32 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:47097 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3FGRGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:06:30 -0400
Date: Fri, 7 Jun 2013 17:06:29 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
cc: linux-tegra@vger.kernel.org, mturquette@linaro.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
In-Reply-To: <51B21105.1080301@wwwdotorg.org>
Message-ID: <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com>
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1307264298-1370624789=:7753"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1307264298-1370624789=:7753
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Stephen,

On Fri, 7 Jun 2013, Stephen Warren wrote:

> On 06/07/2013 06:19 AM, Paul Walmsley wrote:
> > Add DFLL DVCO reset line control functions to the CAR IP block driver.
> >=20
> > The DVCO present in the DFLL IP block has a separate reset line,
> > exposed via the CAR IP block.  This reset line is asserted upon SoC
> > reset.  Unless something (such as the DFLL driver) deasserts this
> > line, the DVCO will not oscillate, although reads and writes to the
> > DFLL IP block will complete.
> >=20
> > Thanks to Aleksandr Frid <afrid@nvidia.com> for identifying this and
> > saving hours of debugging time.
>=20
> > diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
>=20
> >  void tegra114_clock_tune_cpu_trimmers_high(void);
> >  void tegra114_clock_tune_cpu_trimmers_low(void);
> >  void tegra114_clock_tune_cpu_trimmers_init(void);
> > +void tegra114_clock_assert_dfll_dvco_reset(void);
> > +void tegra114_clock_deassert_dfll_dvco_reset(void);
>=20
> Where/what is the code that will call these new APIs? If it's going to
> be something in drivers/clk, that seems fine.

That's correct - they'll be used by the DFLL clocksource code, which will=
=20
live in drivers/clk/tegra.  You've seen the patches already ;-)

> The reset assert/de-assert functions at least might be worth exposing
> using the new generic module reset API. I believe Prashant Gaikwad is
> working on converting the Tegra clock driver to be a module reset
> provider, hence removing the existing custom
> tegra_periph_reset_{de,}assert() APIs.

OK, will take a look to see if this can be done without getting in the way=
=20
of Prashant's work.  I'd na=C3=AFvely assume that it might be best to conve=
rt=20
these as part of his series - that way we won't duplicate effort.

Prashant, what stage are you at in the conversion?  If you're close to=20
completion, maybe we can just add this functionality in with your patches?


- Paul
--843723315-1307264298-1370624789=:7753--
