Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3LTGWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:22:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3LTGWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:22:48 -0500
Message-ID: <52B3E221.4000909@canonical.com>
Date: Thu, 19 Dec 2013 22:22:25 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from may_change_ptraced_domain()
References: <20131218194338.GB23692@madcap2.tricolour.ca> <20131218201940.GA9694@redhat.com> <20131220043632.GA14884@madcap2.tricolour.ca>
In-Reply-To: <20131220043632.GA14884@madcap2.tricolour.ca>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 08:36 PM, Richard Guy Briggs wrote:
> On 13/12/18, Oleg Nesterov wrote:
>> On 12/18, Richard Guy Briggs wrote:
>>>
>>> Bcc: rgb@redhat.com
>>> Subject: Re: [PATCH] apparmor: remove the "task" arg from
>>>  may_change_ptraced_domain()
>>> Reply-To:
>>> In-Reply-To: <20130926132519.GY13968@madcap2.tricolour.ca>
>>
>> The subject is empty ;) I changed it to match the above.
> 
> HTH?!?  Thanks for adding it.  (more below...)
> 
>>> On 13/09/26, Richard Guy Briggs wrote:
>>>> On Tue, Sep 24, 2013 at 06:44:42PM +0200, Oleg Nesterov wrote:
>>>>> On 09/23, Richard Guy Briggs wrote:
>>>>>>
>>>>>> On Mon, Sep 16, 2013 at 04:20:35PM +0200, Oleg Nesterov wrote:
>>>>>>> Unless task == current ptrace_parent(task) is not safe even under
>>>>>>> rcu_read_lock() and most of the current users are not right.
>>>>>>
>>>>>> Could you point to an explanation of this?
>>>>>
>>>>> If this task exits before rcu_read_lock() ->parent can point to the
>>>>> already freed/reused memory.
>>>>
>>>> Ok, understood.  So even though the task may have exited, the task
>>>> struct pointer is still valid, but not the contents of the task struct
>>>> to which it points.
>>>
>>> [The thread also relates to the patch
>>> 	"pid: get ppid pid_t of task in init_pid_ns safely"
>>> in which sys_getppid() (which appears safe) is replaced with something that
>>> references the init_pid_ns rather than current's pid_ns.]
>>>
>>> So, in the general case, that call is not safe, and we should at least
>>> remove the task_struct argument.
>>
>> I changed my mind, please see the recent discussion with Paul:
>>
>> 	http://marc.info/?t=138626281900001
>>
>> instead we should document why ptrace_parent() is safe without pid_alive().
> 
> Interesting.  I wasn't aware of pid_alive(), but that would certainly
> help.
> 
>> I hope that the change in apparmor was fine anyway.
> 
> Yes, I'm fine with apparmor change, if it was deemed that the ppid
> wasn't needed.  If it is, then it should use this new task_ppid_nr().
it wasn't needed, changes where made years ago to allow us to get rid of
using the parent pid. Its was left in for a transition period and just
had never been removed.

> Better yet I think to generalize it to anticipate auditd in containers.
> 
yep, that is the way to go

