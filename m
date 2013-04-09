Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab3DIR1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:27:21 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:34252 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab3DIR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:27:20 -0400
Date: Tue, 9 Apr 2013 17:27:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Reduce system disruption due to kswapd V2
In-Reply-To: <1365505625-9460-1-git-send-email-mgorman@suse.de>
Message-ID: <0000013defd666bf-213d70fc-dfbd-4a50-82ed-e9f4f7391b55-000000@email.amazonses.com>
References: <1365505625-9460-1-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One additional measure that may be useful is to make kswapd prefer one
specific processor on a socket. Two benefits arise from that:

1. Better use of cpu caches and therefore higher speed, less
serialization.

2. Reduction of the disturbances to one processor.


