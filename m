Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbaAJTfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:35:30 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33258 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaAJTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:35:26 -0500
Message-ID: <52D04B7A.4000801@amacapital.net>
Date: Fri, 10 Jan 2014 11:35:22 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Victor Porton <porton@narod.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: A feature suggestion for sandboxing processes
References: <223151389311706@web9g.yandex.ru> <20391389377691@web5j.yandex.ru>
In-Reply-To: <20391389377691@web5j.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 10:14 AM, Victor Porton wrote:
> I was told that it can be done using cgroups. So no urgent necessity to add my new syscall.

Yeah, right.  Good luck writing a program that will work on modern Red
Hat, Fedora, and Ubuntu systems.

Cgroups is IMO a complete and utter failure in providing an interface
usable by normal programs, and it's getting *worse* over time.

--Andy

> 
> 10.01.2014, 01:55, "Victor Porton" <porton@narod.ru>:
>> In Fedora there is bin/sandbox command which runs a specified command in so called 'sandbox'. Program running in sandbox cannot open new files (it is commonly used with preopen stdin and stdout) and possibly its access to network is limited. It is intended to run potentially malicious software safely.
>>
>> This Fedora sandbox is not perfect however.
>>
>> One problem is:
>>
>> Suppose the sandboxed program spawned some child processes and exited itself.
>>
>> Suppose we want to kill the sandboxed program after 30 second, if it has not exited voluntarily.
>>
>> The trouble is that the software cannot figure out which processes have appeared from the sandboxed binary. So we are unable to kill these processes automatically. This means that a hacker can in this way create thousands (or more) processes which would overload the system.
>>
>> Also note that the sandboxed program may run setsid() and thus its identity may be lost completely.
>>
>> I propose to add parameter sandbox_id to each process in the kernel. It would be 0 for normal processes and allocated like PID or GID for processes we create in sandbox. Children inherit sandbox_id. There should be an API call using which a process makes it sandboxed_id non-zero (which returns EPERM if it is already non-zero).
>>
>> Then there should be API to enumerate all processes with given sandbox_id, so that we would be able to kill them (-TERM or -KILL). Or maybe we should also have the function which sends the given signal to all processes with given sandbox_id (otherwise we would war with a hacker which could possibly create new children faster than we kill them).
>>
>> Please add me in CC: (I am not subscribed for this mailing list.)
> 

