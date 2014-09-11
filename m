Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaIKOr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:47:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48162 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaIKOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:47:24 -0400
Message-ID: <5411B5F5.2090500@gmail.com>
Date: Thu, 11 Sep 2014 07:47:17 -0700
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
References: <53F5310A.5080503@gmail.com> <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com> <540F0810.7030408@gmail.com> <87ppf4n5ib.fsf@x220.int.ebiederm.org> <CALCETrV4WizRXD9JuwibUBbQE9hhNrRDJ3cYyXdhd=OfPziF5g@mail.gmail.com>
In-Reply-To: <CALCETrV4WizRXD9JuwibUBbQE9hhNrRDJ3cYyXdhd=OfPziF5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 09/09/2014 12:26 PM, Andy Lutomirski wrote:
> On Tue, Sep 9, 2014 at 9:05 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> We may also want to discuss the specific restrictions on chroot.
>>
>> The text about chroot at least gives people a strong hint that the
>> chroot rules are affected by user namespaces.
>>
>> The restrictions that we have settled on to avoid chroot being a problem
>> are the creator of a user namespace must not be chrooted in their
>> current mount namespace, and the creator of the user namespace must not
>> be threaded.
>>
>> Andy can you check me on this it looks like unshare is currently buggy
>> in that it will allow a threaded application to create a user namespace.
> 
> I think it's this code in unshare:
> 
>     /*
>      * If unsharing a user namespace must also unshare the thread.
>      */
>     if (unshare_flags & CLONE_NEWUSER)
>         unshare_flags |= CLONE_THREAD | CLONE_FS;
> 
> I suppose that this should be documented.
> 
> CLONE_FS prevents the chroot from leaking out of the namespace.  (But
> see the other thread that I'm about to start...)

So, in the current draft of the setns(2) page, there is

    CLONE_NEWNS
        ...
        Since  Linux 3.9, CLONE_NEWUSER also automatically  implies
        CLONE_FS.

Does that cover your point? Or did you mean that more needs to be said?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
