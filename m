Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499Ab3FTNUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:20:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39486 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3FTNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:20:06 -0400
Date: Thu, 20 Jun 2013 22:20:03 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: Alexander Frolkin <avf@eldamar.org.uk>, lvs-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: SH fallback and L4 hashing
Message-ID: <20130620132003.GD24993@verge.net.au>
References: <20130619095425.GA20145@eldamar.org.uk>
 <alpine.LFD.2.00.1306192239510.1823@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306192239510.1823@ja.ssi.bg>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:45:43PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 19 Jun 2013, Alexander Frolkin wrote:
> 
> > By default the SH scheduler rejects connections that are hashed onto a
> > realserver of weight 0.  This patch adds a flag to make SH choose a
> > different realserver in this case, instead of rejecting the connection.
> > 
> > The patch also adds a flag to make SH include the source port (TCP, UDP,
> > SCTP) in the hash as well as the source address.  This basically allows
> > for deterministic round-robin load balancing (i.e., where any director
> > in a cluster of directors with identical config will send the same
> > packet the same way).
> > 
> > The flags are service flags (IP_VS_SVC_F_SCHED*) so that these options
> > can be set per service.  They are set using a new option to ipvsadm.
> > 
> > Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>
> 
> 	Thanks! Looks good to me.
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> > ---
> > The patch is against the ipvs-next tree.
> 
> 	Still, I see one warning:
> 
> patching file include/uapi/linux/ip_vs.h
> patching file net/netfilter/ipvs/ip_vs_sh.c
> Hunk #2 succeeded at 75 with fuzz 1.
> 
> 	May be because you are missing the
> "ipvs: ip_vs_sh: fix build" change, not sure where is
> the fault, may be the change is not in ipvs-next,
> Simon can tell how to proceed with applying this patch.

Thanks, applied and pushed to ipvs-next.

I also noticed some fuzz.
Alexander, could you double-check ipvs-next to make sure
that I applied the patch correctly?
