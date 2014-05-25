Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaEYTmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48282 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEYTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:04 -0400
Message-ID: <53824787.4030905@colorfullife.com>
Date: Sun, 25 May 2014 21:41:59 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Subject: Re: [PATCH 7/6] ipc/sem.c: add a printk_once for semctl(GETNCNT/GETZCNT)
References: <1401042063-24666-1-git-send-email-manfred@colorfullife.com> <1401043188.22191.16.camel@joe-AO725>
In-Reply-To: <1401043188.22191.16.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 05/25/2014 08:39 PM, Joe Perches wrote:
> On Sun, 2014-05-25 at 20:21 +0200, Manfred Spraul wrote:
> +	 */
> +	printk_once(KERN_INFO "semctl(GETNCNT/GETZCNT) is since 3.16 Single " \
> +				"Unix Specification compliant.\n" \
> +				"The task %d triggered the difference, " \
> +				"watch for misbehavior.", current->pid);
> Unnecessary line continuations.
> Missing terminating newline after "misbehavior"
> Ideally coalesced or broken at linebreaks like:
>
> 	pr_info_once("semctl(GETNCNT/GETZCNT) is Single Unix Specification compliant since kernel v3.16\n"
> 		     "Task %d triggered the difference, watch for misbehavior\n",
> 		     current->pid);
Thanks. I'll try to remember to really run checkpatch instead of 
assuming what it might report.
>>   	if (sop->sem_num != semnum)
>>   		return 0;
>>   
> Should the printk_once (which could be pr_info_once or _ratelimited
> or maybe even emitted at KERN_DEBUG) be done only when
> the return is 1?
>
To fully check if there is a difference would mean that the old code and 
the new code run in parallel.

The code might trigger slightly too often, but since there are zero 
known users of GETZCNT / GETNCNT simplicity wins.

--
     Manfred
