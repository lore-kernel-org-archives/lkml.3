Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaJ0PZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:25:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9927 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaJ0PZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:25:02 -0400
X-IronPort-AV: E=Sophos;i="5.04,796,1406592000"; 
   d="scan'208";a="186513198"
Date: Mon, 27 Oct 2014 15:22:02 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v4 3/7] [RFC] arm/arm64: introduce
 is_dma_coherent
In-Reply-To: <544E2637.8000902@citrix.com>
Message-ID: <alpine.DEB.2.02.1410271423550.22875@kaball.uk.xensource.com>
References: <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com> <20141010120702.GI7755@arm.com> <alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com> <alpine.DEB.2.02.1410131215400.17038@kaball.uk.xensource.com> <20141013125725.GA19156@arm.com>
 <alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com> <alpine.DEB.2.02.1410221703560.876@kaball.uk.xensource.com> <alpine.DEB.2.02.1410231516450.876@kaball.uk.xensource.com> <20141024104746.GC1955@localhost> <alpine.DEB.2.02.1410241233080.22875@kaball.uk.xensource.com>
 <20141024154353.GE20534@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1410241751160.22875@kaball.uk.xensource.com> <alpine.DEB.2.02.1410241828110.22875@kaball.uk.xensource.com> <alpine.DEB.2.02.1410251424350.22875@kaball.uk.xensource.com>
 <1414251629.3584.20.camel@citrix.com> <alpine.DEB.2.02.1410251714450.22875@kaball.uk.xensource.com> <544E2637.8000902@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, David Vrabel wrote:
> On 25/10/14 17:15, Stefano Stabellini wrote:
> > On Sat, 25 Oct 2014, Ian Campbell wrote:
> >> On Sat, 2014-10-25 at 14:29 +0100, Stefano Stabellini wrote:
> >>>  
> >>> Your suggestions and looking more at the code gave me another idea, that
> >>> I think is clean and at the same time suitable for 3.18.
> >>> What do you think of the following? It is simple, self-contained and
> >>> doesn't need a new flag in struct device.
> >>
> >> of_dma_is_coherent looks to be quite expensive though (walks up the
> >> Device Tree doing strcmps on each property of each node until it finds
> >> the one it is looking for.
> > 
> > It takes spin_locks too!
> > Too bad, I think I'll have to ditch it. In that case I'l try the new
> > flag in struct device approach.
> 
> If you're having to make changes to struct device, this is looking like
> a series for 3.19 (not 3.18).

After looking more into it, I went for adding the flag to dev_archdata
under arm and arm64. Let's see what the maintainers say.
