Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbbAIVqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:46:53 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43682 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbbAIVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:46:52 -0500
Date: Fri, 9 Jan 2015 16:46:49 -0500
From: Tejun Heo <tj@kernel.org>
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
Message-ID: <20150109214649.GF2785@htj.dyndns.org>
References: <54B01335.4060901@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B01335.4060901@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:43:17PM +0000, Suzuki K. Poulose wrote:
> We have hit a hang on ARM64 defconfig, while running LTP tests on 3.19-rc3.
> We are
> in the process of a git bisect and will update the results as and
> when we find the commit.
> 
> During the ksm ltp run, the test hangs trying to mount memcg with the
> following strace
> output:
> 
> mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ? ERESTARTNOINTR (To
> be restarted)
> mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ? ERESTARTNOINTR (To
> be restarted)
> [ ... repeated forever ... ]
> 
> At this point, one can try mounting the memcg to verify the problem.
> # mount -t cgroup -o memory memcg memcg_dir
> --hangs--
> 
> Strangely, if we run the mount command from a cold boot (i.e. without
> running LTP first),
> then it succeeds.

I don't know what LTP is doing and this could actually be hitting on
an actual bug but if it's trying to move memcg back from unified
hierarchy to an old one, that might hang - it should prolly made to
just fail at that point.  Anyways, any chance you can find out what
happened, in terms of cgroup mounting, to memcg upto that point?

Thanks.

-- 
tejun
