Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbaCTRwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaCTRwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:52:07 -0400
Date: Thu, 20 Mar 2014 18:51:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 0/2] wait: introduce WQ_FLAG_EXCLUSIVE_HEAD
Message-ID: <20140320175111.GA7375@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <20140318154724.GA5669@redhat.com> <CA+a=Yy4WPO9FQwqzDygz6AadT6xbOMEa_puwosZ6WFN17uCncw@mail.gmail.com> <20140319164907.GA10113@redhat.com> <20140319165747.GC8557@laptop.programming.kicks-ass.net> <20140319171906.GA11377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319171906.GA11377@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Oleg Nesterov wrote:
>
> OK, I'll try to test/cleanup/resend tomorrow.

Cough. Still un-tested, sorry. I will test it somehow and report,
but I'd like to send this for review right now.

Because I simply can't decide what the new flag should actually
do, so please ack/nack the semantics/naming at least.

Changes:

	1. I decided it would be better to change __wait_event()
	   to accept wait.flags right now. This looks better in
	   any case to me, and otherwise we need to introduce the
	   __wait_exclusive_enum.

	   The change looks trivial (both actually), please tell
	   me if you think it doesn't deserve a separate patch.

	2. I won't insist, but WQ_FLAG_EXCLUSIVE_HEAD can be used
	   without WQ_FLAG_EXCLUSIVE.

	   Unlikely this can be useful, but it looks more natural
	   this way. Otherwise we need to add another check to
	   ensure that WQ_FLAG_EXCLUSIVE_HEAD can't come alone.

	   However, perhaps this means the new flag needs another
	   name. I agree in advance with any.

Oleg.

