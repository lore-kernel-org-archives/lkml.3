Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab3FDGer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:34:47 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38711 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3FDGep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <201306030056.03522.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de>
	<201306030056.03522.heiko@sntech.de>
Date: Tue, 4 Jun 2013 08:34:44 +0200
Message-ID: <CACRpkdYAvUQ+aymJm1Fw1bE1aGdO7RUqLR9byvoT7ECTk4tkpw@mail.gmail.com>
Subject: Re: [PATCH 01/10] clocksource: dw_apb_timer_of: use the clocksource
 as sched clock if necessary
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 12:56 AM, Heiko Stübner <heiko@sntech.de> wrote:

> Currently the dw_apb_timer always expects a separate special timer to be
> availbable for the sched_clock. Some devices using dw_apb_timers do not
> have the sptimer but can use the clocksource as sched_clock.
> Therefore this patch adds using the clocksource timer as
> a fallback if no usable sched timer is found.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Is this really what the patch does? I mean "ass the clocksourse as
fallback", it seems more like that is controlled from the device tree,
this looks more like some more careful handling of the device tree
input making the sched_timer optional, it doesn't really "add"
anything, does it?

Yours,
Linus Walleij
