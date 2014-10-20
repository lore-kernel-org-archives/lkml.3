Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaJTSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:09:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36052 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJTSJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:09:23 -0400
From: Kevin Hilman <khilman@kernel.org>
To: "Yang\, Wenyou" <Wenyou.Yang@atmel.com>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-spi\@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre\, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] spi/atmel: add support for runtime PM
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
	<7hk33yhms4.fsf@deeprootsystems.com>
	<20141017135716.GS1820@sirena.org.uk>
	<7hd29qhj3i.fsf@deeprootsystems.com>
	<B256D81BAE5131468A838E5D7A243641BF594F37@penmbx01>
Date: Mon, 20 Oct 2014 11:09:19 -0700
In-Reply-To: <B256D81BAE5131468A838E5D7A243641BF594F37@penmbx01> (Wenyou
	Yang's message of "Mon, 20 Oct 2014 02:05:42 +0000")
Message-ID: <7hd29mfwa8.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yang, Wenyou" <Wenyou.Yang@atmel.com> writes:

>> -----Original Message-----
>> From: Kevin Hilman [mailto:khilman@kernel.org]
>> Sent: Friday, October 17, 2014 10:22 PM
>> To: Mark Brown
>> Cc: Yang, Wenyou; linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre,
>> Nicolas; linux-arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH] spi/atmel: add support for runtime PM
>> 
>> Mark Brown <broonie@kernel.org> writes:
>> 
>> > On Fri, Oct 17, 2014 at 06:02:35AM -0700, Kevin Hilman wrote:
>> >> Wenyou Yang <wenyou.yang@atmel.com> writes:
>> >
>> >> > +	if (!pm_runtime_suspended(dev)) {
>> >> > +		clk_disable_unprepare(as->clk);
>> >> > +		pinctrl_pm_select_sleep_state(dev);
>> >> > +	}
>> >
>> >> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend() callback
>> >> does the same thing.
>> >
>> > Will that do the right thing when runtime PM is disabled in Kconfig?
>> 
>> Good point.
>> 
>> Then the way to make this cleaner, and obvious on inspection that system
>> suspend/resume are doing the same thing as runtime suspend/resume is to have -
>> >suspend call the runtime_suspend function.
>> 
>> The runtime suspend/resume functions then should be wrapped in CONFIG_PM
>> instead of CONFIG_PM_RUNTIME.
> But if the runtime PM is disabled, __pm_runtime_idle() return -ENOSYS,
> which invoked by pm_runtime_put_sync(), in spite of the runtime
> suspend/resume functions wrapper,

You won't be calling _put_sync(), instead you'll just directly call
atmel_spi_runtime_suspend().

The goal is to make it obvious upon reading that ->suspend and
->runtime_suspend are doing exactly the same thing.

Kevin

