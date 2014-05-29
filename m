Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaE2Mxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:53:40 -0400
Received: from relay.parallels.com ([195.214.232.42]:57853 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbaE2Mxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:53:39 -0400
Message-ID: <53872DAD.1070502@parallels.com>
Date: Thu, 29 May 2014 16:53:01 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vasily Kulikov <segoon@openwall.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com> <5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot> <53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot> <5386F8EA.8050501@parallels.com> <20140529111236.GA14576@cachalot> <53871A92.9000004@parallels.com> <20140529115946.GA19889@cachalot>
In-Reply-To: <20140529115946.GA19889@cachalot>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.24.36.87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 03:59 PM, Vasily Kulikov wrote:
> On Thu, May 29, 2014 at 15:31 +0400, Pavel Emelyanov wrote:
>> On 05/29/2014 03:12 PM, Vasily Kulikov wrote:
>>> On Thu, May 29, 2014 at 13:07 +0400, Pavel Emelyanov wrote:
>>>> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
>>>>> On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
>>>>> ] We need a direct method of getting the pid inside containers.
>>>>> ] If some issues occurred inside container guest, host user
>>>>> ] could not know which process is in trouble just by guest pid:
>>>>> ] the users of container guest only knew the pid inside containers.
>>>>> ] This will bring obstacle for trouble shooting.
>>>>>
>>>>> A new syscall might complicate trouble shooting by admin.
>>>>
>>>> Pure syscall -- yes. What if we teach the ps and top utilities to show additional
>>>> info? I think that would help.
>>>
>>> I like the idea with low level non-shell API which can be used by
>>> utility like ps (or implementation of a new tool to work with complex
>>> namespace hierarchies).  It should fit for troublesooting.  Then there
>>> should be no reason to implement two different APIs for observation from
>>> shell via FS and from applications.
>>
>> Maybe we can reuse the existing kcmp() system call? We would have to store
>> the collected pid values in some hash/tree anyway, and kcmp() provides us
>> good comparing function for doing this.
>>
>> Like we can call kcmp(pid1, pid2, KCMP_PID, nsfd1, nsfd2) which will mean
>> "Are tasks with pid1 in namespace pointed by nsfd1 and with pid2 in namespace
>> nsfd2 the same?"
>>
>> What do you think?
> 
> kcmp() is not needed, just compare inode numbers:
> 
>     # ls -il /proc/{43,self}/ns/mnt
>     208182 lrwxrwxrwx 1 root root 0 мая   29 15:52 /proc/43/ns/mnt -> mnt:[4026531856]
>     216556 lrwxrwxrwx 1 root root 0 мая   29 15:57 /proc/self/ns/mnt -> mnt:[4026531840]

But that's for comparing the namespaces, while I'm proposing the kcmp to
check for PIDs.

Thanks,
Pavel
