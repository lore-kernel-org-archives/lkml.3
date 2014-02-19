Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaBSVpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:45:18 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51245 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaBSVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:45:16 -0500
Date: Wed, 19 Feb 2014 13:45:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
In-Reply-To: <20140219091959.GD14783@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1402191339000.31921@chino.kir.corp.google.com>
References: <20140218090658.GA28130@dhcp22.suse.cz> <alpine.DEB.2.02.1402181424490.20772@chino.kir.corp.google.com> <20140219081644.GA14783@dhcp22.suse.cz> <alpine.DEB.2.02.1402190017480.7280@chino.kir.corp.google.com>
 <20140219091959.GD14783@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Michal Hocko wrote:

> Interesting. So is the PPC NUMA basically about local vs. very distant?

The point is that it's impossible to tell how distant they are from one 
NUMA domain to the next NUMA domain.

> Should REMOTE_DISTANCE reflect that as well? Or can we have 
> distance < REMOTE_DISTANCE and it would still make sense to have
> zone_reclaim enabled?
> 

Ppc doesn't want to allocate in a different NUMA domain unless required, 
the latency of a remote access is too high.  Everything that isn't in the 
same domain has a distance >10 and is setup as 2^(domain hops) * 10.  We 
don't have the ability like with a SLIT to define remote nodes to have 
local latency vs remote or costly latency so the safe setting is a 
RECLAIM_DISTANCE of 10.
