Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaDQScP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:32:15 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63396 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaDQScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKfBz2siheK7mbghsVc_ynW=4Bc31AyHcvQ=Ux-veQe=A@mail.gmail.com>
References: <1397757904-30665-1-git-send-email-keescook@chromium.org>
 <CALCETrWRts9i1SDbUTD2F5kv68k0PfJEqE6SB9H+2-we++UYuw@mail.gmail.com> <CAGXu5jKfBz2siheK7mbghsVc_ynW=4Bc31AyHcvQ=Ux-veQe=A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Apr 2014 11:31:46 -0700
Message-ID: <CALCETrV3mEJyA0EnFNJocve6=tBj3ojk4xxn1kf8kdejL5M0qA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:18 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Apr 17, 2014 at 11:13 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Apr 17, 2014 at 11:05 AM, Kees Cook <keescook@chromium.org> wrote:
>>> This adds the ability for threads to request seccomp filter
>>> synchronization across their thread group. To support this,
>>> seccomp locking on writes is introduced, along with refactoring
>>> of no_new_privs. Races with thread creation are handled via the
>>> tasklist_list.
>>>
>>> I think all the concerns raised during the discussion[1] of the first
>>> version of this patch have been addressed. However, the races involved
>>> have tricked me before. :)
>>>
>>
>> Would this be easier to use if there were a single syscall to set a
>> seccomp filter and sync threads?  That way you wouldn't have to write
>> your filter such that it gives permission to sync threads.
>
> That would be even cleaner, yes. I was hoping to see the new bpf jump
> tables before expanding into new filter calls, with the hope of doing
> it all at the same time. However, I guess we could just include a
> version number in the new call to indicate which filter type it was,
> and include flags (like "threadgroup sync") in there? I'm trying to
> imagine what would be the least painful for future-proofing.

What's the time frame on the new bpf stuff?  If it'll be ready for
3.16, it might not matter.

--Andy
