Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaJTCGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:06:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:42864 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaJTCGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:06:40 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Kevin Hilman <khilman@kernel.org>, Mark Brown <broonie@kernel.org>
CC: "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] spi/atmel: add support for runtime PM
Thread-Topic: [PATCH] spi/atmel: add support for runtime PM
Thread-Index: AQHP6hW83LvTFspzlkWsWVFQ1Yxkwpw4PtKQ
Date: Mon, 20 Oct 2014 02:05:42 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF594F37@penmbx01>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
	<7hk33yhms4.fsf@deeprootsystems.com>	<20141017135716.GS1820@sirena.org.uk>
 <7hd29qhj3i.fsf@deeprootsystems.com>
In-Reply-To: <7hd29qhj3i.fsf@deeprootsystems.com>
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



> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@kernel.org]
> Sent: Friday, October 17, 2014 10:22 PM
> To: Mark Brown
> Cc: Yang, Wenyou; linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] spi/atmel: add support for runtime PM
> 
> Mark Brown <broonie@kernel.org> writes:
> 
> > On Fri, Oct 17, 2014 at 06:02:35AM -0700, Kevin Hilman wrote:
> >> Wenyou Yang <wenyou.yang@atmel.com> writes:
> >
> >> > +	if (!pm_runtime_suspended(dev)) {
> >> > +		clk_disable_unprepare(as->clk);
> >> > +		pinctrl_pm_select_sleep_state(dev);
> >> > +	}
> >
> >> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend() callback
> >> does the same thing.
> >
> > Will that do the right thing when runtime PM is disabled in Kconfig?
> 
> Good point.
> 
> Then the way to make this cleaner, and obvious on inspection that system
> suspend/resume are doing the same thing as runtime suspend/resume is to have -
> >suspend call the runtime_suspend function.
> 
> The runtime suspend/resume functions then should be wrapped in CONFIG_PM
> instead of CONFIG_PM_RUNTIME.
But if the runtime PM is disabled,  __pm_runtime_idle() return -ENOSYS, which invoked by pm_runtime_put_sync(), in spite of the runtime suspend/resume functions wrapper,

> 
> Kevin

Best Regards,
Wenyou Yang
