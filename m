Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3ARVzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:55:25 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45821 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3ARVzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:55:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 7/8] PCI/PCIe: add "pci=nopciehp" to disable PCIe native hotplug
Date: Fri, 18 Jan 2013 23:01:16 +0100
Message-ID: <1576807.oaVfmTuWNZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-8-git-send-email-jiang.liu@huawei.com> <CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 10:35:46 AM Bjorn Helgaas wrote:
> On Fri, Jan 18, 2013 at 9:07 AM, Jiang Liu <liuj97@gmail.com> wrote:
> > If user specifies "pci=nopciehp" on kernel boot command line, OSPM
> > won't claim PCIe native hotplug service from firmware and no PCIe
> > port devices will be created for PCIe native hotplug service.
> 
> Why do we need this option?
> 
> If I understand correctly, there are machines where it *looks* like we
> should use pciehp, but pciehp doesn't work because we don't get the
> interrupts we expect.  On those machines, we have to use acpiphp
> instead.  It seems like many Dell XPS laptops have this issue with
> ExpressCard slots, e.g.,
> https://bugzilla.kernel.org/show_bug.cgi?id=40802 .
> 
> If you want "pci=nopciehp" as a way for users to deal with this
> problem by forcing the use of acpiphp, I object.  Windows manages to
> make these slots work without having users do anything special, so we
> should be able to do it, too.

And one can use pcie_ports=compat to work around these problems anyway.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
