Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaKYV1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:27:48 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:58143 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKYV1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:27:47 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:15a:f022:8a22:e273]
In-Reply-To: <20141125211431.GP7712@sirena.org.uk>
References: <5474E91E.6000401@metafoo.de>
	<1416949399-29718-1-git-send-email-olof@lixom.net>
	<20141125211431.GP7712@sirena.org.uk>
Date: Tue, 25 Nov 2014 13:27:46 -0800
Message-ID: <CAOesGMjjOV2dQaLzzEsGpp8dFn7_gDZRLtNOrT7xd1C20YfMtg@mail.gmail.com>
Subject: Re: [PATCH v2] regmap: provide dummy regmap_exit()
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 1:14 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Nov 25, 2014 at 01:03:19PM -0800, Olof Johansson wrote:
>> Fixes build error:
>>
>> sound/soc/soc-core.c: In function 'snd_soc_component_exit_regmap':
>> sound/soc/soc-core.c:2644:2: error: implicit declaration of function 'regmap_exit' [-Werror=implicit-function-declaration]
>>   regmap_exit(component->regmap);
>
> In which configuration?

eseries_pxa_defconfig

>> Due to the other regmap functions providing appropriate stubs when
>> !CONFIG_REGMAP, but this one is missing. Add it.
>
> Be careful on this one, you'll notice that the matching creation
> functions *aren't* stubbed since there is no way to reference them
> without an active dependency on regmap and indeed this use is a bit
> dodgy since the core ends up freeing something that a driver allocated
> which isn't ideal but probably is OK due to the general horrificness of
> the AC'97 device model integration.  We only stub functions that generic
> code might have a sensible reason to use in order to make it less faff
> to provide generic helpers for things.
>
> I'll tweak the commit message when applying.

Based on the other reply, you went with ifdefs in the audio code
instead, which is ok with me.


-Olof
