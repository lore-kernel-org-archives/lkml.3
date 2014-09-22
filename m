Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaIVRok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:44:40 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40447 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaIVRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140922170149.GP4723@linux.vnet.ibm.com>
References: <1411318194-9433-1-git-send-email-bobby.prani@gmail.com>
 <20140922162534.GA25352@thin> <CAJhHMCCpkVqdbMirw2ON=4+pPQgWKczgq_Y9BCv3_fj6yGp_MQ@mail.gmail.com>
 <20140922170149.GP4723@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 22 Sep 2014 13:44:08 -0400
Message-ID: <CAJhHMCBeqLN4dTS5uswUjwfcajT2LQ63NgbJm-FXRAB-XScsdw@mail.gmail.com>
Subject: Re: [PATCH] rcu: Remove redundant CONFIG_PREEMPT_RCU option
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 1:01 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Sep 22, 2014 at 12:49:24PM -0400, Pranith Kumar wrote:
>> On Mon, Sep 22, 2014 at 12:25 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>> >
>> > I think it would actually make more sense to do this the other way
>> > around, if at all: drop TREE_PREEMPT_RCU in favor of PREEMPT_RCU.  The
>> > instances shown here don't care about *which* preemptible RCU
>> > implementation the kernel uses, they just need to behave differently
>> > when preemptible.  Let's also not assume that no new RCU implementation
>> > will ever arise superceding TREE_PREEMPT_RCU.
>>
>> That is exactly what I did first and got the following changelog:
>>
>>  51 files changed, 77 insertions(+), 83 deletions(-)
>>
>> compared to
>>
>>  8 files changed, 19 insertions(+), 25 deletions(-)
>
> Were the bulk of the files defconfig files?  These need not be changed,
> the architecture maintainers handle them.
>

There are only two defconfig files in there. I removed them now. Most
of them are rcutorture config files. I guess that should be fine. I am
sending the patch now.

-- 
Pranith
