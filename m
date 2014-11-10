Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaKJMmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:42:13 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63746 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaKJMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:42:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,352,1413244800"; 
   d="scan'208";a="191161107"
Date: Mon, 10 Nov 2014 12:41:58 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <alpine.DEB.2.02.1411101200080.22875@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1411101240290.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com> <20141106103337.GA19702@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com> <20141107110524.GA21875@localhost>
 <alpine.DEB.2.02.1411071212250.22875@kaball.uk.xensource.com> <20141107160006.GE29148@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411071646170.22875@kaball.uk.xensource.com> <alpine.DEB.2.02.1411071732550.22875@kaball.uk.xensource.com>
 <20141107181430.GH29148@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411071834540.22875@kaball.uk.xensource.com> <20141110101645.GA21366@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411101200080.22875@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Stefano Stabellini wrote:
> > BTW, pfn_valid() is more expensive than simply comparing the mfn with
> > pfn for dom0. The calling code knows this already and it may be quicker
> > to simply pass a "bool foreign" argument.
> 
> Good point, I can compare mfn and pfn here.
> I cannot do the same in unmap_page and the various sync operations,
> because there is no pfn available, but maybe I could use
> set_page_private to set a flag. I'll think about it.

But of course there is no struct page either so I think pfn_valid will
have to stay in unmap and sync
