Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab3FCQhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:37:39 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:64578 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3FCQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:37:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,794,1363132800"; 
   d="scan'208";a="5269240"
Message-ID: <1370277455.24512.46.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and
 hypercall.S on ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 3 Jun 2013 17:37:35 +0100
In-Reply-To: <20130603162517.GC32295@arm.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
	 <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20130603162517.GC32295@arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 17:25 +0100, Catalin Marinas wrote:
> On Mon, Jun 03, 2013 at 04:33:44PM +0100, Stefano Stabellini wrote:
> > --- /dev/null
> > +++ b/arch/arm64/xen/hypercall.S
> ...
> > +/*
> > + * The Xen hypercall calling convention is very similar to the ARM AEBI
> > + * procedure calling convention: the first paramter is passed in x0, the
> > + * second in x1, the third in x2 and the fourth in x3. Considering that
> > + * Xen hypercalls have 5 arguments at most, the fifth paramter is passed

                                                          parameter

> > + * in rx, differently from the procedure calling convention of using the

          ^x4 not rx

> > + * stack for that case.
> 
> You may want to use the AArch64 ABI here where parameters are passed in
> x0-x7, return in x0.

I think that is actually what we are doing (up to 5 arguments), the
"Considering that ..." bit at the end is a left over of the 32 bit
version I think.

> 
> BTW, I think it's missing a MAINTAINERS file update.
> 
> Otherwise, the series looks good. How do you plan to upstream this?
> 


