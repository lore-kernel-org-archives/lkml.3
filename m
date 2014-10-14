Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaJNQWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:22:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45266 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549AbaJNQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:22:11 -0400
Date: Tue, 14 Oct 2014 12:21:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 6/7] xen/arm/arm64: introduce xen_arch_need_swiotlb
Message-ID: <20141014162137.GI30965@laptop.dumpdata.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
 <1412941908-5850-6-git-send-email-stefano.stabellini@eu.citrix.com>
 <20141014160352.GF30965@laptop.dumpdata.com>
 <543D4B5C.2040502@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543D4B5C.2040502@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 05:12:12PM +0100, David Vrabel wrote:
> On 14/10/14 17:03, Konrad Rzeszutek Wilk wrote:
> > On Fri, Oct 10, 2014 at 12:51:47PM +0100, Stefano Stabellini wrote:
> >> Introduce an arch specific function to find out whether a particular dma
> >> mapping operation needs to bounce on the swiotlb buffer.
> >>
> >> On ARM and ARM64, if the page involved is a foreign page and the device
> >> is not coherent, we need to bounce because at unmap time we cannot
> >> execute any required cache maintenance operations (we don't know how to
> >> find the pfn from the mfn).
> ...
> >> --- a/arch/x86/include/asm/xen/page.h
> >> +++ b/arch/x86/include/asm/xen/page.h
> >> @@ -236,4 +236,11 @@ void make_lowmem_page_readwrite(void *vaddr);
> >>  #define xen_remap(cookie, size) ioremap((cookie), (size));
> >>  #define xen_unmap(cookie) iounmap((cookie))
> >>  
> >> +static inline bool xen_arch_need_swiotlb(struct device *dev,
> >> +		                                 unsigned long pfn,
> >> +										 unsigned long mfn)
> >> +{
> >> +	return false;
> >> +}
> > 
> > Why not make this an macro?
> 
> Because macros are evil and inline functions are preferred.

<laughs>

Fair enough.
> 
> David
