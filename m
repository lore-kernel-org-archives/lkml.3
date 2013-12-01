Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3LARFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 12:05:05 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58717 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3LARFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 12:05:02 -0500
MIME-Version: 1.0
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
Date: Sun, 1 Dec 2013 10:05:00 -0700
Message-ID: <CAL-B5D3t=K-m5Y=Vvgv=SnrOLni8rAJC5eW8J1CEBsgafjTemA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] PCI: Double removing fix and allocate 64bit mmio pref
From: Myron Stowe <myron.stowe@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai:

Would you please consider *not* bundling unrelated, or at least
non-dependent, patches together in one series.  As a distrobution
subsystem maintainer, this type of bundling really complicates trying
to identify and isolate key material for bringing in.  It also makes
trying to identify the core content for key fixes, which can occur
many months or years later, significantly more difficult when they
were buried within a series with other unrelated content

Thanks,
 Myron.

On Sat, Nov 30, 2013 at 3:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> First 4 are for Gu Zheng <guz.fnst@cn.fujitsu.com> to help double pci
> device removing via sysfs.
> For patch 4, rafael like to have use lock instead of atomic.
>
> Patch 6 are for not enabling realloc auto when 64bit mmio is not there for
> root bus.
>
> Others are about mmio 64 allocation that could help Guo Chao <yan@linux.vnet.ibm.com> on powerpc mmio allocation.
> It will try to assign 64 bit resource above 4g at first.
>
> Patch 1-4 and Patch 5-12 could be appliey seperatedly.
>
> Could be found:
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-3.14
>
> And it is based on current pci/for-linus.
>
> -v2: update after patch that move device_del down to pci_destroy_dev.
>      add "Try best to allocate pref mmio 64bit above 4G"
>
> -v3: refresh and send out after pci_clip_resource() changes,
>      as Bjorn is not happy with attachments.
>
> Yinghai Lu (12):
>   PCI: Use device_release_driver in pci_stop_root_bus
>   PCI: Move back pci_proc_attach_devices calling
>   PCI: Move resources and bus_list releasing to pci_release_dev
>   PCI: Destroy pci dev only once
>   PCI: pcibus address to resource converting take bus instead of dev
>   PCI: Only enable realloc auto when root bus has 64bit mmio
>   PCI: Don't use 4G bus address directly in resource allocation
>   PCI: Try to allocate mem64 above 4G at first
>   PCI: Kill PCIBIOS_MAX_MEM_32
>   PCI: Try best to allocate pref mmio 64bit above 4g
>   PCI: Sort pci root bus resources list
>   intel-gtt: Read 64bit for gmar_bus_addr
>
>  arch/x86/include/asm/pci.h   |   1 -
>  drivers/char/agp/intel-gtt.c |  14 ++--
>  drivers/pci/bus.c            |  74 ++++++++++++++++---
>  drivers/pci/host-bridge.c    |  34 +++++----
>  drivers/pci/probe.c          |  23 +++++-
>  drivers/pci/remove.c         |  31 ++------
>  drivers/pci/setup-bus.c      | 165 ++++++++++++++++++++++++++++++-------------
>  drivers/pci/setup-res.c      |  14 +++-
>  include/linux/pci.h          |  10 +--
>  9 files changed, 257 insertions(+), 109 deletions(-)
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
