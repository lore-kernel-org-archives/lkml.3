Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaICAU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 20:20:57 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47480 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaICAU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 20:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140903001009.GA25970@cmpxchg.org>
References: <54061505.8020500@sr71.net>
	<20140902221814.GA18069@cmpxchg.org>
	<5406466D.1020000@sr71.net>
	<20140903001009.GA25970@cmpxchg.org>
Date: Tue, 2 Sep 2014 17:20:55 -0700
X-Google-Sender-Auth: obvHnoT1tha5C2YVCpjaDJZ30uE
Message-ID: <CA+55aFw6ZkGNVX-CwyG0ybQAPjYAscdM59k_tOLtg4rr-fS-jg@mail.gmail.com>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 5:10 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> That looks like a partial profile, where did the page allocator, page
> zeroing etc. go?  Because the distribution among these listed symbols
> doesn't seem all that crazy:

Please argue this *after* the commit has been reverted. You guys can
try to make the memcontrol batching actually work and scale later.
It's not appropriate to argue against major regressions when reported
and bisected by users.

Showing the spinlock at the top of the profile is very much crazy
(apparently taking 68% of all cpu time), when it's all useless
make-believe work. I don't understand why you wouldn't call that
crazy.

              Linus
