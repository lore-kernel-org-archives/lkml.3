Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaKWMWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 07:22:16 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:63572 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaKWMWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 07:22:15 -0500
MIME-Version: 1.0
In-Reply-To: <20141121145817.GA17710@node.dhcp.inet.fi>
References: <20141028220944.GA26114@linux.vnet.ibm.com> <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141121133145.GA17245@node.dhcp.inet.fi> <546F4C8C.4040904@gmail.com> <20141121145817.GA17710@node.dhcp.inet.fi>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 23 Nov 2014 07:21:44 -0500
Message-ID: <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 3/9] drivers/md: Use rcu_dereference() for
 accessing rcu pointer
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 9:58 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Fri, Nov 21, 2014 at 09:30:36AM -0500, Pranith Kumar wrote:
>> On 11/21/2014 08:31 AM, Kirill A. Shutemov wrote:
>> > On Tue, Oct 28, 2014 at 03:09:56PM -0700, Paul E. McKenney wrote:
>> >> From: Pranith Kumar <bobby.prani@gmail.com>
>> >>
>> >> Got Paul's email wrong the first time.
>> >>
>> >> The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
>> >> while accessing it.
>> >>
>> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> >> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> >
>> > On current -next I see this:
>> >
>> > [    6.388264] ===============================
>> > [    6.389571] [ INFO: suspicious RCU usage. ]
>> > [    6.390869] 3.18.0-rc5-next-20141121-08303-g44cae4530372 #2 Not tainted
>> > [    6.392185] -------------------------------
>> > [    6.393479] /home/kas/git/public/linux/drivers/md/dm.c:2853 suspicious rcu_dereference_check() usage!
>> > [    6.394801]
>> > other info that might help us debug this:
>> >
>>
>> Hi Kirill,
>>
>> We are dereferencing an RCU pointer with the suspend_lock held which is causing this warning.
>>
>> Can you please check if the following patch helps? Thanks!
>
> Nope. The same issue.
>
> IIUC, the problem is that you dereference pointer outside rcu_read_lock()
> section, not that suspend_lock is held.
>

I am not sure we should be taking rcu_read_lock() there as I am not
sure how long that critical section might last. Can someone who is
more familiar with the code take a look?

I will try to look for a solution too in the mean time.

Thanks!
-- 
Pranith
