Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3GYO0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab3GYO0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:26:05 -0400
Date: Thu, 25 Jul 2013 10:24:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, ishii.hironobu@jp.fujitsu.com,
        ddutile@redhat.com, bill.sumner@hp.com, alex.williamson@redhat.com,
        hbabu@us.ibm.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
Message-ID: <20130725142446.GK11993@redhat.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com>
 <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com>
 <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com>
 <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
 <51BA7BB6.1080104@jp.fujitsu.com>
 <51EF7466.20703@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF7466.20703@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 03:29:58PM +0900, Takao Indoh wrote:
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

I don't understand all the details but I agree that idea of trying to
reset IOMMU in crashed kernel might not fly.

> 
> Another discussion point is how to handle buggy devices. Resetting buggy
> devices makes system more unstable. One of ideas is using boot parameter
> so that user can choose to reset devices or not.

So who would decide which device is buggy and don't reset it. Give
some details here.

Can't we simply blacklist associated module, so that it never loads
and then it never tries to reset the devices?

Thanks
Vivek
