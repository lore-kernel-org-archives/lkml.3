Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaDDSNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:13:54 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42012 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaDDSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:13:53 -0400
Message-ID: <533EF65E.6050508@mit.edu>
Date: Fri, 04 Apr 2014 11:13:50 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sean Pajot <sean.pajot@execulink.com>,
        lxc-devel@lists.linuxcontainers.org, linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] Kernel bug? Setuid apps and user namespaces
References: <5266BEA3.6020008@execulink.com> <20131022193718.GA18463@ac100> <874n89rsoc.fsf@xmission.com> <20140402172049.GA13240@sergelap> <20140402173248.GA22804@mail.hallyn.com>
In-Reply-To: <20140402173248.GA22804@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 10:32 AM, Serge E. Hallyn wrote:
> (Sorry - the lxc-devel list has moved, so replying to all with the
> correct list address;   please reply to this rather than my previous
> email)
> 
> Quoting Serge Hallyn (serge.hallyn@ubuntu.com):
>> Hi Eric,
>>
>> (sorry, I don't seem to have the email I actually wanted to reply
>> to in my mbox, but it is
>> https://lists.linuxcontainers.org/pipermail/lxc-devel/2013-October/005857.html)
>>
>> You'd said,
>>> Someone needs to read and think through all of the corner cases and see
>>> if we can ever have a time when task_dumpable is false but root in the
>>> container would not or should not be able to see everything.
>>>
>>> In particular I am worried about the case of a setuid app calling setns,
>>> and entering a lesser privileged user namespace.  In my foggy mind that
>>> might be a security problem.  And there might be other similar crazy
>>> cases.
>>
>> Can we make use of current->mm->exe_file->f_cred->user_ns?
>>
>> So either always use 
>> make_kgid(current->mm->exe_file->f_cred->user_ns, 0)
>> instead of make_kuid(cred->user_ns, 0), or check that
>> (current->mm->exe_file->f_cred->user_ns == cred->user_ns)
>> and, if not, assume that the caller has done a setns?

Do you have a summary of the issue?  I'm a little lost here.

I suspect that what we really need is to revoke a bunch of proc files
every time a task does anything involving setuid (or, more generally,
any of the LSM_UNSAFE_PTRACE things).

--Andy
