Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaDQMEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 08:04:43 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47700 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaDQMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 08:04:40 -0400
Message-ID: <534FC342.8010008@gmail.com>
Date: Thu, 17 Apr 2014 14:04:18 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
CC: mtk.manpages@gmail.com, libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        lkml <linux-kernel@vger.kernel.org>, Jeremy Allison <jra@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Subject: Re: should we change the name/macros of file-private locks?
References: <20140416145746.66b7441c@tlielax.poochiereds.net>	<CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>	<534F0745.70705@samba.org> <20140417075254.28e470ed@tlielax.poochiereds.net>
In-Reply-To: <20140417075254.28e470ed@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 01:52 PM, Jeff Layton wrote:
> On Thu, 17 Apr 2014 00:42:13 +0200
> "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
> 
>> Am 16.04.2014 22:00, schrieb Michael Kerrisk (man-pages):
>>> [CC += Jeremy Allison]
>>>
>>> On Wed, Apr 16, 2014 at 8:57 PM, Jeff Layton <jlayton@redhat.com> wrote:
>>>> Sorry to spam so many lists, but I think this needs widespread
>>>> distribution and consensus.
>>>>
>>>> File-private locks have been merged into Linux for v3.15, and *now*
>>>> people are commenting that the name and macro definitions for the new
>>>> file-private locks suck.
>>>>
>>>> ...and I can't even disagree. They do suck.
>>>>
>>>> We're going to have to live with these for a long time, so it's
>>>> important that we be happy with the names before we're stuck with them.
>>>
>>> So, to add my perspective: The existing byte-range locking system has
>>> persisted (despite egregious faults) for well over two decades. One
>>> supposes that Jeff's new improved version might be around
>>> at least as long. With that in mind, and before setting in stone (and
>>> pushing into POSIX) a model of thinking that thousands of programmers
>>> will live with for a long time, it's worth thinking about names.
>>>
>>>> Michael Kerrisk suggested several names but I think the only one that
>>>> doesn't have other issues is "file-associated locks", which can be
>>>> distinguished against "process-associated" locks (aka classic POSIX
>>>> locks).
>>>
>>> The names I have suggested are:
>>>
>>>     file-associated locks
>>>
>>> or
>>>
>>>    file-handle locks
>>>
>>> or (using POSIX terminology)
>>>
>>>     file-description locks
>>
>> I'd use file-handle, file-description or at least something that's
>> not associated to the "file" itself.
>>
>> file-handle-associated or file-description-associated would also work.
>>
> 
> Yeah, I understand your point.
> 
> I'm not keen on using "file-handle" as file handles have a completely
> different meaning in the context of something like NFS.
> 
> "file-description-associated" is rather a mouthful. You Germans might
> go for that sort of thing, but it feels awkward to us knuckle-draggers
> that primarily speak English.

Even as a knuckle-dragger in the German-speaking world it feels like
a mouthful ;-). But, I think Stefan's preference is anyway for the 
shorter term(s), IIUC.

> Maybe we should just go with one of Michael's earlier suggestions --
> "file-description locks" and change the macros to F_FD_*.

>From my perspective, and the few comments so far, "file-handle lock"
or "file-description lock" seems the way to go. I imagine some will
not be so happy with the latter term (because unfamiliar and
too similar to "file descriptor), but the open(2) man page has for 
quite a long time now (9+ years) has followed POSIX in using the term
"open file description".

> In the docs we could take pains to point out that these are
> file-_description_ locks and not file-_descriptor_ locks, and outline
> why that is so (which is something I'm trying to make crystal clear in
> the docs anyway).
> 
> Does anyone object to that?

Well, I'd be silly to object, but maybe we should still allow a day 
for further comment?

Cheers,

Michael


>>> but that last might be a bit confusing to people who are not
>>> standards-aware. (The POSIX standard defines the thing that a "file
>>> descriptor" refers to as a "file description"; other people often call
>>> that thing a "file handle" or an "open file table entry" or a "struct
>>> file". The POSIX term is precise and unambiguous, but, unfortunately,
>>> the term is not common outside the standard and is also easily
>>> mistaken for "file descriptor".)
>>>
>>>> At the same time, he suggested that we rename the command macros since
>>>> the 'P' suffix would no longer be relevant. He suggested something like
>>>> this:
>>>>
>>>>     F_FA_GETLK
>>>>     F_FA_SETLK
>>>>     F_FA_SETLKW
>>
>> With file-description-associated this could be
>>
>> F_FDA_*
>>
>> metze
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
