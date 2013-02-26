Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab3BZAvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:51:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3BZAvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:51:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAErSpo6jY1bX9G59uz8Zt_pDJ4OoR=kJkGjNLYYRTrKVXM8+eg@mail.gmail.com>
References: <CAErSpo6jY1bX9G59uz8Zt_pDJ4OoR=kJkGjNLYYRTrKVXM8+eg@mail.gmail.com> <1360623637.2950.63.camel@lorien2>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: dhowells@redhat.com, shuah.khan@hp.com, Joerg Roedel <joro@8bytes.org>,
        paulmck@linux.vnet.ibm.com, linasvepstas@gmail.com, davej@redhat.com,
        tglx@linutronix.de, mtk.manpages@gmail.com,
        iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, shemminger@vyatta.com, jiang.liu@huawei.com,
        wangyijing@huawei.com, shuahkhan@gmail.com
Subject: Re: [PATCH 1/4] pci: Add PCI_BUS() and PCI_DEVID() interfaces to return bus number and device id
Date: Tue, 26 Feb 2013 00:45:40 +0000
Message-ID: <19586.1361839540@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> wrote:

> David, can you point me at a description of include/uapi ... what is
> there and why, and how we should decide what new things go in
> include/uapi/linux/pci.h as opposed to include/linux/pci.h?  Maybe
> there should be something in Documentation/?

Probably in CodingStyle, Submitting* or somewhere similar.

> I'm guessing it's something to do with being exported to userland, but
> I'm not sure the things in this patch (PCI_DEV_ID, PCI_BUS) are really
> exportable in the sense of being used for syscalls, etc.

As a rule, if it's in uapi/ then it's exported to userspace; if it's not, then
it isn't.  The old headers where disintegrated along the lines of __KERNEL__
delimited sections by my scripts.

David
