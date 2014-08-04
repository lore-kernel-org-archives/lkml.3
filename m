Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaHDPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:16:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22867 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaHDPQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:16:27 -0400
Date: Mon, 4 Aug 2014 11:15:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] xen PVonHVM: use E820_Reserved area for
 shared_info
Message-ID: <20140804151535.GG19853@laptop.dumpdata.com>
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
 <1405431640-649-2-git-send-email-vkuznets@redhat.com>
 <53D65112.7080801@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D65112.7080801@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 02:33:06PM +0100, David Vrabel wrote:
> On 15/07/14 14:40, Vitaly Kuznetsov wrote:
> > From: Olaf Hering <olaf@aepfle.de>
> > 
> > This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
> > ("xen PVonHVM: move shared_info to MMIO before kexec").
> > 
> > Currently kexec in a PVonHVM guest fails with a triple fault because the
> > new kernel overwrites the shared info page. The exact failure depends on
> > the size of the kernel image. This patch moves the pfn from RAM into an
> > E820 reserved memory area.
> > 
> > The pfn containing the shared_info is located somewhere in RAM. This will
> > cause trouble if the current kernel is doing a kexec boot into a new
> > kernel. The new kernel (and its startup code) can not know where the pfn
> > is, so it can not reserve the page. The hypervisor will continue to update
> > the pfn, and as a result memory corruption occours in the new kernel.
> > 
> > The toolstack marks the memory area FC000000-FFFFFFFF as reserved in the
> > E820 map. Within that range newer toolstacks (4.3+) will keep 1MB
> > starting from FE700000 as reserved for guest use. Older Xen4 toolstacks
> > will usually not allocate areas up to FE700000, so FE700000 is expected
> > to work also with older toolstacks.
> > 
> > In Xen3 there is no reserved area at a fixed location. If the guest is
> > started on such old hosts the shared_info page will be placed in RAM. As
> > a result kexec can not be used.
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > (cherry picked from commit 9d02b43dee0d7fb18dfb13a00915550b1a3daa9f)
> 
> Is this a useful commit to give?  Isn't it one of Konrad's random trees?

Actually it is from upstream. That patch was reverted at certain point.

Perhaps just mention that it was added in, then reverted, and now after
a year or so, added back in with the fix.
