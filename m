Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3AQK5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:57:19 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34005 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab3AQK5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:57:16 -0500
Message-ID: <50F7D8C2.1030506@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 16:26:02 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ivo Sieben <meltedpianoman@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
 queue is active
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com> <50E3FDFA.4070203@suse.cz>	<20130102114311.66215bf5@pyramind.ukuu.org.uk> <CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com> <50E4854E.8060801@suse.cz> <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com> <50F66120.50704@linux.vnet.ibm.com> <CAMSQXEE=Qp8kVcEp8nBhNDmOaDMUQUUou+5Z2f8-1znykqy6mQ@mail.gmail.com> <50F683D9.1080908@linux.vnet.ibm.com> <CAMSQXEHjP5mzs9u5DUmuYgoEceM2OO=E8844-XQ7LPCSECoGRw@mail.gmail.com>
In-Reply-To: <CAMSQXEHjP5mzs9u5DUmuYgoEceM2OO=E8844-XQ7LPCSECoGRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011710-0260-0000-0000-0000026B7E91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 05:32 PM, Ivo Sieben wrote:
> 2013/1/16 Preeti U Murthy <preeti@linux.vnet.ibm.com>:
>>
>> Yes.Thank you very much for the explanation :) But I dont see how the
>> context switching goes away with your patch.With your patch, when the
>> higher priority thread comes in when the lower priority thread is
>> running in the critical section,it will see the wait queue empty and
>> "continue its execution" without now wanting to enter the critical
>> section.So this means it will preempt the lower priority thread because
>> it is not waiting on a lock anyway.There is a context switch here right?
>> I dont see any problem in scheduling due to this,but I do think your
>> patch is essential.
>>
> 
> I don't have a problem that there is a context switch to the high
> priority process: it has a higher priority, so it probably is more
> important.
> My problem is that even when the waitqueue is empty, the high priority
> thread has a risk to block on the spinlock needlessly (causing context
> switches to low priority task and back to the high priority task)
> 
Fair enough Ivo.I think you should go ahead with merging the
waitqueue_active()
  wake_up()
logic into the wake_up() variants.

Regards
Preeti U Murthy

