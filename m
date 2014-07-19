Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaGSUGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 16:06:21 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaGSUGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 16:06:20 -0400
Message-ID: <53CACFB8.2000807@nod.at>
Date: Sat, 19 Jul 2014 22:06:16 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ls -l /proc/1/exe -> Permission denied
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se> <CAFLxGvw6W196E4mcefz_b16iGHSFKF=RP1gx5eLj0U5NSR9SXg@mail.gmail.com> <OF542E7A59.842197B0-ONC1257D19.004B7FF4-C1257D19.004BEC7C@LocalDomain> <OF94BC7D2A.31F0FF60-ONC1257D19.00528EC9-C1257D19.0052E7FB@transmode.se>
In-Reply-To: <OF94BC7D2A.31F0FF60-ONC1257D19.00528EC9-C1257D19.0052E7FB@transmode.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 18.07.2014 17:05, schrieb Joakim Tjernlund:
> Joakim Tjernlund/Transmode wrote on 2014/07/18 15:49:17:
>>
>> Richard Weinberger <richard.weinberger@gmail.com> wrote on 2014/07/18 
> 14:58:30:
>>>
>>> On Thu, Jul 17, 2014 at 1:18 PM, Joakim Tjernlund
>>> <joakim.tjernlund@transmode.se> wrote:
>>>> Trying to real /proc/<pid>/exe I noticed I could not read links not
>>>> belonging to my user such as:
>>>> jocke >  ls -l /proc/1/exe
>>>>              ls: cannot read symbolic link /proc/1/exe: Permission 
> denied
>>>>
>>>> Is this expected?
>>>
>>> Why do you think this is unexpected?
> 
>> It only shows the full path to the executable, compare with comm which 
> shows basename(app).
>>
>> I have an idea for qemu-user which needs to identify which processes
>> are running /usr/bin/qemu-<arch> and which are not so it knows how
>> to munge different /proc/ files.
> 
> Just to be clear, I expect to read where /proc/1/exe points, not the 
> contents of the file
> pointed to.
> 
> It seems that any and all symlinks are forbidden:
>> ls -l /proc/1
> ls: cannot read symbolic link /proc/1/cwd: Permission denied
> ls: cannot read symbolic link /proc/1/root: Permission denied
> ls: cannot read symbolic link /proc/1/exe: Permission denied

Because they all share the same implementation.
See proc_pid_link_inode_operations() in fs/proc/base.c

Happy hacking. :-)

Thanks,
//richard
