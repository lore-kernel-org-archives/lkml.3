Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3AZWCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 17:02:16 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:52288 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3AZWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 17:02:12 -0500
Message-ID: <51045261.5020709@free-electrons.com>
Date: Sat, 26 Jan 2013 23:02:09 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] gpio: pca953x: add support for pca9505
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com> <1358889025-8530-3-git-send-email-gregory.clement@free-electrons.com> <CACRpkda-N0GrKOeaz4Hji0ef9pSRNPCxW_jLGR28iX-sk0-=tg@mail.gmail.com> <51024422.2060503@free-electrons.com> <CACRpkdbe1fGVLNyJ+U+ozE32p+_fc-eQ4W1F8OeYC+fryu_dQQ@mail.gmail.com>
In-Reply-To: <CACRpkdbe1fGVLNyJ+U+ozE32p+_fc-eQ4W1F8OeYC+fryu_dQQ@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 09:51 AM, Linus Walleij wrote:
> On Fri, Jan 25, 2013 at 9:36 AM, Gregory CLEMENT
> <gregory.clement@free-electrons.com> wrote:
> 
>> Well, at the beginning I thought adding support for pca9505 was just a matter
>> of a couple of lines to add. Then I realized that I need to handle the 40 bits
>> case, and I ended up refactoring all access to the registers. So now I am on it,
>> it seems I am volunteer to continue to improve this driver.
> 
> I like the sound of this ;-)

I was about to fix the issues you have pointed but I didn't find anything like

#ifdef CONFIG_ARCH_PXA
        if (cpu_is_pxa25x()) {
#ifdef CONFIG_CPU_PXA26x
                count = 89;
                gpio_type = PXA26X_GPIO;
#elif defined(CONFIG_PXA25x)


in the pca953x driver! I think you messed up with another patch set!

I saw that Haojian Zhuang have sent a patch set for gpio-pxa and
among this set the patch "[PATCH 06/10] gpio: pxa: define nr gpios
in platform data" seemed to exactly what you've expected.

> 
> To get you started I just sent out two other patches you can consider
> as RFC, they're regrettably not even compile-tested. I mainly wanted
> to indicate what needs to be done so we can throw them away, just
> wanted to give a hint.
> 
>> However I won't be able to test it, the only PXA based platform I have is a
>> Zaurus SL-C3100 which embeds a PXA270 if I remember well, but I doubt it come
>> with gpio expander on i2c.
> 
> Well I guess if there is nobody testing it, then nobody cares.
> The world must be full of people with PXA platforms doing nothing
> but regression testing...
> 
> Actually just days ago I asked Haoijan to help me testing a set of
> patches for the PXA SPI controller, and he kindly helped out, so there
> are some people booting these platforms, sometimes :-)
> 
> Yours,
> Linus Walleij
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
