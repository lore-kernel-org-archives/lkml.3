Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3CYOhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:37:33 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58605 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3CYOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <0000013da1f6170e-7b247826-93a9-4c2d-a316-ba3b0597a805-000000@email.amazonses.com>
References: <20130318222548.GG3656@linux.vnet.ibm.com>
	<1363822338.6345.33.camel@gandalf.local.home>
	<20130320235545.GL3637@linux.vnet.ibm.com>
	<0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
	<20130321171518.GW3637@linux.vnet.ibm.com>
	<0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
	<20130321185821.GF3637@linux.vnet.ibm.com>
	<0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
	<20130321205054.GI3637@linux.vnet.ibm.com>
	<0000013d9289cebc-e6380265-3a74-4343-b851-765f785a3754-000000@email.amazonses.com>
	<20130322162820.GN3637@linux.vnet.ibm.com>
	<0000013da1f6170e-7b247826-93a9-4c2d-a316-ba3b0597a805-000000@email.amazonses.com>
Date: Mon, 25 Mar 2013 15:37:30 +0100
Message-ID: <CAFTL4hzFmrHPHhi3gBj05eJgxb5H7bACEWwCm7jp6Vb0XU15bA@mail.gmail.com>
Subject: Re: [PATCH] nohz1: Documentation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25 Christoph Lameter <cl@linux.com>:
> On Fri, 22 Mar 2013, Paul E. McKenney wrote:
>
>> On Fri, Mar 22, 2013 at 02:38:58PM +0000, Christoph Lameter wrote:
>> > On Thu, 21 Mar 2013, Paul E. McKenney wrote:
>> >
>> > > So, how long of busy periods are you contemplating for your SCHED_FIFO
>> > > threads?  Is it possible to tune/adjust the offending per-CPU ktheads
>> > > to wake up less frequently than that time?
>> >
>> > Test programs right now run 10 seconds. 30 seconds would definitely be
>> > enough for the worst case.
>>
>> OK, that might be doable for some workloads.  What happens when you
>> try tuning the 2-second wakeup interval to (say) 45 seconds?
>
> The vm kernel threads do no useful work if no system calls are being done.
> If there is no kernel action then they can be deferred indefinitely.
>

We can certainly add some user deferrable timer_list. But that's going
to be for extreme usecases (those who require pure isolation) because
we'll need to settle that with a timer reprogramming into user/kernel
boundaries. That won't be free.
