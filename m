Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3AJXda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:33:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37224 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3AJXd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:33:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Myron Stowe <mstowe@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Myron Stowe <myron.stowe@redhat.com>, bhelgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 3/6] ACPI/pci_slot: update PCI slot information when PCI hotplug event happens
Date: Fri, 11 Jan 2013 00:39:12 +0100
Message-ID: <1410202.K95a8u1BYT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXmnmFgG5jLnGyeYX7NcedGa-ztGo_CGoNjV8fFbe_esA@mail.gmail.com>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <2704169.6ID6mDVPAt@vostro.rjw.lan> <CAE9FiQXmnmFgG5jLnGyeYX7NcedGa-ztGo_CGoNjV8fFbe_esA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 10, 2013 03:03:53 PM Yinghai Lu wrote:
> On Thu, Jan 10, 2013 at 1:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Well, I don't see what functional problems that can bring.
> >
> > In theory people may want to have them as modules to avoid loading them on
> > systems that don't use PCI hotplug, but honestly I think that the complexity
> > this causes us to deal with is not worth it.
> >
> > Moreover, removing the modularity may actually allow us to solve some ordering
> > issues once and for good.
> 
> No, the world is not really ideal yet.
> 
> looks like laptops have problem with pci express cards.
> 
> when pciehp is used, surprise insert/removal does not work because
> PresDect does not change properly, so no interrupt is generated.
> --- i suspects that is silicon problem.
> 
> but when acpiphp is used, that surprise  insert/removal is working.
> 
> some laptop like thinkpad, just don't give osc to kernel..
> [    0.505117]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.505413]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT),
> returned control mask: 0x0d
> [    0.505517] ACPI _OSC control for PCIe not granted, disabling ASPM
> 
> and other laptop give that to kernel, in recent kernel will not give
> acpiphp to have that slot, because it want to hold that for pciehp.
> poor user have to pass 'pci_aspm=off" to disable _OSC for all.
> --- please check the mail that i forward to you yesterday.

Yes, this is a bug, but I'm not sure how to fix it yet.

> Anyway, we do need to let the user to have choice to use acpiphp and pciehp.
> and it should be first come and first serve policy.

And that's why you think they should be modules?  I disagree if so.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
