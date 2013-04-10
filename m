Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937065Ab3DJXqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:46:25 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:50916 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763208Ab3DJXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:46:24 -0400
Message-ID: <5165F9CE.5050600@gmail.com>
Date: Wed, 10 Apr 2013 19:46:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: dormando <dormando@rydia.net>
CC: Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 0/10] Reduce system disruption due to kswapd V2
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <0000013defd666bf-213d70fc-dfbd-4a50-82ed-e9f4f7391b55-000000@email.amazonses.com> <20130410141445.GD3710@suse.de> <alpine.DEB.2.02.1304101524120.7738@dtop>
In-Reply-To: <alpine.DEB.2.02.1304101524120.7738@dtop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I've never checked it but I would have expected kswapd to stay on the
>> same processor for significant periods of time. Have you experienced
>> problems where kswapd bounces around on CPUs within a node causing
>> workload disruption?
> 
> When kswapd shares the same CPU as our main process it causes a measurable
> drop in response time (graphs show tiny spikes at the same time memory is
> freed). Would be nice to be able to ensure it runs on a different core
> than our latency sensitive processes at least. We can pin processes to
> subsets of cores but I don't think there's a way to keep kswapd from
> waking up on any of them?

You are only talking about extream corner case and don't talk about the other hand.
When number-of-nodes > nubmer-of-cpus, we have no way to avoid cpu sharing. 

Moreover, this is not kswapd specific isssue, every kernel thread makes the same
latency ick. so, this issue should be solved more generic layer.
