Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3I3Q0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:26:23 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:61911 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3I3Q0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130930085243.GA25685@redhat.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<20130928192123.GA8228@gmail.com>
	<20130928193739.GA8642@gmail.com>
	<20130930085243.GA25685@redhat.com>
Date: Mon, 30 Sep 2013 09:26:21 -0700
X-Google-Sender-Auth: C1a0hMA2LXsB0wVwKsgFy7jXYJ0
Message-ID: <CA+55aFxG3hK0CiZJh1XORv+tiNWXVxh8rzr37Vmu=ASWj1s4PQ@mail.gmail.com>
Subject: Re: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 1:52 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> Sorry having to break the party but the sleepable locks for anon_vma
> and i_mmap_mutex are now requirement for the "pageable RDMA" effort
> recently achieved upstream by mellanox with the MMU notifier.

I'll happily break that.

No way will some random crazy RDMA be a reason why we'd drop this kind
of improvement on actual loads that matter way more.

                 Linus
