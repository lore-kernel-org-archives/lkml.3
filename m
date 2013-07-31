Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab3GaVI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:08:29 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38801 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab3GaVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <51F85BCC.2070103@jp.fujitsu.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com> <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
 <51BA7BB6.1080104@jp.fujitsu.com> <51EF7466.20703@jp.fujitsu.com>
 <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
 <51F5B966.9080405@jp.fujitsu.com> <CAErSpo4JtG5qVJb-nCywe3vkft=-cDeRDKn_V92RCZ-sGXpwbg@mail.gmail.com>
 <51F758B6.9090204@jp.fujitsu.com> <CAErSpo7TNhQO0dx_xZvF=dU2fSWTFf8x=xUJcEsbadJkv8ktuQ@mail.gmail.com>
 <51F85BCC.2070103@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 31 Jul 2013 15:08:03 -0600
Message-ID: <CAErSpo4yJ2yqCWv7GT7jWSVd_8SktU=xJXT78m8Vxp_wLA4Fow@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>,
        "Sumner, William" <bill.sumner@hp.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, linux-acpi]

On Tue, Jul 30, 2013 at 6:35 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:

> On x86, currently IOMMU initialization run *after* PCI enumeration, but
> what you are talking about is that it should be changed so that x86
> IOMMU initialization is done *before* PCI enumeration like sparc, right?

Yes.  I don't know whether or when that initialization order will ever
be changed, but I do think we should avoid building more
infrastructure that depends on the current order.

Changing the order is a pretty big deal because it's a lot more than
just the IOMMU.  Basically I think we should be enumerating ACPI
devices, including the IOMMU, before PCI devices, but there's a lot of
legacy involved in that area.  Added Rafael in case he has any
thoughts.

> Hmm, ok, I think I need to post attached patch to iommu list and
> discuss it including current order of x86 IOMMU initialization.
