Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3FCQoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:44:21 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53812 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752119Ab3FCQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:44:19 -0400
Date: Mon, 3 Jun 2013 17:43:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and
 hypercall.S on ARM64
Message-ID: <20130603164329.GD32295@arm.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
 <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130603162517.GC32295@arm.com>
 <1370277455.24512.46.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370277455.24512.46.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 05:37:35PM +0100, Ian Campbell wrote:
> On Mon, 2013-06-03 at 17:25 +0100, Catalin Marinas wrote:
> > On Mon, Jun 03, 2013 at 04:33:44PM +0100, Stefano Stabellini wrote:
> > > --- /dev/null
> > > +++ b/arch/arm64/xen/hypercall.S
> > ...
> > > +/*
> > > + * The Xen hypercall calling convention is very similar to the ARM AEBI
> > > + * procedure calling convention: the first paramter is passed in x0, the
> > > + * second in x1, the third in x2 and the fourth in x3. Considering that
> > > + * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
> 
>                                                           parameter
> 
> > > + * in rx, differently from the procedure calling convention of using the
> 
>           ^x4 not rx
> 
> > > + * stack for that case.
> > 
> > You may want to use the AArch64 ABI here where parameters are passed in
> > x0-x7, return in x0.
> 
> I think that is actually what we are doing (up to 5 arguments), the
> "Considering that ..." bit at the end is a left over of the 32 bit
> version I think.

Yes, only the comment needs updating.

-- 
Catalin
