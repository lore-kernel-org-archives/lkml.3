Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3FGRJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:09:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39436 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:09:23 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130607170706.GB3730@phenom.dumpdata.com>
Date: Fri, 7 Jun 2013 10:07:06 -0700 (PDT)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH v2, part3 07/11] PCI, xen-pcifront: use new PCI
 interfaces to simplify implementation
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
 <1368719459-24800-8-git-send-email-jiang.liu@huawei.com>
 <20130607145024.GA16631@phenom.dumpdata.com>
 <20130607153822.GA24882@phenom.dumpdata.com> <51B20F57.7050100@gmail.com>
In-Reply-To: <51B20F57.7050100@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 12:50:31AM +0800, Jiang Liu wrote:
> On 06/07/2013 11:38 PM, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jun 07, 2013 at 10:50:24AM -0400, Konrad Rzeszutek Wilk wrote:
> >> On Thu, May 16, 2013 at 11:50:55PM +0800, Jiang Liu wrote:
> >>> Use new PCI interfaces to simplify xen-pcifront implementation:
> >>> 1) Use pci_create_root_bus() instead of pci_scan_bus_parented()
> >>>    because pci_scan_bus_parented() is marked as __deprecated.This
> >>>    also gets rid of a duplicated call of pci_bus_start_devices().
> >>> 2) Use pci_stop_root_bus() and pci_remove_root_bus() instead of
> >>>    open-coded private implementation.
> >>> 3) Use pci_set_host_bridge_release() to release data structures
> >>>    associated with PCI root buses.
> >>> 4) Use pci_bus_get()/pci_bus_put() to manage PCI root bus reference
> >>>    count.
> >>>
> >>> This is also a preparation for coming PCI bus lock enhancement.
> > 
> > With this patch from :
> > 
> >  Merge branch 'pci_lock_v3' of https://github.com/jiangliu/linux into testing
> > 
> > 
> > it blows up when detaching the device.
> Hi Konrad,
>    Thanks for testing! According to the log messages, this issue should
> be related to pci bus reference counter management. Seems we have done
> an extra(unbalanced) release of pci bus device.
>    Will investigate it tomorrow!

That is quite commendable that you are willing to look over this on
the weekend but I am not going to be able to rerun this test until
some time in the week. You could enjoy the weekend and just look at
this during the week.
