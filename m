Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaENKon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:44:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62800 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaENKoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:44:38 -0400
Message-ID: <53734911.30306@suse.cz>
Date: Wed, 14 May 2014 12:44:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-4-git-send-email-jslaby@suse.cz> <53733746.1040200@linux.vnet.ibm.com> <53734176.5000003@suse.cz> <5373483E.50300@linux.vnet.ibm.com>
In-Reply-To: <5373483E.50300@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 12:41 PM, Aravinda Prasad wrote:
> 
> 
> On Wednesday 14 May 2014 03:42 PM, Jiri Slaby wrote:
>> On 05/14/2014 11:28 AM, Aravinda Prasad wrote:
>>> On Wednesday 30 April 2014 08:00 PM, Jiri Slaby wrote:
>>>> From: Jiri Kosina <jkosina@suse.cz>
>>>>
>>>> Provide initial implementation. We are now able to do ftrace-based
>>>> runtime patching of the kernel code.
>>>>
>>>> In addition to that, we will provide a kgr_patcher module in the next
>>>> patch to test the functionality.
>>>
>>> Hi Jiri,
>>>
>>> Interesting! I have couple of comments:
>>>
>>> I think with kgraft (also with kpatch, though have not looked into
>>> it yet), the patched function cannot be dynamically ftraced.
>>> Though dynamic ftrace can be enabled on the new code, the user is
>>> required to know the function label of the new code. This could
>>> potentially break existing scripts. I think this should be documented.
>>
>> Hi,
>>
>> of course that the functions can be traced. Look, I turned on tracing
>> for capable, then patched, then turned on tracing for new_capable (which
>> is the patched function). So now, trace shows:
>>   console-kit-dae-535   [001] ...1   181.729698: capable <-vt_ioctl
>>  console-kit-dae-539   [001] ...1   181.729741: capable <-vt_ioctl
>>  console-kit-dae-541   [000] .N.1   181.906014: capable <-vt_ioctl
>>          systemd-1     [001] ...1   181.937328: capable <-SyS_epoll_ctl
>>             sshd-662   [001] ...1   246.437561: capable <-sock_setsockopt
>>             sshd-662   [001] ...1   246.437564: new_capable
>> <-sock_setsockopt
>>             sshd-662   [001] ...1   246.444790: capable <-sock_setsockopt
>>             sshd-662   [001] ...1   246.444793: new_capable
>> <-sock_setsockopt
>>      dbus-daemon-128   [000] .N.1   246.456307: capable <-SyS_epoll_ctl
>>      dbus-daemon-128   [000] ...1   246.456611: new_capable <-SyS_epoll_ctl
>>
>>
>> There is no limitation thanks to the use of the ftrace subsystem. We are
>> just another user, i.e. another piece of code called in a loop for a
>> particular fentry location.
> 
> Yes true. What I intended to mention is that: the trace is turned on
> for "capable" then the function is patched. Eventually, once the patch
> is finalized, there will be no trace log for "capable". Someone tracing
> the function "capable", not aware of patching, may think that it has not
> been invoked. The user, hence, is expected to start tracing
> "new_capable". I think this should be documented.

As you can see in the trace log above, no. fentry of capable is still
traced (and new_capable is traced along)...

> What if someone turns on tracing for "capable" after it is patched?
> Will it overwrite the slow/fast stub?

Nope, it would look like in the example above.

thanks,
-- 
js
suse labs
