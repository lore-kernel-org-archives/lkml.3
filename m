Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaCFXMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:12:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaCFXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:12:09 -0500
Date: Thu, 6 Mar 2014 15:12:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@kernel.org, riel@redhat.com, mgorman@suse.de, jstancek@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [merged]
 mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch removed from -mm
 tree
Message-Id: <20140306151206.6228ae8933af538048aa056c@linux-foundation.org>
In-Reply-To: <20140306230404.GY6963@cmpxchg.org>
References: <5318dca5.AwhU/92X21JgbpdE%akpm@linux-foundation.org>
	<20140306214927.GB11171@cmpxchg.org>
	<20140306135635.6999d703429afb7fd3949304@linux-foundation.org>
	<20140306230404.GY6963@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 18:04:04 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > what bug does it fix and what are the user-visible effects??
> 
> Ok, maybe this is better?
> 
> ---
> 
> GFP_THISNODE is for callers that implement their own clever fallback
> to remote nodes.  It restricts the allocation to the specified node
> and does not invoke reclaim, assuming that the caller will take care
> of it when the fallback fails, e.g. through a subsequent allocation
> request without GFP_THISNODE set.
> 
> However, many current GFP_THISNODE users only want the node exclusive
> aspect of the flag, without actually implementing their own fallback
> or triggering reclaim if necessary.  This results in things like page
> migration failing prematurely even when there is easily reclaimable
> memory available, unless kswapd happens to be running already or a
> concurrent allocation attempt triggers the necessary reclaim.
> 
> Convert all callsites that don't implement their own fallback strategy
> to __GFP_THISNODE.  This restricts the allocation a single node too,
> but at the same time allows the allocator to enter the slowpath, wake
> kswapd, and invoke direct reclaim if necessary, to make the allocation
> happen when memory is full.

Looks good, thanks.  I'll send this Linuswards next week.
