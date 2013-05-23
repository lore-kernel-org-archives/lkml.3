Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3EWIIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:08:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:40904 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3EWII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:08:27 -0400
Message-ID: <519DCE5D.6070204@parallels.com>
Date: Thu, 23 May 2013 12:07:57 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <viro@zeniv.linux.org.uk>, <serge.hallyn@canonical.com>,
        <jlayton@redhat.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <oleg@redhat.com>, <bfields@fieldses.org>, <bharrosh@panasas.com>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <devel@openvz.org>
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
References: <20130522072840.27720.85023.stgit@localhost.localdomain> <878v36ex6n.fsf@xmission.com>
In-Reply-To: <878v36ex6n.fsf@xmission.com>
Content-Type: text/plain; charset="windows-1251"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22.05.2013 21:33, Eric W. Biederman пишет:
> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
>
>> Usermode helper executes all binaries in global "init" root context. This
>> doesn't allow to call a binary from other root context (for example in a
>> container).
>> Currently, both containerized NFS client and NFS server requires an ability to
>> execute a binary in a container's root context. Root swap can be done in
>> "init" callback, passed by UMH caller.
>> But since we have 2 callers already (and more of them are expected to appear
>> in future) and because set_fs_root() in not exported, it looks reasonable to
>> add one more generic UMH helper to generic fs code.
>> Root path reference must be hold by the caller, since it will be put on UMH
>> thread exit.
>
> Awesome.  With this patch as an uprivilieged user I get to pick which
> binary the kernel will execute.  At least if nfs and nfsd ever runs in a
> user namespace (something that looks like only matter of time).
>

Not really. Only by using a kernel module to call the UMH.
And an unprivileged can't load a module as far a I know.
I.e. NFSd, for example, will use unprivileged user's root to perform this call.

> I think this is a seriously bad idea.
>
> Why can't we do this in userspace with setns as we do with the core dump
> helper?
>

Could you, please, clarify, how setns can help here?

> I am missing a lot of context here and capturing the context of a
> process at time time we mount the filesystem and reconstituing it in
> call user mode helper seems like something we could do.
>
> This patch as it stands looks like it would compete for the honor of the
> easiest kernel feature to exploit.
>

Hmmm...
As far as I can see (maybe I'm missing something), there main security issue that could be here
is allowing of using any passed root to swap to.
What about using the current root instead of passed one? I.e. taking the root to swap to inside the UMH.
Does this keeps the isolation on the same level?

> Eric
>


-- 
Best regards,
Stanislav Kinsbursky
