Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab3ICRk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:40:59 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:58599 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3ICRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <87eh99noa0.fsf@xmission.com>
References: <878uzmhkqg.fsf@xmission.com> <CALCETrWPDzuoaJp2ko5jAbwYUBqSdPjvO5uGo-gZVsS4Wm1PKQ@mail.gmail.com>
 <87a9k2g5la.fsf@xmission.com> <87eh99noa0.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Sep 2013 10:40:36 -0700
Message-ID: <CALCETrXRD3J-jrKXMSz=pC+m0xcL02ovf1xydKDOPmyCYNEM7Q@mail.gmail.com>
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and
 sysfs can be mounted
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 9:45 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Tue, Aug 27, 2013 at 2:44 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>>
>>>> Rely on the fact that another flavor of the filesystem is already
>>>> mounted and do not rely on state in the user namespace.
>>>
>>> Possibly dumb question: does this check whether the pre-existing mount
>>> has hidepid set?
>>
>> Not currently.
>>
>> It may be worth doing something with respect to hidepid.  I forget what
>> hidepid tries to do, and I need to dash.  But feel free to cook up a
>> follow on patch.
>
> So I have thought about this a bit more.
>
> hidepid hides the processes that ptrace_may_access will fail on.
>
> You can only reach the point where an unprivileged mount of a pid
> namespace is possible if you have created both a user namespace and a
> pid namespace.  Which means the creator of the pid namespace will be
> capable of ptracing all of the other processes in the pid namespace
> (ignoring setns).
>
> So I don't see a point of worry about hidepid or the hidepid gid on
> child pid namespaces.  The cases it is attempting to protecting against
> really don't exist.

Fair enough.  I didn't realize that you had to own the pid namespace.

--Andy
