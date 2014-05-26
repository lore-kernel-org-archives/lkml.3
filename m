Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaEZK5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:57:16 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58536 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaEZK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:57:14 -0400
Message-ID: <53831DBC.8080404@linux.vnet.ibm.com>
Date: Mon, 26 May 2014 16:25:56 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument
 for sleep state enumeration
References: <1817539.9KW2IGGbDV@vostro.rjw.lan> <1579932.qSkFQPvI6f@vostro.rjw.lan> <5382FBD2.3070908@linux.vnet.ibm.com> <2276224.JN17nYXlNX@vostro.rjw.lan>
In-Reply-To: <2276224.JN17nYXlNX@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052610-3568-0000-0000-00000590D3F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 04:30 PM, Rafael J. Wysocki wrote:
> On Monday, May 26, 2014 02:01:14 PM Srivatsa S. Bhat wrote:
>> On 05/23/2014 06:33 PM, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> On some systems the platform doesn't support neither
>>> PM_SUSPEND_MEM nor PM_SUSPEND_STANDBY, so PM_SUSPEND_FREEZE is the
>>> only available system sleep state.  However, some user space frameworks
>>> only use the "mem" and (sometimes) "standby" sleep state labels, so
>>> the users of those systems need to modify user space in order to be
>>> able to use system suspend at all and that is not always possible.
>>>
>>
>> So, is this going to be a temporary solution until all the user-space
>> frameworks have been fixed? I certainly hope so, because this clearly looks
>> like a bug (or a lack of feature) in user-space to me... in the sense that
>> those user-space frameworks don't have support for (i.e., don't know how to
>> deal with) freeze-only systems yet.
>>
>> The more elegant long term solution would have been to teach the kernel to
>> export *truly* relative names such as SUSPEND_DEEP, SUSPEND_SHALLOW,
>> and SUSPEND_LIGHT or something like that (of course, we can debate on what
>> naming would suit best).
> 
> I agree and that's a logical next step, so I have a plan to rename the kernel
> symbols corresponding to each state so that they reflect the code more closely
> (for example, the current PM_SUSPEND_MEM and PM_SUSPEND_STANDBY depend on the
> platform to support them, but that is not clear from the symbol naming, and on
> many platforms _MEM doesn't mean "suspend-to-RAM" anyway).
> 

Ok..

> The strings in the interface are a somewhat different matter, because user
> space already depends on them (which is the source of the problem here), so we
> may need to keep them or at least respond to them as expected when written to
> /sys/power/state.
>

Right, I see your point..
 
> I personally think that we should use "sleep", "snooze" and "pause" to reflect
> the "sleep depth".  And possibly "hibernate" instead of "disk".
> 

Yeah, that sounds good.

>> But this patch continues to keep the names 'SUSPEND_MEM' ("mem") etc., which
>> still implies that we are doing Suspend-to-RAM, because the name itself betrays
>> that info. So IMHO it doesn't really match what the command-line-switch
>> 'relative_sleep_states' says.
>>
>> But I understand that this is a quick hack to make existing user-space work
>> with systems that support only the freeze state. However, for the reasons
>> mentioned above, I hope that this is a temporary solution and we can remove
>> or enhance this once all those user-space frameworks have been fixed.
> 
> Well, it is supposed to be temporary, but I'm not sure if we can count on all
> user space to be fixed in any reasonable time frame (think about Android, for
> example).
> 

Hmm, that's sad. But anyway, I just wanted to point out issues with this patch
and suggest possible enhancements. But since you seem to have already thought
through all of this, I have no objections to this patch.

Thank you!
 
Regards,
Srivatsa S. Bhat

