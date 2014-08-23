Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaHWRLC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:11:02 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:63701 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaHWRLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:11:00 -0400
Date: Sat, 23 Aug 2014 13:10:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/15] percpu: perform tlb flush after pcpu_map_pages()
 failure
Message-ID: <20140823171056.GE13540@mtj.dyndns.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
 <1408726399-4436-3-git-send-email-tj@kernel.org>
 <alpine.DEB.2.11.1408231039220.29970@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408231039220.29970@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 10:40:29AM -0500, Christoph Lameter wrote:
> On Fri, 22 Aug 2014, Tejun Heo wrote:
> 
> > If pcpu_map_pages() fails midway, it unmaps the already mapped pages.
> > Currently, it doesn't flush tlb after the partial unmapping.  This may
> > be okay in most cases as the established mapping hasn't been used at
> > that point but it can go wrong and when it goes wrong it'd be
> > extremely difficult to track down.
> 
> So why is this separate? You added the unmapping in the last patch without
> the flushing and this is a fixup for the patch before?

This was originally separated out so that flushes can be done once per
chunk as some of the flushes involve sending IPIs to all CPUs.  After
this patchset, more of alloc/free logic is implemented in the percpu
core so it probably would be better to expose the flush interface too
so that all can be driven from the core.

Thanks.

-- 
tejun
