Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3LLNuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:50:02 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46819 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LLNt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:49:59 -0500
Date: Thu, 12 Dec 2013 13:49:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Potentially unbounded allocations in seq_read?
Message-ID: <20131212134956.GC10323@ZenIV.linux.org.uk>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
 <20131211174909.GW10323@ZenIV.linux.org.uk>
 <1386784797.6066.63.camel@tursulin-linux.isw.intel.com>
 <20131211180703.GY10323@ZenIV.linux.org.uk>
 <1386855640.6066.73.camel@tursulin-linux.isw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386855640.6066.73.camel@tursulin-linux.isw.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 01:40:40PM +0000, Tvrtko Ursulin wrote:

> So this is the story... task_mmu.c:show_map_vma() calls seq_path. There
> we have a d_path call which returns -ENAMETOOLONG and keeps doing so
> even though the buffer grows to huge proportions. It is something on
> tmpfs, don't know what.
> 
> But in the meantime, shouldn't seq_path be a bit more considerate on
> this particular error and not mark the state as "could not fit" forever?
> Perhaps it would make sense to limit it a bit?
> 
> Or even more so, on errors _other_ than -ENAMETOOLONG it will at the
> moment mark the result as "need more space". That also sounds broken to
> me.

a) *what* errors other than -ENAMETOOLONG?
b) d_path() not fitting into 2Mb is definitely a bug.  If you really have
managed to get a dentry tree 1 million levels deep, you have much worse
problems.
c) which kernel version it is?
