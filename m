Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbbASLBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:01:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbbASLBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:01:18 -0500
Date: Mon, 19 Jan 2015 12:01:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "long.wanglong" <long.wanglong@huawei.com>
Cc: hannes@cmpxchg.org, shijie8@gmail.com, torvalds@linux-foundation.org,
        azurit@pobox.sk, hugh.dickins@tiscali.co.uk, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        peifeiyue@huawei.com
Subject: Re: does the semantics of MAP_LOCKED is equal to mlock() function?
Message-ID: <20150119110116.GB21052@dhcp22.suse.cz>
References: <54BCA187.6070601@huawei.com>
 <20150119094656.GA21052@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119094656.GA21052@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-01-15 10:46:56, Michal Hocko wrote:
[...]
> > testcase 2: mmap without MAP_LOCKED flag and the call mlock (memsize = 8192)
> > 
> > 185                 p = mmap(NULL, memsize, PROT_WRITE | PROT_READ,
> > 186                          MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
> > 187                 if (p == MAP_FAILED)
> > 188                         err(1, "mmap(lock) failed");
> > 189
> > 190                 if (mlock(p, memsize) == -1)
> > 191                         err(1, "mlock failed")
> > 
> > expect: invoke OOM killer.
> > result: invoke OOM killer.

Are you sure about this? memcg OOM killer shouldn't trigger even from
mlock path. It should just lead to ENOMEM. If you see the OOM killer
then it is probably coming from a page fault from a different source.
strace of your test would tell you more.
-- 
Michal Hocko
SUSE Labs
