Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3FDI3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:29:53 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56805 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab3FDI3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:29:50 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 01/10] clocksource: dw_apb_timer_of: use the clocksource as sched clock if necessary
Date: Tue, 4 Jun 2013 10:29:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
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
References: <201306030055.15413.heiko@sntech.de> <201306030056.03522.heiko@sntech.de> <CACRpkdYAvUQ+aymJm1Fw1bE1aGdO7RUqLR9byvoT7ECTk4tkpw@mail.gmail.com>
In-Reply-To: <CACRpkdYAvUQ+aymJm1Fw1bE1aGdO7RUqLR9byvoT7ECTk4tkpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306041029.39053.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Juni 2013, 08:34:44 schrieb Linus Walleij:
> On Mon, Jun 3, 2013 at 12:56 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > Currently the dw_apb_timer always expects a separate special timer to be
> > availbable for the sched_clock. Some devices using dw_apb_timers do not
> > have the sptimer but can use the clocksource as sched_clock.
> > Therefore this patch adds using the clocksource timer as
> > a fallback if no usable sched timer is found.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Is this really what the patch does? I mean "ass the clocksourse as
> fallback", it seems more like that is controlled from the device tree,
> this looks more like some more careful handling of the device tree
> input making the sched_timer optional, it doesn't really "add"
> anything, does it?

Right, the commit message is probably based a bit to much on the before-state 
of the driver, always expecting the "sptimer" and panicing if not found.

How about:

Currently the dw_apb_timer always expects a separate special timer to be
availbable for the sched_clock. Some devices using dw_apb_timers do not
have this sptimer but can use the clocksource as sched_clock instead.

Therefore enable the driver to distiguish between devices with and without
sptimer based on the devicetree data and select the correct timer as
sched_clock.
