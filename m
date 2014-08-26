Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbaHZI4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:56:37 -0400
Received: from mx0.aculab.com ([213.249.233.131]:58694 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934013AbaHZI4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:56:34 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Thierry Reding'" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: Andrew Bresticker <abrestic@chromium.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        "Kishon Vijay Abraham I" <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Thread-Topic: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Thread-Index: AQHPwJbPv3kpDpBx0k+sSL4vTz8WEJviZBGAgAAvxnA=
Date: Tue, 26 Aug 2014 08:54:53 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17481234@AcuExch.aculab.com>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <1408381705-3623-3-git-send-email-abrestic@chromium.org>
 <53FB8820.4010202@wwwdotorg.org> <20140826065729.GC15573@ulmo>
In-Reply-To: <20140826065729.GC15573@ulmo>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding
...
> > Is _nocache required? I don't see other drivers using it. I assume there's
> > nothing special about the mbox registers.
> 
> Most drivers should be using devm_ioremap_resource() which will use the
> _nocache variant of devm_ioremap() when appropriate. Usually the region
> will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
> remapped uncached.

A related question:
Is there any way for a driver to force that part of a PCIe BAR be mapped
through the data cache even when the BAR isn't actually marked cacheable?

Some hardware has address regions (which might not be an entire BAR)
that are actually memory and mapping through the data cache will
generate longer PCIe transfers [1].
Clearly the driver will have to be very careful about cache flushes
and invalidates to make this work.

[1] PCIe is high throughput and high latency, single word reads can
be much slower that PCI, much nearer x86 ISA bus speeds.

	David



