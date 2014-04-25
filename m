Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaDYVYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:24:04 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:59364 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaDYVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <87oazpyupx.fsf@x220.int.ebiederm.org>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
 <87ha5h42va.fsf@x220.int.ebiederm.org> <CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
 <87tx9h2m2w.fsf@x220.int.ebiederm.org> <CALCETrU_SE=7QH-rDOqOsB5T4v+VEGL_3ZYRPgt6QWHB5BEGdg@mail.gmail.com>
 <87oazpyupx.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 25 Apr 2014 14:23:40 -0700
Message-ID: <CALCETrX9aCxsGs9T6v4kQpG_4sOzse5E2V0RnQeYdmoi22dj8g@mail.gmail.com>
Subject: Re: pid ns feature request
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 2:17 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Fri, Apr 25, 2014 at 1:25 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>
>>>> On Fri, Apr 25, 2014 at 12:37 PM, Eric W. Biederman
>>>> <ebiederm@xmission.com> wrote:
>>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>>
>>>>>> Unless I'm missing some trick, it's currently rather painful to mount
>>>>>> a namespace /proc.  You have to actually be in the pid namespace to
>>>>>> mount the correct /proc instance, and you can't unmount the old /proc
>>>>>> until you've mounted the new /proc.  This means that you have to fork
>>>>>> into the new pid namespace before you can finish setting it up.
>>>>>
>>>>> Yes.  You have to be inside just about all namespaces before you can
>>>>> finish setting them up.
>>>>>
>>>>> I don't know the context in which needed to be inside the pid namespace
>>>>> is a burden.
>>>>
>>>> I'm trying to sandbox myself.  I unshare everything, setup up new
>>>> mounts, pivot_root, umount the old stuff, fork, and wait around for
>>>> the child to finish.
>>>>
>>>> This doesn't work: the parent can't mount the new /proc, and the child
>>>> can't either because it's too late.
>>>>
>>>> The only solution I can think of without kernel changes is to fork the
>>>> child (pid 1) before pivot_root, which makes everything more
>>>> complicated.  I suppose I can unshare, fork immediately, have the
>>>> child set up all the mounts, and then wake the parent, but this is an
>>>> annoying bit of extra complexity for no obvious gain.
>>>
>>> Or perhaps just use clone and clone flags.
>>>
>>> What are you doing with the parent process?  What value does it serve?
>>
>> I'm not entirely sure.  I'm hacking on this thing:
>>
>> https://github.com/amluto/sandstorm/tree/userns
>>
>> which isn't really my code.  But there's an inner sandbox and an outer
>> sandbox, and only the inner sandbox is in a pid namespace.
>>
>> I suppose what what I'm doing is a bit strange.
>
> A bit.   But doing strange things is good.
>
> Right now most of my energy is focused on closely the last of the design
> issues.  So I don't have much energy for new namespace related features
> right now.

No problem.  I may write up the patch, although I'll have to support
current kernels anyway.

--Andy
