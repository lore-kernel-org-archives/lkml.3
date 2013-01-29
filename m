Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab3A2WBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:01:23 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61214 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2WBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:01:21 -0500
Message-ID: <510846AB.8010900@suse.cz>
Date: Tue, 29 Jan 2013 23:01:15 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: set_termios/set_termiox should not return -EINTR
References: <20130129190720.GA28000@redhat.com> <20130129190741.GA28004@redhat.com> <51082470.2070601@suse.cz> <20130129194908.GA29480@redhat.com>
In-Reply-To: <20130129194908.GA29480@redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 08:49 PM, Oleg Nesterov wrote:
> On 01/29, Jiri Slaby wrote:
>>
>> On 01/29/2013 08:07 PM, Oleg Nesterov wrote:
>>>
>>> Change set_termios/set_termiox to return -ERESTARTSYS to fix this
>>> particular problem.
>>
>> This looks reasonable. However given the link above says:
>>  You are not authorized to access bug #904907.
>> the description above is poor. What problem exactly does this fix?
> 
> A syscall must never return EINTR unless it can not be restarted
> (or it should not be restarted by, say, historical reasons).
> 
> In this case ioctl(TCSETAW) returns -EINTR even if it is interrupted
> by the signal which has the SA_RESTART handler. This doesn't look right
> no matter what.

Yes, and more, it is against POSIX. I don't dispute the correctness of
the patch at all.

>> Why this should go to stable at all?
> 
> OK, this is up to you.
> 
> But if this patch is correct, perhaps it should be backported. This
> -EINTR breaks /bin/bash which doesn't expect it, this leads to
> "*** glibc detected *** ./bash-4.1.2-14.el6/bin/bash: double free or corruption (out):"
> 
> Perhaps /bin/bash is buggy too, I do not know. Probably Roman and
> Lingzhu can tell more.

But I really want to hear more details here (the commit log deserves
that). E.g. why it started causing problems right now. The code is there
like forever.

-- 
js
suse labs
