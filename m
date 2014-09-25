Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaIYSjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:39:32 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61511 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaIYSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:39:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140925181024.GA9360@cloud>
References: <1411668214-19199-1-git-send-email-bobby.prani@gmail.com> <20140925181024.GA9360@cloud>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 25 Sep 2014 14:39:00 -0400
Message-ID: <CAJhHMCCjkTioUqh8fDTd2xgJ9q-Mb4bfu1ueu+uPjH2JU9bVyQ@mail.gmail.com>
Subject: Re: [RFC PATCH] rcu: Add sparse check for RCU_INIT_POINTER()
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 2:10 PM,  <josh@joshtriplett.org> wrote:
> On Thu, Sep 25, 2014 at 02:03:34PM -0400, Pranith Kumar wrote:
>> Add a sparse check when RCU_INIT_POINTER() is used to assign a non __rcu
>> annotated pointer.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>
> Have you checked if this introduces a significant number of new warnings
> in the kernel?
>
> If not:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>


I tested the above patch on a small test case where we are assigning
to a non __rcu annotated pointer and sparse does warn in that case.

I tried doing that and there were too many address space warnings
(maybe?) not related to __rcu annotation.

May be a diff of previous warnings and later warnings should show up
if any new warnings are being generated...

diff before.log after.log

> drivers/md/dm.c:2239:9: error: incompatible types in comparison expression (different address spaces)

Looking at this it shows that RCU_INIT_POINTER() is being used on a
non __rcu pointer. I will send in a patch fixing that.

Thanks!
-- 
Pranith
