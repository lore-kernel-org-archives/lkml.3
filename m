Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaJQOWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:22:14 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45295 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaJQOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:22:13 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi/atmel: add support for runtime PM
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
	<7hk33yhms4.fsf@deeprootsystems.com>
	<20141017135716.GS1820@sirena.org.uk>
Date: Fri, 17 Oct 2014 07:22:09 -0700
In-Reply-To: <20141017135716.GS1820@sirena.org.uk> (Mark Brown's message of
	"Fri, 17 Oct 2014 15:57:16 +0200")
Message-ID: <7hd29qhj3i.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@kernel.org> writes:

> On Fri, Oct 17, 2014 at 06:02:35AM -0700, Kevin Hilman wrote:
>> Wenyou Yang <wenyou.yang@atmel.com> writes:
>
>> > +	if (!pm_runtime_suspended(dev)) {
>> > +		clk_disable_unprepare(as->clk);
>> > +		pinctrl_pm_select_sleep_state(dev);
>> > +	}
>
>> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend() callback does
>> the same thing.
>
> Will that do the right thing when runtime PM is disabled in Kconfig?

Good point.

Then the way to make this cleaner, and obvious on inspection that system
suspend/resume are doing the same thing as runtime suspend/resume is to
have ->suspend call the runtime_suspend function.

The runtime suspend/resume functions then should be wrapped in CONFIG_PM
instead of CONFIG_PM_RUNTIME.

Kevin
