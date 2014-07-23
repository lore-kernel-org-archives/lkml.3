Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaGWPpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:45:20 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57724 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaGWPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140723153018.GY11241@linux.vnet.ibm.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-10-git-send-email-bobby.prani@gmail.com>
 <20140723122112.GJ11241@linux.vnet.ibm.com> <CAJhHMCAoLQPnJYCeqftXwZb6D4ECuJb4g04b4OO5BLf6iC1ENw@mail.gmail.com>
 <20140723135024.GR11241@linux.vnet.ibm.com> <CAJhHMCAZ__1xkEou44iux=Z6v6NAKPrTvWob6tqorm23nNygOA@mail.gmail.com>
 <20140723142314.GV11241@linux.vnet.ibm.com> <CAJhHMCA4Fdd4JbtKdNGABFYRBCqaLukLbydLAFA-3RiZXaTngA@mail.gmail.com>
 <20140723153018.GY11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 11:44:43 -0400
Message-ID: <CAJhHMCBDZyHYCo01T421f+No0ZBWfjsUXijg+MT1A2U621izpA@mail.gmail.com>
Subject: Re: [PATCH 09/16] rcu: Remove redundant check for online cpu
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:30 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Jul 23, 2014 at 11:11:45AM -0400, Pranith Kumar wrote:
>> On Wed, Jul 23, 2014 at 10:23 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Wed, Jul 23, 2014 at 10:12:54AM -0400, Pranith Kumar wrote:
>> >> On Wed, Jul 23, 2014 at 9:50 AM, Paul E. McKenney
>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >> > On Wed, Jul 23, 2014 at 08:59:06AM -0400, Pranith Kumar wrote:
>> >> >> On Wed, Jul 23, 2014 at 8:21 AM, Paul E. McKenney
>> >> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >> >> > On Wed, Jul 23, 2014 at 01:09:46AM -0400, Pranith Kumar wrote:
>> >> >> >> There are two checks for an online CPU if two if() conditions. This commit
>> >> >> >> simplies this by replacing it with only one check for the online CPU.
>> >> >> >>
>> >> >> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> >> >> >
>> >> >> > I admit that it is very early in the morning my time, but I don't see
>> >> >> > this change as preserving the semantics in all cases.  Please recheck
>> >> >> > your changes to the second check.
>> >> >> >
>> >> >> >                                                         Thanx, Paul
>> >> >>
>> >> >> I guess you must be thrown off by the complementary checks, the first
>> >> >> check is for cpu_online() and second is for cpu_is_offline(). :)
>> >> >>
>> >> >> Previously, if a cpu is offline, the first condition is false and the
>> >> >> second condition is true, so we return from the second if() condition.
>> >> >> The same semantics are being preserved.
>> >> >
>> >> > Fair enough!
>> >> >
>> >> > Nevertheless, I am not seeing this as a simplification.
>> >>
>> >> I am not sure what you mean here, do you mean that both the checks are
>> >> actually required?
>> >
>> > I mean that the current compound tests each mean something.  Pulling out
>> > the offline test adds lines of code and obscures that meaning.   This means
>> > that it is easier (for me, anyway) to see why the current code is correct
>> > than it is to see why your suggested change is correct.
>> >
>>
>> That is a valid point. I did not mean to reduce readability of the
>> code. Just trying to avoid the overhead of smp_processor_id().
>>
>> Not sure if you would prefer this, but how about the following?
>
> If you change the "awake" to something like "am_online", I could get
> behind this one.
>

OK! I will submit that in the next series(with the zalloc check).

-- 
Pranith
