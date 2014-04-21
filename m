Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDUOYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:24:19 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62671 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaDUOYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:24:11 -0400
Message-ID: <535529FA.8070709@gmail.com>
Date: Mon, 21 Apr 2014 16:23:54 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>, Jeff Layton <jlayton@redhat.com>
CC: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx>
In-Reply-To: <20140421140246.GB26358@brightrain.aerifal.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 04:02 PM, Rich Felker wrote:
> On Mon, Apr 21, 2014 at 09:45:35AM -0400, Jeff Layton wrote:
>> File-private locks have been merged into Linux for v3.15, and *now*
>> people are commenting that the name and macro definitions for the new
>> file-private locks suck.
>>
>> ....and I can't even disagree. The names and command macros do suck.
>>
>> We're going to have to live with these for a long time, so it's
>> important that we be happy with the names before we're stuck with them.
>>
>> The consensus on the lists so far is that they should be rechristened as
>> "file-description locks".
>>
>> This patch makes the following changes that I think are necessary before
>> v3.15 ships:
>>
>> 1) rename the command macros to their new names. These end up in the uapi
>>    headers and so are part of the external-facing API. It turns out that
>>    glibc doesn't actually use the fcntl.h uapi header, but it's hard to
>>    be sure that something else won't. Changing it now is safest.
>>
>> 2) make the the /proc/locks output display these as type "FDLOCK"
>>
>> The rest of the renaming can wait until v3.16, since everything else
>> isn't visible outside of the kernel.
> 
> I'm sorry I didn't chime in on this earlier, but I really prefer the
> (somewhat bad) current naming ("private") to the
> ridiculously-confusing use of "FD" to mean "file descriptION" when
> everybody is used to it meaning "file descriptOR". The potential for
> confusion that these are "file descriptOR locks" (they're not) is much
> more of a problem, IMO, than the confusion about what "private" means
> (since it doesn't have an established meaning in this context.
> 
> Thus my vote is for leaving things the way the kernel did it already.

There's at least two problems to solve here:

1) "File private locks" is _meaningless_ as a term. Elsewhere
   (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=1685376),
   I suggested various alternatives. "File-handle locks [*]" was my
   initial preference, and I also suggested "file-description locks"
   and noted the drawbacks of that term. I think it's insufficient
   to say "stick with the existing poor name"--if you have
   something better, then please propose it. (Note by the way
   that for nearly a decade now, the open(2) man page has followed
   POSIX in using the term "open file description. Full disclosure:
   of course, I'm responsible for that change in the man page.)

2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
   that are visually very close to the traditional POSIX lock names 
   (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
   when someone mistypes in code and/or misses such a misttyping
   when reading code. That really must be fixed.

Cheers,

Michael

[*] "File-handle locks" was considered by Jeff to be a little
confusing because of the term elsewhere, such as NFS. I take 
the point, though I'd still prefer it over "File-handle locks".

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
