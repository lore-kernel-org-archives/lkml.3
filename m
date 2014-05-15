Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaEONbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:31:07 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54455 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaEONbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:31:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 06/10] usb: xhci: Add Tegra XHCI host-controller driver
Date: Thu, 15 May 2014 15:30:06 +0200
Message-ID: <11038777.juA2AddEko@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140515091938.GD6434@ulmo>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org> <15599140.PsD4j7x3tZ@wuerfel> <20140515091938.GD6434@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:V8t+5+KSni28MpFkx6/dpDkxg67e8mqa0/BelvYCY78
 hOYgbWk2JeDfIjT4Ql/PxmLIYFE1Y0FJQ+7zBPK2LJfVM+F5XJ
 wkVjQ6k7AseFrBZY4iHSCjUJePvvDlZ31Vst9bmk6c31JFvsZ1
 vqzXV0/+GfCo2i3PZLqfbpH+Nm1giaS9Lw/jBIpicOjHGmwEZU
 NJowCvYhH339msHWafry7fSdkqEgR+6Vk56aIoyfSJKW5LDKmh
 g8YXZXsbX4odsT7/qWzQssvKZt5YiZE8YhyBnZvtwsaMBK7/XV
 aJ4Gp3Kz+N20mdxfyMtJaTpZAxE0vAWvsr9hc/laYU9fuj43T9
 3Xqrw1/Bx2u6VN4kHclA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 11:19:40 Thierry Reding wrote:
> > > +
> > > +   xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
> > > +   if (!xhci) {
> > > +           dev_err(dev, "Failed to allocate XHCI host\n");
> > > +           ret = -ENOMEM;
> > > +           goto out;
> > > +   }
> > 
> > This does not feel appropriate at all: Rather than creating a child device,
> > you should have a specific driver that hooks into functions exported
> > by the xhci core. See Documentation/driver-model/design-patterns.txt
> 
> I don't think Documentation/driver-model/design-patterns.txt documents
> this. Perhaps this is what you had in mind?
> 
>         http://lwn.net/Articles/336262/

No, I did mean Documentation/driver-model/design-patterns.txt.

The pattern used in the proposed driver is to create the generic platform_device
as the child of the more specific platform_device.

The normal pattern is to have only one device and embed the generic structure
inside of the more specific structure and use container_of to cast between
the two as needed.

	Arnd
