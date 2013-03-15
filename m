Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3COSJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:09:43 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46928 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3COSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:09:41 -0400
MIME-Version: 1.0
In-Reply-To: <201303151128.48432.arnd@arndb.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <20130314140631.GM1906@pengutronix.de> <CAHkwnC9nGsdgOTQZ6VpeDyPWXw7tpP+2oHvnLv6LEr1cNdnrsg@mail.gmail.com>
 <201303151128.48432.arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Fri, 15 Mar 2013 19:09:18 +0100
Message-ID: <CAHkwnC_4kVGcs03_6RVNrye21aUHsCWf9rQe=2JP_Nkjk8Yczw@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>,
        linux-input <linux-input@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 15 March 2013, Fabio Porcedda wrote:
>> >> * Regarding the use of module_platform_driver_probe, I'm a little worried about
>> >>   the interactions with deferred probing. I don't think there are any regressions,
>> >>   but we should probably make people aware that one cannot return -EPROBE_DEFER
>> >>   from a platform_driver_probe function.
>>
>> The use of module_platform_driver_probe() doesn't change anything about that,
>> it's exactly the same thing as using "return platform_driver_probe()".
>> I'm right or I'm missing something? Maybe are you just speaking about
>> the misuse of "platform_driver_probe"?
>
> Yes, that was what I meant. The point is that if we need to review or remove
> all uses of platform_driver_probe, it would be better not to introduce a
> module_platform_driver_probe() interface to make it easier to use.

Just to let you know, the module_platform_driver_probe() macro is
already in v3.9-rc1 and is already used by some drivers.
In linux-next there are already many patches that use that macro.

Best regards
--
Fabio Porcedda
