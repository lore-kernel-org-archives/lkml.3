Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3KAOrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:47:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3KAOrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:47:32 -0400
Date: Fri, 1 Nov 2013 14:47:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 -tip] fix race between stop_two_cpus and stop_cpus
Message-ID: <20131101144728.GY2400@suse.de>
References: <20131031163144.0fd27457@annuminas.surriel.com>
 <20131101110825.GX2400@suse.de>
 <52739244.3060209@redhat.com>
 <20131101134424.GA32685@suse.de>
 <20131101142404.GG19466@laptop.lan>
 <5273BA58.6010404@redhat.com>
 <20131101104146.03d1e043@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131101104146.03d1e043@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 10:41:46AM -0400, Rik van Riel wrote:
> Subject: fix race between stop_two_cpus and stop_cpus
> 
> There is a race between stop_two_cpus, and the global stop_cpus.
> 
> It is possible for two CPUs to get their stopper functions queued
> "backwards" from one another, resulting in the stopper threads
> getting stuck, and the system hanging. This can happen because
> queuing up stoppers is not synchronized.
> 
> This patch adds synchronization between stop_cpus (a rare operation),
> and stop_two_cpus.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> v2: use lglock, as suggested by Peter & Mel, thanks to both of you
> for insisting on nicer code :)
> 

This is a tad more comprehensible :). Thanks!

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
