Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaICDPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:15:09 -0400
Received: from www.sr71.net ([198.145.64.142]:55792 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbaICDPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:15:06 -0400
Message-ID: <540687B9.7070305@sr71.net>
Date: Tue, 02 Sep 2014 20:15:05 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
References: <54061505.8020500@sr71.net> <20140902221814.GA18069@cmpxchg.org> <5406466D.1020000@sr71.net> <20140903001009.GA25970@cmpxchg.org> <CA+55aFw6ZkGNVX-CwyG0ybQAPjYAscdM59k_tOLtg4rr-fS-jg@mail.gmail.com> <20140903013317.GA26086@cmpxchg.org>
In-Reply-To: <20140903013317.GA26086@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 06:33 PM, Johannes Weiner wrote:
> kfree isn't eating 56% of "all cpu time" here, and it wasn't clear to
> me whether Dave filtered symbols from only memcontrol.o, memory.o, and
> mmap.o in a similar way.  I'm not arguing against the regression, I'm
> just trying to make sense of the numbers from the *patched* kernel.

I guess I could have included it in the description, but that was a
pretty vanilla run:

	perf top --call-graph=fp --stdio > foo.txt

I didn't use any filtering.  I didn't even know I _could_ filter. :)

