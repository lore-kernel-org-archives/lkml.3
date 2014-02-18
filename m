Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaBRJHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:07:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbaBRJHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:07:01 -0500
Date: Tue, 18 Feb 2014 10:06:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: ppc: RECLAIM_DISTANCE 10?
Message-ID: <20140218090658.GA28130@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have just noticed that ppc has RECLAIM_DISTANCE reduced to 10 set by
56608209d34b (powerpc/numa: Set a smaller value for RECLAIM_DISTANCE to
enable zone reclaim). The commit message suggests that the zone reclaim
is desirable for all NUMA configurations.

History has shown that the zone reclaim is more often harmful than
helpful and leads to performance problems. The default RECLAIM_DISTANCE
for generic case has been increased from 20 to 30 around 3.0
(32e45ff43eaf mm: increase RECLAIM_DISTANCE to 30).

I strongly suspect that the patch is incorrect and it should be
reverted. Before I will send a revert I would like to understand what
led to the patch in the first place. I do not see why would PPC use only
LOCAL_DISTANCE and REMOTE_DISTANCE distances and in fact machines I have
seen use different values.

Anton, could you comment please?
-- 
Michal Hocko
SUSE Labs
