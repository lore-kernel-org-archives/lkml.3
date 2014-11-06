Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaKFR2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:28:48 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63344 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaKFR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:28:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141104135726.GB14014@htj.dyndns.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
 <CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com> <20141104135726.GB14014@htj.dyndns.org>
From: Aditya Kali <adityakali@google.com>
Date: Thu, 6 Nov 2014 09:28:25 -0800
Message-ID: <CAGr1F2Es3nkWePqRpKoAFoRB5SZp=BvQh7espyxjaRy_fYAbCw@mail.gmail.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
To: Tejun Heo <tj@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:57 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Aditya.
>
> On Mon, Nov 03, 2014 at 03:12:28PM -0800, Aditya Kali wrote:
>> I think the sane-behavior flag is only temporary and will be removed
>> anyways, right? So I didn't bother asking user to supply it. But I can
>> make the change as you suggested. We just have to make sure that tasks
>> inside cgroupns cannot mount non-default hierarchies as it would be a
>> regression.
>
> I'm not sure whether supporting mounting from inside a ns is even
> necessary but, if it is, can't you just test against cgrp_dfl_root?
> There's no reason to do anything differnetly for ns mounting.
>

I am not sure I fully understand what you mean. But we don't have a
way to test against cgrp_dfl_root while parsing mount-options. They
only way we know that user is trying to mount a default hierarchy is
via the sane_behavior flag. So I need to test against this flag it if
we want to restrict processes inside cgroupns to mounting the default
hierarchy only.
Or are you suggesting that its OK for nsown_capable(CAP_SYS_ADMIN)
processes to mount any cgroup hierarchy (irrespective of their
cgroupns)? I assumed that this will be a undesirable.

> Thanks.
>
> --
> tejun


Thanks,
-- 
Aditya
