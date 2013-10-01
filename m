Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3JANkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:40:23 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63636 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3JANkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:40:21 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v6 10/19] xen: introduce xen_alloc/free_coherent_pages
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20130930153143.GQ3106@phenom.dumpdata.com>
Date: Tue, 1 Oct 2013 14:40:16 +0100
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DB675896-3FF2-409B-A2C6-24295C197A3F@arm.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com> <1380298207-29151-10-git-send-email-stefano.stabellini@eu.citrix.com> <20130930153143.GQ3106@phenom.dumpdata.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Sep 2013, at 16:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Fri, Sep 27, 2013 at 05:09:58PM +0100, Stefano Stabellini wrote:
>> xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
>> and devices. On native x86 and ARMv8 is sufficient to call
>> __get_free_pages in order to get a coherent buffer, while on ARM we need
>> to call the native dma_ops->alloc implementation.
>> 
>> When arm64 stops using the swiotlb by default and starts having multiple
>> dma_ops implementations, we'll use __get_dma_ops there too.
> 
> I presume this is a future TODO, not some further patch (in which
> case you should say in here the title of it). If it is a TODO could
> you stick that in the sentence here somewhere to make it crytal clear that
> it is not implemented.

Thanks for pointing this out.  The arm64 patch shouldn't be different
from arm here.  I thought a subsequent patch already added
__get_dma_ops() for arm64.

Catalin