Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3LQOfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:35:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:39069 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3LQOfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:35:50 -0500
Message-ID: <52B06141.5020803@linutronix.de>
Date: Tue, 17 Dec 2013 15:35:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.5-rt6
References: <20131216091431.GA13796@linutronix.de>  <1387264591.5340.23.camel@marge.simpson.net>  <20131217063156.6ac3bfed@gandalf.local.home>  <20131217124248.GA21694@linutronix.de>  <20131217091624.65be757c@gandalf.local.home> <1387290376.2399.11.camel@marge.simpson.net>
In-Reply-To: <1387290376.2399.11.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 03:26 PM, Mike Galbraith wrote:
> On Tue, 2013-12-17 at 09:16 -0500, Steven Rostedt wrote: 
>>
>>> @@ -1129,11 +1127,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
>>>  		 * is actually now running somewhere else!
>>>  		 */
>>>  		while (task_running(rq, p)) {
>>> -			if (match_state) {
>>> -				if (!unlikely(check_task_state(p, match_state)))
>>> -					return 0;
>>> +			if (match_state && !check_task_state(p, match_state))
>>
>> Ah, it was that "!unlikely(" that caused me to miss the '!'. That
>> should have been: likely(!check_task_state()). But anyway, I rather
>> just keep what you wrote and drop the unlikely altogether.
> 
> Maybe better would be to put the thing back inline, with a brief
> reference to the race.

There is similar code in
- task_is_stopped_or_traced()
- task_is_traced()

and I didn't get around to have one function for this stupid check
since the check is always a little different.

> -Mike

Sebastian
