Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaLDOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:44:34 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:64087 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaLDOoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:44:32 -0500
MIME-Version: 1.0
In-Reply-To: <54806F2A.7070107@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
	<1408495538-27480-9-git-send-email-linux@roeck-us.net>
	<CAMuHMdVqCa+m1oMkuRHcTZKw2CWNHJVotWBwfTnfBNT11UPEjw@mail.gmail.com>
	<54806F2A.7070107@roeck-us.net>
Date: Thu, 4 Dec 2014 15:44:29 +0100
X-Google-Sender-Auth: 7_a4RfohyMvsM9_T0LgI_mkGVUg
Message-ID: <CAMuHMdX-WsVErpiZ_EbFSGxeJEfpu3cRaZzitupiSAA2hXEJ8g@mail.gmail.com>
Subject: Re: [PATCH v7 08/11] arm/arm64: Unexport restart handlers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Günther,

On Thu, Dec 4, 2014 at 3:26 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 12/04/2014 05:36 AM, Geert Uytterhoeven wrote:
>> On Wed, Aug 20, 2014 at 2:45 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> Implementing a restart handler in a module don't make sense
>>> as there would be no guarantee that the module is loaded when
>>> a restart is needed. Unexport arm_pm_restart to ensure that
>>> no one gets the idea to do it anyway.
>>
>> Why not? I was just going to do that, but I got greeted by:
>
> Because you should register a restart handler instead, like the other
> drivers in the same directory now do.

That's a different thing. "there would be no guarantee that the module is
loaded when a restart is needed" is also valid for restart handlers...

>> ERROR: "arm_pm_restart" [drivers/power/reset/rmobile-reset.ko] undefined!
>>
>> So now we have to make sure all reset drivers for a zillion different
>> hardware devices are builtin, and can't be modular?
>>
> No. All those drivers need to do is to register a restart handler using
> the API provided in the patch series.
>
> Ultimately all restart handlers should do that and arm_pm_restart should
> go away entirely. That was the point of the patch series.

Good. That's what I'm doing right know ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
