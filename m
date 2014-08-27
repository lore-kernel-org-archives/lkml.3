Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229AbaH0QDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934967AbaH0QDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:03:39 -0400
Date: Wed, 27 Aug 2014 17:03:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: H Peter Anvin <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <mgalbraith@suse.de>, Linux-X86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce length of the eagerfpu path during x86
 context switches
Message-ID: <20140827160335.GD12424@suse.de>
References: <1407329748-3928-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1407329748-3928-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:55:45PM +0100, Mel Gorman wrote:
> Eager FPU switching is used on CPUs that support xsave on the grounds
> that CPUs that support it can optimise the switch with xsaveopt and xrstor
> instead of serialising by updating cr0.TS which has serialising semantics.
> 
> The path for eagerfpu is fatter than it needs to be because it still
> maintains the fpu_counter for lazy FPU switches even though the information
> is never used. This patch splits the paths optimises the eagerfpu path a
> little. The benefit is marginal, it was just noticed when looking at why
> integer-only workloads were spending time saving/restoring FPU states.
> 

This was initially sent when it would collide with the merge window
which was stupid timing. Nothing has actually changed since but I wonder
if anyone had a chance to take a look at this patches?

Thanks

-- 
Mel Gorman
SUSE Labs
