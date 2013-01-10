Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3AJWnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3AJWnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:43:07 -0500
Message-ID: <50EF43F8.3040403@redhat.com>
Date: Thu, 10 Jan 2013 14:43:04 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anton Arapov <anton@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer handler
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-6-git-send-email-anton@redhat.com> <20121222163545.GE18082@redhat.com> <20121222171329.GA20691@redhat.com> <20121223154910.GA7106@redhat.com> <20130108142715.GA16849@bandura.brq.redhat.com>
In-Reply-To: <20130108142715.GA16849@bandura.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 06:27 AM, Anton Arapov wrote:
> On Sun, Dec 23, 2012 at 04:49:10PM +0100, Oleg Nesterov wrote:
>> On 12/22, Oleg Nesterov wrote:
>>>> Just change regs->ip before calling ->handler().
>>>
>>> Josh, Frank, will it work for you?
>>
>> Wait, probably I was confused by this patch and 4/6...
>>
>> To simplify, lets ignore the normal uprobes. Yes I still think that it
>> would be better to set "regs->ip = orig_return_vaddr" before calling
>> ->handler() and not pass it as an argument.
>>
>> But, probably uprobe_consumer also needs to know bp_vaddr? IOW, the
>> address of the function which we are going to return from? In this case,
>> yes, we also need another argument. And prepare_uretprobe/etc should
>> be changed to record bp_vaddr passed from handle_swbp(). And
>> uretprobe_run_handlers() should pass this bp_vaddr, not orig_return_vaddr.
>>
>> Or I am confused.
>>
>> Anton?
> 
>   Oleg, you are absolutely right and change the ip before calling the
> ->handle is much better then what I 'invented'.
>  
>   I'm working on v2 to address this and other issues, will post it soon.

For uprobes, systemtap wants regs->ip to be the real breakpoint address,
and for uretprobes we want the original return address.  With the
utrace-based uprobes we would munge it by modifying regs->ip before
continuing with the rest of our handler.  If uprobes now wants to
prepare regs->ip for us in the same way, I think that's fine.

Josh
