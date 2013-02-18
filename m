Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3BRNKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:10:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39395 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab3BRNK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:10:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>,
        wency@cn.fujitsu.com
Subject: Re: [PATCH] ACPI / scan: Make it clear that acpi_bus_trim() cannot fail
Date: Mon, 18 Feb 2013 14:17:02 +0100
Message-ID: <15493777.FVIQvWOuf9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130218122549.GA4448@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1511096.zmfmBrfdmu@vostro.rjw.lan> <20130218122549.GA4448@dhcp-192-168-178-175.profitbricks.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 18, 2013 01:25:49 PM Vasilis Liaskovitis wrote:
> Hi,
> 
> On Thu, Jan 24, 2013 at 11:56:50PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Since acpi_bus_trim() cannot fail, change its definition to a void
> > function, so that its callers don't check the return value in vain
> > and update the callers.
> 
> I have missed a few patchsets/discussions in the last month and wanted to
> ask a question related to this: Does the new always-succeed 2-pass
> trim_device design guarantee safe memory hot-remove operations?

I doesn't by itself.  Nor it really can, because the .remove() callbacks of
device drivers are not allowed to fail.

> Afaict if memory offline fails now, the device is ejected (_EJ0) anyways
> causing a panic. Tested in a VM with linux-next-20130207 and
> linux-next-20130218 by doing an SCI-eject request on a hot-plugged dimm.
> 
> Are there more patches in development for safe memory hot-remove?

Yes, there are.  I sent a patch series yesterday introducing some safety
measures (you can disable memory hotplug from user space or disable
automatic ejection).  There's more to come still.

The plan is to introduce offline/online operations for memory modules (in
analogy with CPU core online/offline) that can be started by user space and
memory eject will only be possible after offline (i.e. when the memory module
is known to be not in use).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
