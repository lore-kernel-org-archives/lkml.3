Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3KRX6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:58:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51522 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751378Ab3KRX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:58:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PULL REQUEST] i2c for 3.13
Date: Tue, 19 Nov 2013 01:11:25 +0100
Message-ID: <3690707.5664qBQcL8@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFxZaC=beR+dN36Sv==6fjY7SdOdwXaSHU+wnk+-oDJp4g@mail.gmail.com>
References: <20131118193802.GA14925@katana> <CA+55aFxZaC=beR+dN36Sv==6fjY7SdOdwXaSHU+wnk+-oDJp4g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 18, 2013 03:46:34 PM Linus Torvalds wrote:
> On Mon, Nov 18, 2013 at 11:38 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> >
> > here is the pull request from the i2c subsystem for 3.13:
> 
> So while resolving some fairly trivial conflicts here, I noticed that
> commit a76e9bd89ae7 ("i2c: attach/detach I2C client device to the ACPI
> power domain") that I got earlier through the ACPI/PM tree calls
> acpi_dev_pm_detach() even when the device "->remove()" function fails.
> But it only sets clientdata to NULL if it succeeds.
> 
> That looks a bit odd.
> 
> I didn't try to fix it, though. I just thought I'd point out the oddity.

Well, given that the driver core doesn't even check the return value of
dev->bus->remove(dev), I think doing the unconditional acpi_dev_pm_detach()
is actually correct and clientdata should be cleared unconditionally too.

Rafael

