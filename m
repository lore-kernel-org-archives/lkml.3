Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3ASOuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 09:50:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:39558 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3ASOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 09:50:35 -0500
Date: Sat, 19 Jan 2013 06:51:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing0307@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 7/8] PCI/PCIe: add "pci=nopciehp" to disable PCIe
 native hotplug
Message-ID: <20130119145147.GB2491@kroah.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
 <1358525267-14268-8-git-send-email-jiang.liu@huawei.com>
 <CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com>
 <50F9FD48.20509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F9FD48.20509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 09:56:24AM +0800, Yijing Wang wrote:
> 于 2013-01-19 1:35, Bjorn Helgaas 写道:
> > On Fri, Jan 18, 2013 at 9:07 AM, Jiang Liu <liuj97@gmail.com> wrote:
> >> If user specifies "pci=nopciehp" on kernel boot command line, OSPM
> >> won't claim PCIe native hotplug service from firmware and no PCIe
> >> port devices will be created for PCIe native hotplug service.
> > 
> > Why do we need this option?
> > 
> > If I understand correctly, there are machines where it *looks* like we
> > should use pciehp, but pciehp doesn't work because we don't get the
> > interrupts we expect.  On those machines, we have to use acpiphp
> > instead.  It seems like many Dell XPS laptops have this issue with
> > ExpressCard slots, e.g.,
> > https://bugzilla.kernel.org/show_bug.cgi?id=40802 .
> 
> What about use modprobe pciehp pciehp_poll_mode=1?
> If just cannot receive the interrupt, maybe this module parameter will fix it.

You can't add a new option that you now force hardware that was working
with a different module to now define and use.  It needs to be
"automatic".

> > If you want "pci=nopciehp" as a way for users to deal with this
> > problem by forcing the use of acpiphp, I object.  Windows manages to
> > make these slots work without having users do anything special, so we
> > should be able to do it, too.
> 
> In fact, pcie native hotplug may not be implemented perfectly,

Oh, we know that is true, it's the problem here.  Fixing BIOSes would be
nice, but we can't do that :(

greg k-h
