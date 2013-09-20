Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3ITUv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:51:58 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47890 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3ITUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZqm=3oed979Jyg7n+8KwW_-2AGv3OzJBTPN20ZH=Vc3Q@mail.gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1379526839-14798-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdZqm=3oed979Jyg7n+8KwW_-2AGv3OzJBTPN20ZH=Vc3Q@mail.gmail.com>
Date: Fri, 20 Sep 2013 22:51:56 +0200
Message-ID: <CACRpkdauZCi+BDGa9gAZq0eG1jzHBuym5RzzwfxxcCMCAFJZEg@mail.gmail.com>
Subject: Re: [PATCH 01/26] ARM: nomadik: move mtu setup to clocksource init
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:49 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Sep 18, 2013 at 7:53 PM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>
>> MTU timer initialization is stuffed into .init_time callback, while
>> cpu8815_timer_init_of again maps addresses from the same device node.
>> Therefore, this patch moves mtu setup from to clocksource init.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Another happy Nomadik user? Or are you just compile testing
> this?
>
> Actually, this is superceded and collides with this pending fix:
> http://marc.info/?l=linux-arm-kernel&m=137910161418706&w=2
>
> We should wait for that to hit mainline and then see what we want
> to do with this.

By the way - this can *definately* not be moved into the MTU
driver as it is pertaining to clocks, not the timer using it.

As nmdk_timer_init() can also be called from the ux500 which
does not want to do this, things get broken for ux500.

Yours,
Linus Walleij
