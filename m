Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbbATM6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:58:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbATM6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:58:19 -0500
Date: Tue, 20 Jan 2015 13:58:17 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "long.wanglong" <long.wanglong@huawei.com>
Cc: hannes@cmpxchg.org, shijie8@gmail.com, torvalds@linux-foundation.org,
        azurit@pobox.sk, hugh.dickins@tiscali.co.uk, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        peifeiyue@huawei.com
Subject: Re: does the semantics of MAP_LOCKED is equal to mlock() function?
Message-ID: <20150120125817.GD25342@dhcp22.suse.cz>
References: <54BCA187.6070601@huawei.com>
 <20150119094656.GA21052@dhcp22.suse.cz>
 <20150119110116.GB21052@dhcp22.suse.cz>
 <54BDCA3C.4030804@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BDCA3C.4030804@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-01-15 11:23:40, long.wanglong wrote:
[...]
> hi, Michal Hocko
> 
> sorry for the wrong description in the email. i run the two testcase in kernel v3.10.63, not
> the latest kernel.
> 
> in kernel v3.18, the two testcases can not invoke OOM killer.
> 
> The problem comes from the LTP tests, because the v3.10.61 lts apply the following patch:
> 
> f8a5117916dd2871c056963bf5ee0d1101c10099 mm: memcg: handle non-error OOM situations more gracefully
> f79d6a468980516cbfb9e01313c846b82b9d2e7e mm: memcg: do not trap chargers with full callstack on OOM
> 7a147e0c45a8fa198ade4128bdcbf8592f48843e mm: memcg: rework and document OOM waiting and wakeup
> 11f34787b50ce71f66b85ad8790beaa5eee3f897 mm: memcg: enable memcg OOM killer only for user faults
> 
> as you said in: http://marc.info/?l=linux-api&m=142122902613316&w=2
> 
> "
> The primary issue is that mmap doesn't report a failure if MAP_LOCKED fails to populate the area. Is
> this the correct/expected behavior?
> "
> 
> There is another problem:
> 
> in kernel v3.10.63  testcase 1 can not invoke OOM, but testcase2 can invoke OOM.

Both mlock and mmap(MAP_LOCKED) are using the same way to fault pages
backing mmaped area so they both are supposed to fail in the same way.
Meaning OOM before the above rework and ENOMEM with the change.
Maybe both of them are using a different exit paths when something is
faulted in and OOM happens for one while not for the other. strace would
tell you that.
-- 
Michal Hocko
SUSE Labs
