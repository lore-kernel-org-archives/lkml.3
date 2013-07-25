Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3GYRBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:01:10 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53405 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3GYRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <51EF7466.20703@jp.fujitsu.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com> <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
 <51BA7BB6.1080104@jp.fujitsu.com> <51EF7466.20703@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Jul 2013 11:00:46 -0600
Message-ID: <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>,
        "Sumner, William" <bill.sumner@hp.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:29 AM, Takao Indoh
<indou.takao@jp.fujitsu.com> wrote:
> Sorry for letting this discussion slide, I was busy on other works:-(
> Anyway, the summary of previous discussion is:
> - My patch adds new initcall(fs_initcall) to reset all PCIe endpoints on
>   boot. This expects PCI enumeration is done before IOMMU
>   initialization as follows.
>     (1) PCI enumeration
>     (2) fs_initcall ---> device reset
>     (3) IOMMU initialization
> - This works on x86, but does not work on other architecture because
>   IOMMU is initialized before PCI enumeration on some architectures. So,
>   device reset should be done where IOMMU is initialized instead of
>   initcall.
> - Or, as another idea, we can reset devices in first kernel(panic kernel)
>
> Resetting devices in panic kernel is against kdump policy and seems not to
> be good idea. So I think adding reset code into iommu initialization is
> better. I'll post patches for that.

Of course nobody *wants* to do anything in the panic kernel.  But
simply saying "it's against kdump policy and seems not to be a good
idea" is not a technical argument.  There are things that are
impractical to do in the kdump kernel, so they have to be done in the
panic kernel even though we know the kernel is unreliable and the
attempt may fail.

My point about IOMMU and PCI initialization order doesn't go away just
because it doesn't fit "kdump policy."  Having system initialization
occur in a logical order is far more important than making kdump work.

Bjorn
