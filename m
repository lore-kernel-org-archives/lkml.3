Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBRW1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:27:15 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64339 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaBRW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:27:13 -0500
Date: Tue, 18 Feb 2014 14:27:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
In-Reply-To: <20140218090658.GA28130@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1402181424490.20772@chino.kir.corp.google.com>
References: <20140218090658.GA28130@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Michal Hocko wrote:

> Hi,
> I have just noticed that ppc has RECLAIM_DISTANCE reduced to 10 set by
> 56608209d34b (powerpc/numa: Set a smaller value for RECLAIM_DISTANCE to
> enable zone reclaim). The commit message suggests that the zone reclaim
> is desirable for all NUMA configurations.
> 
> History has shown that the zone reclaim is more often harmful than
> helpful and leads to performance problems. The default RECLAIM_DISTANCE
> for generic case has been increased from 20 to 30 around 3.0
> (32e45ff43eaf mm: increase RECLAIM_DISTANCE to 30).
> 
> I strongly suspect that the patch is incorrect and it should be
> reverted. Before I will send a revert I would like to understand what
> led to the patch in the first place. I do not see why would PPC use only
> LOCAL_DISTANCE and REMOTE_DISTANCE distances and in fact machines I have
> seen use different values.
> 

I strongly suspect that the patch is correct since powerpc node distances 
are different than the architectures you're talking about and get doubled 
for every NUMA domain that the hardware supports.
