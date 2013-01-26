Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3AZBYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:24:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754281Ab3AZBYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:24:05 -0500
Message-ID: <1359163444.2079.12.camel@joe-AO722>
Subject: Re: [PATCH]cputime: make bool type for steal ticks
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 17:24:04 -0800
In-Reply-To: <CAFTL4hzLu5RN-PSuP6NRwx2sMKXh5OZ7gNqLnUQQvKTK4n9i1Q@mail.gmail.com>
References: <1353057890-24234-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <CAFTL4hzLu5RN-PSuP6NRwx2sMKXh5OZ7gNqLnUQQvKTK4n9i1Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 01:45 +0100, Frederic Weisbecker wrote:
> > diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
[]
> > @@ -282,7 +282,7 @@ static __always_inline bool steal_account_process_tick(void)
[]
> > -               return st;
> > +               return !!st;
> 
> I would expect gcc to perform the semantic "!!" cast implicitly. I
> just did some basic tests locally and it does.
> I prefer to be paranoid and not do any assumption though, unless I'm
> told gcc always guarantees this correct implicit cast. I'm queuing
> this patch and will send it to Ingo.

It's unnecessary.

6.3.1.2p1:

"When any scalar value is converted to _Bool, the result is 0
if the value compares equal to 0; otherwise, the result is 1."


