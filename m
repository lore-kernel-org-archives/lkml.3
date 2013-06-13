Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3FMCJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:09:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34332 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3FMCJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:09:32 -0400
X-Spam-Score: -100.8
Message-ID: <51B929AB.3040201@asianux.com>
Date: Thu, 13 Jun 2013 10:08:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/softirq.c: delete 'while' looping to improve a
 little performance and beautify code
References: <51B4755B.4020205@asianux.com> <20130610122543.GG5146@linux.vnet.ibm.com>
In-Reply-To: <20130610122543.GG5146@linux.vnet.ibm.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 08:25 PM, Paul E. McKenney wrote:
> On Sun, Jun 09, 2013 at 08:30:19PM +0800, Chen Gang wrote:
>> > 
>> > After finish the internal 'while', need not test TASKLET_STATE_SCHED
>> > again, so looping back to outside 'while' is only for set_bit().
>> > 
>> > When use 'if' and set_bit() instead of 'while', it will save at least
>> > one running conditional instruction, and also will be clearer for readers
>> > (although the binary size will be a little bigger).
>> > 
>> > The related patch is "1da177e Linux-2.6.12-rc2"
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  kernel/softirq.c |    3 ++-
>> >  1 files changed, 2 insertions(+), 1 deletions(-)
>> > 
>> > diff --git a/kernel/softirq.c b/kernel/softirq.c
>> > index a5f8836..52da25f 100644
>> > --- a/kernel/softirq.c
>> > +++ b/kernel/softirq.c
>> > @@ -540,10 +540,11 @@ void tasklet_kill(struct tasklet_struct *t)
>> >  	if (in_interrupt())
>> >  		printk("Attempt to kill tasklet from interrupt\n");
>> > 
>> > -	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
>> > +	if (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
>> >  		do {
>> >  			yield();
>> >  		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
>> > +		set_bit(TASKLET_STATE_SCHED, &t->state);
> This replaces an atomic test-and-set with two operations, a test and
> a set.  Is this safe?

Oh, it seems not safe, at least it is not the original author's willing.

It is my fault, and also sorry for replying late.


Thanks.
-- 
Chen Gang

Asianux Corporation
