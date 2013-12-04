Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3LDQHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:07:37 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:45408 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab3LDQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:07:36 -0500
Date: Wed, 4 Dec 2013 11:07:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation apis
Message-ID: <20131204160730.GQ3158@htj.dyndns.org>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
 <1386037658-3161-9-git-send-email-santosh.shilimkar@ti.com>
 <20131203232445.GX8277@htj.dyndns.org>
 <529F5047.50309@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F5047.50309@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 04, 2013 at 10:54:47AM -0500, Santosh Shilimkar wrote:
> Well as you know there are architectures still using bootmem even after
> this series. Changing MAX_NUMNODES to NUMA_NO_NODE is too invasive and
> actually should be done in a separate series. As commented, the best
> time to do that would be when all remaining architectures moves to
> memblock.
> 
> Just to give you perspective, look at the patch end of the email which
> Grygorrii cooked up. It doesn't cover all the users of MAX_NUMNODES
> and we are bot even sure whether the change is correct and its
> impact on the code which we can't even tests. I would really want to
> avoid touching all the architectures and keep the scope of the series
> to core code as we aligned initially.
> 
> May be you have better idea to handle this change so do
> let us know how to proceed with it. With such a invasive change the
> $subject series can easily get into circles again :-(

But we don't have to use MAX_NUMNODES for the new interface, no?  Or
do you think that it'd be more confusing because it ends up mixing the
two?  It kinda really bothers me this patchset is expanding the usage
of the wrong constant with only very far-out plan to fix that.  All
archs converting to nobootmem will take a *long* time, that is, if
that happens at all.  I don't really care about the order of things
happening but "this is gonna be fixed when everyone moves off
MAX_NUMNODES" really isn't good enough.

Thanks.

-- 
tejun
