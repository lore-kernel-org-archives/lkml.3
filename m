Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3KUOPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:15:46 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:40914 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3KUOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:15:45 -0500
Message-ID: <528E158C.8000309@gmail.com>
Date: Thu, 21 Nov 2013 15:15:40 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>	<1383831828-15501-4-git-send-email-juri.lelli@gmail.com> <20131120152358.2a6abfc3@gandalf.local.home>
In-Reply-To: <20131120152358.2a6abfc3@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 09:23 PM, Steven Rostedt wrote:
> On Thu,  7 Nov 2013 14:43:37 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
> 
> 
>> +/*
>> + * This function validates the new parameters of a -deadline task.
>> + * We ask for the deadline not being zero, and greater or equal
>> + * than the runtime.
>> + */
>> +static bool
>> +__checkparam_dl(const struct sched_param2 *prm)
>> +{
>> +	return prm && (&prm->sched_deadline) != 0 &&
>> +	       (s64)(&prm->sched_deadline - &prm->sched_runtime) >= 0;
> 
> Patch 6 brought this to my attention. Looks like using the address of
> the fields is wrong. I know patch 6 fixes this, but lets make it
> correct in this patch first.
> 

Fixed.

Thanks,

- Juri

> 
>> +}
>> +
>> +/*
>>   * check the target process has a UID that matches the current process's
>>   */
>>  static bool check_same_owner(struct task_struct *p)
