Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaKCIAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:00:30 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47335 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaKCIA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:00:28 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 3 Nov 2014 17:02:08 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        David Miller <davem@davemloft.net>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Message-ID: <20141103080208.GA7052@js1304-P5Q-DELUXE>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> Memory cgroups used to have 5 per-page pointers.  To allow users to
> disable that amount of overhead during runtime, those pointers were
> allocated in a separate array, with a translation layer between them
> and struct page.

Hello, Johannes.

I'd like to leave this translation layer.
Could you just disable that code with #ifdef until next user comes?

In our company, we uses PAGE_OWNER on mm tree which is the feature
saying who allocates the page. To use PAGE_OWNER needs modifying
struct page and then needs re-compile. This re-compile makes us difficult
to use this feature. So, we decide to implement run-time configurable
PAGE_OWNER through page_cgroup's translation layer code. Moreover, with
this infrastructure, I plan to implement some other debugging feature.

Because of my laziness, it didn't submitted to LKML. But, I will
submit it as soon as possible. If the code is removed, I would
copy-and-paste the code, but, it would cause lose of the history on
that code. So if possible, I'd like to leave that code now.

Thanks.
