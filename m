Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaLBQXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:23:09 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62480 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaLBQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <1417534380.5303.64.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
	<CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
	<1417534380.5303.64.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 3 Dec 2014 03:23:06 +1100
Message-ID: <CAPs88r-jZ5FvCHQjArKXhpX1YRg3O4NdUFtLizraF6nZ9SjFKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Alex Dubov <alex.dubov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 2:33 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2014-12-03 at 01:47 +1100, Alex Dubov wrote:
>> > User A can send fd(s) to processes belonging to user B, even if user B
>> > does (probably) not want this to happen ?
>>
>> 1. Process A must have sufficient permissions to signal process B.
>> This will only happen if process A belongs to the same user as process
>> B or has elevated capabilities, which can not appear by themselves
>> (and if root on some machine can not be trusted, then all is lost
>> anyway).
>>
>
> I do not see this enforced in your patch.
>
> Allowing a process to hold many times the lock protecting my file
> descriptor table is very scary.
>
> Reserving a slot, then undo this if the signal failed is a nice way to
> slow down critical programs and eventually block them from doing
> progress when using file descriptors (most system calls afaik)

Yes, this is an omission. I already promised to tighten the security
in my last post. :)

>> 2. If process B has not specified explicitly how it wants the
>> particular signal to be handled, it will be killed by the default
>> handler. End of story, nothing else is going to happen.
>
> So it seems possible for an arbitrary program to send fds to innocent
> programs, that will likely fill their fd table and wont be able to open
> a new file.
>
> This opens interesting security issues and attack vectors.

Same as SIGKILL. And yet, our machines are still working fine.

If process A has sufficient capability to send signals to process B,
then process B is already at its mercy, fds or not fds.
