Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3GYVD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:03:58 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58708 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3GYVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130722110341.GR9858@sirena.org.uk>
References: <1374361668-3184-1-git-send-email-andrea.adami@gmail.com>
	<20130722110341.GR9858@sirena.org.uk>
Date: Thu, 25 Jul 2013 23:03:52 +0200
Message-ID: <CAAQYJAteA2aQd5XRpi3NS-RazDoeWWbGFeUYcdP1kYc+sgmMUQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: pxamci: Refactor regulator support
From: Andrea Adami <andrea.adami@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marko Katic <dromede@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 1:03 PM, Mark Brown <broonie@kernel.org> wrote:
> On Sun, Jul 21, 2013 at 01:07:48AM +0200, Andrea Adami wrote:
>
>> The ADS7846 driver _requires_ the use of a voltage regulator
>> or if not present, CONFIG_REGULATOR_DUMMY should be used for proper operation.
>> This was made mandatory by the following commit:
>
> No, CONFIG_REGULATOR_DUMMY should *never* be used in production.
>
>> The ADS7846 in spitz machines is not connected to
>> any power regulator so it needs CONFIG_REGULATOR_DUMMY enabled.
>
> I don't think that's the case, it would be a very unusual piece of
> silicon that was able to operate without power.  It may be that it's not
> using a software controllable regulator but there will be one or more
> power supplies.  Judging by your problem here it seems like there is
> actually a software controllable regulator though...
>
>> However, enabling CONFIG_REGULATOR and CONFIG_REGULATOR_DUMMY
>> will break pxamci driver and cause the following error output:
>
> This is why you should never use CONFIG_REGULATOR_DUMMY in production,
> it's just a crutch to help things boot during development.
>
>> Regulator support in pxamci_init_ocr() is not
>> written with the existence of the dummy regulator driver in
>> mind. It does not check the return value of mmc_regulator_get_ocrmask()
>> and it will only fall back to platform data if no regulator was found.
>
> No regulator driver should be written with CONFIG_REGULATOR_DUMMY in
> mind.  My guess here is that your custom callbacks for this board should
> be being replaced by a regulator, for example the fixed voltage
> regulator if there's only one voltage supported.


Thanks Mark,

patch is withdrawn.

In fact adding regulators has been self-inflicted pain...
Poodle and spitz boot normally with # CONFIG_REGULATOR is not set.

Sorry for the noise

Andrea Adami
