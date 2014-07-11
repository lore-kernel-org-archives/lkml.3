Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaGKVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:09:42 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64208 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaGKVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:09:41 -0400
MIME-Version: 1.0
In-Reply-To: <1405111021.2796.23.camel@joe-AO725>
References: <1405110617-16498-1-git-send-email-bobby.prani@gmail.com> <1405111021.2796.23.camel@joe-AO725>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 11 Jul 2014 17:09:09 -0400
Message-ID: <CAJhHMCAS=_f9C=CpFhpbCt1Jg63hhecbZzSqJN-+VeH=ajfanw@mail.gmail.com>
Subject: Re: [PATCH 1/1] rcutorture: fixes for printing message buffer
To: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 4:37 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2014-07-11 at 16:30 -0400, Pranith Kumar wrote:
>> Use snprintf() instead of sprintf() for writing to the message buffer.
>> Also use vmalloc() for the allocation of the message buffer. Since pr_alert() is
>> limited to print LOG_LINE_MAX characters at a time, we print the buffer in a
>> loop one line at a time.
>>
>> I tested this using the parse-torture.sh script as follows:
>
> Did you see the patch I sent you?
> https://lkml.org/lkml/2014/6/20/604
>
> It doesn't need a vmalloc.
> What is wrong with that approach?
>
>

I was trying to stay as close to the original code as possible by
using a buffer instead of using pr_alert/pr_cont throughout the code.

I see nothing wrong with what you proposed, but I like having one
pr_alert instead of lots sprinkled. Also avoiding vmalloc/vfree using
your approach seems like a win.

I will let Paul decide.

-- 
Pranith
