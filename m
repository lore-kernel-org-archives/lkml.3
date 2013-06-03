Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3FCQv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:51:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25440 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579Ab3FCQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:51:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,794,1363132800"; 
   d="scan'208";a="28919950"
Date: Mon, 3 Jun 2013 17:51:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
In-Reply-To: <20130603162517.GC32295@arm.com>
Message-ID: <alpine.DEB.2.02.1306031745460.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com> <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com> <20130603162517.GC32295@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Catalin Marinas wrote:
> On Mon, Jun 03, 2013 at 04:33:44PM +0100, Stefano Stabellini wrote:
> > --- /dev/null
> > +++ b/arch/arm64/xen/hypercall.S
> ...
> > +/*
> > + * The Xen hypercall calling convention is very similar to the ARM AEBI
> > + * procedure calling convention: the first paramter is passed in x0, the
> > + * second in x1, the third in x2 and the fourth in x3. Considering that
> > + * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
> > + * in rx, differently from the procedure calling convention of using the
> > + * stack for that case.
> 
> You may want to use the AArch64 ABI here where parameters are passed in
> x0-x7, return in x0.

We already do this, we just need to update the comment.


> BTW, I think it's missing a MAINTAINERS file update.

Yep, I'll make those changes.


> Otherwise, the series looks good. How do you plan to upstream this?

Good question.
Traditionally Xen stuff goes to Linus directly via one of the Xen trees
(Konrad's or mine), but since this is the very first Xen patch series
for arm64 if you prefer I can submit a pull request to you instead.
Just let me know, I am happy either way.

In any case, are you OK with sending it upstream during the next merge
window?
