Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaATIKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:10:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:21700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaATIKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:10:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="467619291"
Date: Mon, 20 Jan 2014 10:10:07 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Message-ID: <20140120081007.GA19123@xps8300>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
 <1389941251-32692-5-git-send-email-wens@csie.org>
 <201401171747.46332.arnd@arndb.de>
 <CAGb2v67UKiyfJbKZ_Frk3OwZupMPoA2Ck3Hj2zsRFXBQPztavg@mail.gmail.com>
 <CACRpkdZOD4zeA8T5kbJ4c5NsnuzHCg1mw8rRMYNT9c4R-Qnc6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZOD4zeA8T5kbJ4c5NsnuzHCg1mw8rRMYNT9c4R-Qnc6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 18, 2014 at 12:11:56AM +0100, Linus Walleij wrote:
> On Fri, Jan 17, 2014 at 6:43 PM, Chen-Yu Tsai <wens@csie.org> wrote:
> > On Sat, Jan 18, 2014 at 12:47 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> >>> +- NAME_shutdown-gpios  : GPIO phandle to shutdown control
> >>> +                         (phandle must be the second)
> >>> +- NAME_reset-gpios     : GPIO phandle to reset control
> >>> +
> >>> +NAME must match the rfkill-name property. NAME_shutdown-gpios or
> >>> +NAME_reset-gpios, or both, must be defined.
> >>> +
> >>
> >> I don't understand this part. Why do you include the name in the
> >> gpios property, rather than just hardcoding the property strings
> >> to "shutdown-gpios" and "reset-gpios"?
> >
> > This quirk is a result of how gpiod_get_index implements device tree
> > lookup.
> 
> Why can't it just have a single property "gpios", where the first
> element is the reset GPIO and the second is the shutdown GPIO?
> 
> rfkill-gpio does this:
> 
> gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
> gpio = devm_gpiod_get_index(&pdev->dev, rfkill->shutdown_name, 1);
> 
> The passed con ID name parameter is only there for the device
> tree case it seems. (ACPI ignores it.) So what about you just
> don't pass it at all and patch it to do like this instead:
> 
> gpio = devm_gpiod_get_index(&pdev->dev, NULL, 0);
> gpio = devm_gpiod_get_index(&pdev->dev, NULL, 1);
> 
> Heikki, are you OK with this change?

Yes, definitely. That is much cleaner.

Thanks,

-- 
heikki
