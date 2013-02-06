Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3BFArQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:47:16 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56623 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3BFArL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:47:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7-dULYwWQ=f5CBCxOULKJE9=n6Ha4jkVKd8enspuYjTA@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
	<1359314629-18651-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
	<CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
	<CAE9FiQX2DbTO0qCzGO4iMTkU_mPM2oZL+R5UoZ5dj=as6MUAsw@mail.gmail.com>
	<CAErSpo7-dULYwWQ=f5CBCxOULKJE9=n6Ha4jkVKd8enspuYjTA@mail.gmail.com>
Date: Tue, 5 Feb 2013 16:47:10 -0800
X-Google-Sender-Auth: THxPTaHOd_dLiaKcZZZ2bOgWxfg
Message-ID: <CAE9FiQWvmK7N2z19B9ZiMyc_T6cJdpWoWr3mExpuwUA4ogBc3w@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 4:19 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Maybe.  I'd rather not introduce for_each_pci_host_bridge() at all, if
> we can avoid it.  Every place it's used is a place we have to audit to
> make sure it's safe.  I think your audit above is correct and
> complete, but it relies on way too much architecture knowledge.  It's
> better if we can deduce correctness without knowing which arches
> support hotplug and which CPUs support EDAC.
>
> As soon as for_each_pci_host_bridge() is in the tree, those uses can
> be copied to even more places.  It's a macro, so it's usable by any
> module, even out-of-tree ones that we'll never see and can't fix.  So
> we won't really have a good way to deprecate and remove it.

Now we only have two references in modules.

drivers/edac/i7core_edac.c:     for_each_pci_host_bridge(host_bridge) {
drivers/pci/hotplug/sgi_hotplug.c:      for_each_pci_host_bridge(host_bridge) {

for the sgi_hotplug.c, it should be same problem that have for acpiphp
and pciehp.
need to make it support pci host bridge hotplug anyway.

for edac, we need to check Mauro about their plan.

After those two are addressed, we can drop that EXPORT_SYMBOL_GPL for
pci_get_next_host_bridge.

We do have pci_get_domain_bus_and_slot() as export symbol.
So we export pci_get_next_host_bridge should be ok now.
and it would be better than export root buses list.

Thanks

Yinghai
