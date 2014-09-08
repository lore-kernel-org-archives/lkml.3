Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIHSEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:04:11 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52418 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaIHSEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:04:09 -0400
Date: Mon, 8 Sep 2014 12:03:57 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND] ARM: PCI: Use PCI_CLASS_* defines for PCI class
Message-ID: <20140908180357.GA6159@obsidianresearch.com>
References: <1410163532-31057-1-git-send-email-lisovy@gmail.com>
 <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7sOc72V3g5tOov8Yj4nKiuJupaUTKEEecHMcqEUrzh_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:36:36AM -0600, Bjorn Helgaas wrote:

> Presumably these devices have PCI BARs (since that's how dev->resource
> got filled in), and we want to somehow ignore them, not assign
> resources to them, and not allow drivers to use whatever is mapped by
> the BARs.  But clearing out the struct resources isn't really safe by
> itself.  The hardware BAR still contains some value, and may still be
> enabled, which means that it may conflict with other devices.

I've seen this pattern before in the old mvebu stuff.

Essentially for that case the mvebu HW is a repurposed end port core,
so when working as a root port it presents an end port config space
(not a root port bridge config space). The BAR in that config space is
not relevant, so the old mvebu used code like this to hide it from the
PCI core. Otherwise the core will try to program it from the aperture,
and the default BAR size is really big, so it runs out of space.

Not sure if this is the same for this driver, but it looks very
similar..

Jason
