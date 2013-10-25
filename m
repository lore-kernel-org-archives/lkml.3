Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3JYTiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 15:38:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23197 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3JYTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 15:38:22 -0400
Date: Fri, 25 Oct 2013 15:38:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Julien Grall <julien.grall@linaro.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc-console: Make it work with HVM
 guests.
Message-ID: <20131025193812.GA6256@phenom.dumpdata.com>
References: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com>
 <5245FD71.3080408@linaro.org>
 <20130930144513.GM3106@phenom.dumpdata.com>
 <5251CD98.70807@linaro.org>
 <20131023161518.GA28413@phenom.dumpdata.com>
 <526848C1.5030705@linaro.org>
 <20131024144921.GB29944@phenom.dumpdata.com>
 <52694B3F.5090008@linaro.org>
 <1382633034.22417.121.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382633034.22417.121.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 05:43:54PM +0100, Ian Campbell wrote:
> On Thu, 2013-10-24 at 17:30 +0100, Julien Grall wrote:
> 
> > I'm sure the solution "move xen call earlier" will come up in few mails, 
> > so there was a discussion for swiotlb few weeks ago 
> > (https://lkml.org/lkml/2013/8/29/609). And the final decision was to 
> > avoid specific Xen call in arch_setup.
> 
> It wasn't so much a hard reject as a preference based on the need
> presented at the time.
> 
> Perhaps a generic DT driven mechanism to detect hypervisors, called
> early, would be more acceptable?
> 
> > Stefano, Ian, any opinion?
> 
> The ifdef approach is a bit ugly, but if the other option doesn't work
> out I suppose we can live with it.
> 
> But stepping back how/why is this function called on x86 when not
> running under Xen? Wouldn't the use have to be using console=hvc or
> earlyprintk=xen or something -- which strikes me as user error... IOW
> can we not just nuke the check

It shouldn't - ever. On x86 it is called from the early PV bootup code.

I occasionaly use it when developing/debugging and as such want it working
in HVM even during early bootup.

> 
> Ian.
> 
