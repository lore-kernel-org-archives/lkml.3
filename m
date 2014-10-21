Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaJUA4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:56:42 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:57599 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753386AbaJUA4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:56:41 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2014 20:56:40 EDT
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Kevin Hilman <khilman@kernel.org>
CC: Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] spi/atmel: add support for runtime PM
Thread-Topic: [PATCH] spi/atmel: add support for runtime PM
Thread-Index: AQHP7JD33LvTFspzlkWsWVFQ1Yxkwpw5uMZg
Date: Tue, 21 Oct 2014 00:51:20 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF59671F@penmbx01>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
	<7hk33yhms4.fsf@deeprootsystems.com>	<20141017135716.GS1820@sirena.org.uk>
	<7hd29qhj3i.fsf@deeprootsystems.com>
	<B256D81BAE5131468A838E5D7A243641BF594F37@penmbx01>
 <7hd29mfwa8.fsf@deeprootsystems.com>
In-Reply-To: <7hd29mfwa8.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@kernel.org]
> Sent: Tuesday, October 21, 2014 2:09 AM
> To: Yang, Wenyou
> Cc: Mark Brown; linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] spi/atmel: add support for runtime PM
> 
> "Yang, Wenyou" <Wenyou.Yang@atmel.com> writes:
> 
> >> -----Original Message-----
> >> From: Kevin Hilman [mailto:khilman@kernel.org]
> >> Sent: Friday, October 17, 2014 10:22 PM
> >> To: Mark Brown
> >> Cc: Yang, Wenyou; linux-spi@vger.kernel.org;
> >> linux-kernel@vger.kernel.org; Ferre, Nicolas;
> >> linux-arm-kernel@lists.infradead.org
> >> Subject: Re: [PATCH] spi/atmel: add support for runtime PM
> >>
> >> Mark Brown <broonie@kernel.org> writes:
> >>
> >> > On Fri, Oct 17, 2014 at 06:02:35AM -0700, Kevin Hilman wrote:
> >> >> Wenyou Yang <wenyou.yang@atmel.com> writes:
> >> >
> >> >> > +	if (!pm_runtime_suspended(dev)) {
> >> >> > +		clk_disable_unprepare(as->clk);
> >> >> > +		pinctrl_pm_select_sleep_state(dev);
> >> >> > +	}
> >> >
> >> >> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend()
> >> >> callback does the same thing.
> >> >
> >> > Will that do the right thing when runtime PM is disabled in Kconfig?
> >>
> >> Good point.
> >>
> >> Then the way to make this cleaner, and obvious on inspection that
> >> system suspend/resume are doing the same thing as runtime
> >> suspend/resume is to have -
> >> >suspend call the runtime_suspend function.
> >>
> >> The runtime suspend/resume functions then should be wrapped in
> >> CONFIG_PM instead of CONFIG_PM_RUNTIME.
> > But if the runtime PM is disabled, __pm_runtime_idle() return -ENOSYS,
> > which invoked by pm_runtime_put_sync(), in spite of the runtime
> > suspend/resume functions wrapper,
> 
> You won't be calling _put_sync(), instead you'll just directly call
> atmel_spi_runtime_suspend().
Got it , I will change it. Thanks.

> 
> The goal is to make it obvious upon reading that ->suspend and
> ->runtime_suspend are doing exactly the same thing.
> 
> Kevin

Best Regards,
Wenyou Yang
