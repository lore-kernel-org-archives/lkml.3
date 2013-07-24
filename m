Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3GXPrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:47:09 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55259 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3GXPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:47:07 -0400
MIME-Version: 1.0
In-Reply-To: <87li4wpi2b.fsf@xmission.com>
References: <877gghruwq.fsf@xmission.com> <CALCETrXXGhVbkG6AnRck+W1kMns5TJuNYAqe_tV44JvWgDoUzA@mail.gmail.com>
 <87li4wpi2b.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Jul 2013 08:46:45 -0700
Message-ID: <CALCETrWCxny906McvR9gjn6cqXvO4Mjp3gGPKDnWbYd4ocBmcw@mail.gmail.com>
Subject: Re: [REVIEW][PATCH] vfs: Lock in place mounts from more privileged users
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:50 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>> On Tue, Jul 23, 2013 at 11:30 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>>
>>> When creating a less privileged mount namespace or propogating mounts
>>> from a more privileged to a less privileged mount namespace lock the
>>> submounts so they may not be unmounted individually in the child mount
>>> namespace revealing what is under them.
>>
>> I would propose a different rule: if vfsmount b is mounted on vfsmount
>> a, then to unmount b, you must be ns_capable(CAP_SYS_MOUNT) on either
>> a's namespace or b's namespace.  The idea is that you should be able
>> to see under a mount if you own the parent (because it's yours) or if
>> you own the child (because you, or someone no more privileged than
>> you, put it there).  This may result in a simpler patch and should do
>> much the same thing.
>
> It definitely won't result in a simpler patch as the information you are
> basing the decision on is not available.
>

Ah, I see -- mnt_ns gets changed when the namespace is duplicated.

Acked-by: Andy Lutomirski <luto@amacapital.net>

--Andy
