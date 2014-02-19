Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBSJUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:20:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaBSJUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:20:01 -0500
Date: Wed, 19 Feb 2014 10:19:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
Message-ID: <20140219091959.GD14783@dhcp22.suse.cz>
References: <20140218090658.GA28130@dhcp22.suse.cz>
 <alpine.DEB.2.02.1402181424490.20772@chino.kir.corp.google.com>
 <20140219081644.GA14783@dhcp22.suse.cz>
 <alpine.DEB.2.02.1402190017480.7280@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402190017480.7280@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-02-14 00:20:21, David Rientjes wrote:
> On Wed, 19 Feb 2014, Michal Hocko wrote:
> 
> > > I strongly suspect that the patch is correct since powerpc node distances 
> > > are different than the architectures you're talking about and get doubled 
> > > for every NUMA domain that the hardware supports.
> > 
> > Even if the units of the distance is different on PPC should every NUMA
> > machine have zone_reclaim enabled? That doesn't right to me.
> > 
> 
> In my experience on powerpc it's very correct, there's typically a 
> significant latency in remote access and we don't have the benefit of a 
> SLIT that actually defines the locality between proximity domains like we 
> do on other architectures. 

Interesting. So is the PPC NUMA basically about local vs. very distant?
Should REMOTE_DISTANCE reflect that as well? Or can we have 
distance < REMOTE_DISTANCE and it would still make sense to have
zone_reclaim enabled?

[...]

Thanks!
-- 
Michal Hocko
SUSE Labs
