Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaDQPXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:23:15 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:35235 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaDQPXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:23:09 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4xBpp8v2ShxczFATOAgEPFYQrBsc+haPGMYXeo2
X-RZG-CLASS-ID: mo05
Message-ID: <534FF071.2080903@samba.org>
Date: Thu, 17 Apr 2014 17:17:05 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: mtk.manpages@gmail.com, libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        "Carlos O'Donell" <carlos@redhat.com>, samba-technical@lists.samba.org,
        lkml <linux-kernel@vger.kernel.org>, Jeremy Allison <jra@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>
Subject: Re: should we change the name/macros of file-private locks?
References: <20140416145746.66b7441c@tlielax.poochiereds.net>	<CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>	<534F0745.70705@samba.org> <20140417075254.28e470ed@tlielax.poochiereds.net>
In-Reply-To: <20140417075254.28e470ed@tlielax.poochiereds.net>
X-Enigmail-Version: 1.5.2
OpenPGP: id=0E53083F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.04.2014 13:52, schrieb Jeff Layton:
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
> 
> Maybe we should just go with one of Michael's earlier suggestions --
> "file-description locks" and change the macros to F_FD_*.
> 
> In the docs we could take pains to point out that these are
> file-_description_ locks and not file-_descriptor_ locks, and outline
> why that is so (which is something I'm trying to make crystal clear in
> the docs anyway).
> 
> Does anyone object to that?

Sounds good.

metze
