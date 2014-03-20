Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbaCTMin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:38:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57801 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTMil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:38:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,694,1389744000"; 
   d="scan'208";a="111855224"
Date: Thu, 20 Mar 2014 12:38:39 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, Zoltan Kiss <zoltan.kiss@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Davies <Jonathan.Davies@citrix.com>
Subject: Re: [PATCH net-next v7 9/9] xen-netback: Aggregate TX unmap
 operations
Message-ID: <20140320123839.GK16807@zion.uk.xensource.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
 <1394142511-14827-10-git-send-email-zoltan.kiss@citrix.com>
 <532A0915.5090006@citrix.com>
 <20140320104855.GA16285@zion.uk.xensource.com>
 <9AAE0902D5BC7E449B7C8E4E778ABCD0292550@AMSPEX01CL01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9AAE0902D5BC7E449B7C8E4E778ABCD0292550@AMSPEX01CL01.citrite.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:14:51AM +0000, Paul Durrant wrote:
> > -----Original Message-----
> > From: Wei Liu [mailto:wei.liu2@citrix.com]
> > Sent: 20 March 2014 10:49
> > To: Zoltan Kiss
> > Cc: Ian Campbell; Wei Liu; xen-devel@lists.xenproject.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jonathan Davies;
> > Paul Durrant
> > Subject: Re: [PATCH net-next v7 9/9] xen-netback: Aggregate TX unmap
> > operations
> > 
> > On Wed, Mar 19, 2014 at 09:16:05PM +0000, Zoltan Kiss wrote:
> > > Hi,
> > >
> > > I'm thinking about revoking this patch: it's value is pretty small,
> > > but it causes performance regression on Win7 guests. And probably it
> > > is not the best solution for this problem. It might be the delay it
> > > takes the dealloc thread to be scheduled is enough.
> > > What do you think?
> > >
> > 
> > Can you elaborate? What makes Win7 so special? What's performance
> > impact to other guests?
> > 
> 
> It won't be Win7 specifically I expect. It will likely by any version
> of Windows, or any other OS that limits the TXs-in-flight so
> aggressively. Basically you need to TX-complete reasonably frequently
> otherwise your throughput drops off a lot. IIRC at Solarflare we found
> every ~500us to be just about frequent enough for hitting 10G.

Thanks for the explanation.

Reverting this change basically means when to flush TLB is at sole
discretion of Linux kernel scheduler. I don't oppose to that. But it
would be better to provide some numbers.

Wei.

> 
>   Paul
