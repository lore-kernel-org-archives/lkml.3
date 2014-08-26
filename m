Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaHZHqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:46:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58774 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933859AbaHZHqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:46:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Date: Tue, 26 Aug 2014 09:43:50 +0200
Message-ID: <3804028.YQzQ4uAVsf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140826065729.GC15573@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org> <53FB8820.4010202@wwwdotorg.org> <20140826065729.GC15573@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gRlHVcPYhPT42nBUPiyvzux3TX/XjO1XEwNXkmAfnAH
 glnEGf1GXhKoAbLT3tf3RiEi4NE5nF0m6x49dlh//+Kqvis7he
 yb+xad9U0UuCJ69wzUnSoldoEqgWkD9aLGqnkXuAlLCEGzUnof
 7dBkwGWQN9and1P9f69FsYgLvNfsEIhbKEVzvQwhLoV1lGZIAi
 hzifBzxUzhH1gQ6WfD8IpzO4rpoiL4i+GXjOZkgx9+r/NYHJrd
 x/gE9Ts7sMb8pt+kXkVI6j9B9DyqccVhzuf/Ga4f7Ot8VQ0Ho/
 8YG7pUkV4a38+403MfKSQZ16RrxOi23cz70G0HI2A57jV6WqtO
 xjphABNhYh0fwtoPO+NE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2014 08:57:31 Thierry Reding wrote:
> On Mon, Aug 25, 2014 at 01:01:52PM -0600, Stephen Warren wrote:
> > On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> [...]
> > >+static int tegra_xusb_mbox_probe(struct platform_device *pdev)
> > 
> > >+    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > >+    if (!res)
> > >+            return -ENODEV;
> > 
> > Should devm_request_mem_region() be called here to claim the region?
> > 
> > >+    mbox->regs = devm_ioremap_nocache(&pdev->dev, res->start,
> > >+                                      resource_size(res));
> > >+    if (!mbox->regs)
> > >+            return -ENOMEM;
> > 
> > Is _nocache required? I don't see other drivers using it. I assume there's
> > nothing special about the mbox registers.
> 
> Most drivers should be using devm_ioremap_resource() which will use the
> _nocache variant of devm_ioremap() when appropriate. Usually the region
> will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
> remapped uncached.
> 

Note that ioremap() and ioremap_nocache() are the same. We really shouldn't
ever call ioremap_nocache().

devm_ioremap_resource() and pci_iomap() checking for IORESOURCE_CACHEABLE is
rather silly, since it doesn't call ioremap_cache() in that case.

	Arnd
