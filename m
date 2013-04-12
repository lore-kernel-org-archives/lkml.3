Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3DLS3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:29:48 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:33757 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3DLS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:29:47 -0400
Date: Fri, 12 Apr 2013 11:29:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130412182941.GF11956@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 02:01:08PM -0400, Mikulas Patocka wrote:
> So if you think that reference counts should be incremented by every clone 
> of the original bio, what kind of bug should it protect against? If we 
> don't increment reference counts for pages, why should we do it for cgroup 
> pointers?

These things are called trade-offs.  You look at the overhead of the
things and how complex / fragile things get when certain shortcuts are
taken and how well contained and easy to verify / debug when things go
wrong and then make your choice.

Do the two really look the same to you?  The page refs are much more
expensive, mostly contained in and the main focus of dm.  ioc/css refs
aren't that expensive to begin with, css refcnting is widely scattered
across the kernel, the association interface is likely to be used by
any entity issuing IOs asynchronously soonish, and there is much saner
way to improve it - which would be beneficial not only to block / dm
but everyone else using it.

Something being done in one place doesn't automatically make it okay
everywhere else.  We can and do use hackery but *with* discretion.

If you still can't understand, I'm not sure what more I can tell you.

-- 
tejun
