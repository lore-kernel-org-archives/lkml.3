Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaEFHXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:23:12 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:65006 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934148AbaEFHXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:23:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
Date: Tue, 06 May 2014 09:22:32 +0200
Message-ID: <10277248.fmjBNTktBZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqJXE4uXKA6XU1=3zFjdcEXHyUat2dL6wDKiZBx8S-p+Xg@mail.gmail.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com> <13946837.RfnRDPQdge@wuerfel> <CAL_JsqJXE4uXKA6XU1=3zFjdcEXHyUat2dL6wDKiZBx8S-p+Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3BGjlqYM15GrjAgBIbte8u7Qwl9Jzwdhu5XMhlN8SNx
 /AchyaM8D8+Lwj4GPqzrDaMITgL5jlshQZyp7C8vp9JCt+K9TV
 8k0SEKs1aToqUQCV8Z+/IGQhprgMHWUYs8XcNrgZRX8Aqdsvna
 7BUt+1PLn0ezR8/k57FxJ6Cu/ozw7FWfQZvxbjz6XEEwP22sQG
 bAVWlXI5fsmQZHa+TjXRqNRenlOXwOI5aH0G9KxaRpKLkyGHwU
 +UtI0k7tl6tz+p52LVdvEndoInrMWC5lheN1tV0bN4ooLyeF1V
 zs6Ot/mSGcO+xroZNicfe0ScWQmU+7yRz7XGrQ4KgKzL78cdXl
 KmJec9vZU9bcEXvud3aA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2014 10:34:02 Rob Herring wrote:
> 
> > Ideally this should be done by slightly restructuring the DT
> > source to make all on-chip devices appear below the soc node.
> > We'd have to think a bit about how to best do this while
> > preserving compatibility with existing dts files.
> 
> I don't agree. How is a block with chip ID info the parent of all the
> other devices?
> 
> In doing some work to move default of_platform_populate out of
> platforms, I noticed that most platforms using the soc device are
> making it the parent of platform devices. I think this is either wrong
> or all platforms should have a default soc device. It makes little
> sense for some platforms to have a devices under a soc sysfs directory
> while others do not. Or the location changes when a platform latter
> adds the soc device.

We had a long discussion about this when we introduced the drivers/soc
framework. The intention is that the /sys/devices/soc* node is meant to
describe the SoC in its entirety, the same way you have a pci0000:00 node
as the root of all PCI devices of the first pci host bridge on a PC
system. This also reflects the reality of a SoC, which normally has one
bus that the CPU is connected to and that has all the other devices as
children.

Having the chipid registers as part of the top-level bus should not
be interpreted as having the other devices as children of the chipid
device, but rather the chipid registers as a property of the soc itself
as opposed to a random device that happens to be part of the soc.

	Arnd
