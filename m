Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3CTDSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3CTDSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:18:31 -0400
Message-ID: <1363749503.24132.482.camel@bling.home>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
From: Alex Williamson <alex.williamson@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Tue, 19 Mar 2013 21:18:23 -0600
In-Reply-To: <51492828.5070803@zytor.com>
References: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>
	 <51492379.3090302@zytor.com> <51492828.5070803@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 20:08 -0700, H. Peter Anvin wrote:
> On 03/19/2013 07:48 PM, H. Peter Anvin wrote:
> > On 03/19/2013 06:28 PM, Matthew Garrett wrote:
> >> Mm. The question is whether we can reliably determine the ranges a
> device should be able to access without having to trust userspace
> (and, ideally, without having to worry about whether iommu vendors
> have done their job). It's pretty important for PCI passthrough, so we
> do need to care. 
> > 
> > It is actually very simple: the device should be able to DMA into/out of:
> > 
> > 1. pinned pages
> > 2. owned by the process controlling the device
> > 
> > ... and nothing else.
> > 
> 
> The "pinning" process needs to involve a call to the kernel to process
> the page for DMA (pinning the page and opening it in the iommu) and
> return a transaction address, of course.
> 
> I think we have the interface for that in vfio, but I haven't followed
> that work.

Yes, vfio does this and is meant to provide a secure-boot-friendly PCI
passthrough interface.  Thanks,

Alex

