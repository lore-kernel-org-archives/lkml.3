Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaKAD3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 23:29:38 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49690 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKAD3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 23:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <87a94blj6m.fsf@x220.int.ebiederm.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
 <87a94blj6m.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 20:29:15 -0700
Message-ID: <CALCETrWTtGH=q0kD=hFv=LryA+h=K3yCV4_CmgD=TMbuaW3LrA@mail.gmail.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aditya Kali <adityakali@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 7:59 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>>> @@ -1862,6 +1904,7 @@ static struct file_system_type cgroup_fs_type = {
>>>         .name = "cgroup",
>>>         .mount = cgroup_mount,
>>>         .kill_sb = cgroup_kill_sb,
>>> +       .fs_flags = FS_USERNS_MOUNT,
>>
>> Aargh, another one!  Eric, can you either ack or nack my patch?
>> Because if my patch goes in, then this line may need to change.  Or
>> not, but if a stable release with cgroupfs and without my patch
>> happens, then we'll have an ABI break.
>
> cgroupfs has no device nodes.  So as long as we are consistent in any
> given release what happens here is orthogonal.
>
> I don't remember if we have managed to get the original problem fixed
> with the trivial backportable solution.  I think so.

I don't remember.  I think the problem is still there, since I think
my patch still applies, and my patch conflicts with your fix.  It's
been long enough that I'm not sure it's worth applying your patch as
an interim fix.

>
> My apologies for not getting to that I haven't even had time to shepherd
> through the regression associated regression fix.  I probably just lock
> track of them but I haven't found the Tested-By's for it yet.

No worries.  I've tested it, but it's my patch, so there's a big grain
of salt there.  I think Serge tested it, too.

>
> Nor have I had time to dig through and figure out how to safely deal
> with umount -l aka MOUNT_DETACH.

If you're talking about the do_remount_sb thing, that's already in Linus' tree.

>
> Along with the question about what to do with nodev, there is also
> your patch about nosuid.

The nosuid patch has a couple versions, and I'm not sure which version
I prefer.  It's certainly debatable.

>
> Starting in about 5 minutes I am going to be mostly offline until
> sometime in the 3rd week in November as I haul all of my stuff accross
> the country to someplace that actually has winter and my allergies don't
> kill me.

Have fun!

--Andy

>
> I am going to have to review and merge a lot of code as soon as I am
> back to being a programmer full time again.  There is a lot of
> interesting stuff coming in right now.
>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
