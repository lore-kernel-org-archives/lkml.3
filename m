Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957Ab3ECK3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:29:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53532 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3ECK3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:29:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,602,1363132800"; 
   d="scan'208";a="23128149"
Date: Fri, 3 May 2013 11:29:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Christopher Covington <cov@codeaurora.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 2/3] xen: move do_stolen_accounting to
 drivers/xen/time.c
In-Reply-To: <1367569605.28742.28.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305031118080.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>  <1367436460-10183-2-git-send-email-stefano.stabellini@eu.citrix.com>  <5182B532.10607@codeaurora.org> <1367569605.28742.28.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Ian Campbell wrote:
> On Thu, 2013-05-02 at 19:49 +0100, Christopher Covington wrote:
> > Hi Stefano,
> > 
> > On 05/01/2013 03:27 PM, Stefano Stabellini wrote:
> > > Move do_stolen_accounting, xen_vcpu_stolen and related functions and
> > > static variables to common code (drivers/xen/time.c).
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  arch/x86/xen/time.c   |  127 +-------------------------------------------
> > 
> > In going through some of the code, it looked like there might be a few little
> > bits that you might be interested in pulling out of arch/ia64/xen/time.c as well.
> 
> ia64 in the hypervisor was deprecated and with the 4.3 release has been
> removed.
> 
> AFAIK ia64/Xen support has been broken in the mainline kernel for year.

Yes, that's why it didn't occur to me to do anything about it.

Also, the ia64 code differs from the x86 code, I can't just replace it
with the newly introduced common code unfortunately.
