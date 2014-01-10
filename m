Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaAJBCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:02:03 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:33463 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbaAJBB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140109195527.2a86c7b7@tlielax.poochiereds.net>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-15-git-send-email-jlayton@redhat.com> <52CF0690.5030006@amacapital.net>
 <20140109195527.2a86c7b7@tlielax.poochiereds.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 9 Jan 2014 17:01:38 -0800
Message-ID: <CALCETrWjYoHLvuocWy9SRR=Kowu9YJjf4_dk4xzagZEYFhfXzA@mail.gmail.com>
Subject: Re: [PATCH v5 14/14] locks: add new fcntl cmd values for handling
 file private locks
To: Jeff Layton <jlayton@redhat.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 4:55 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 09 Jan 2014 12:29:04 -0800
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On 01/09/2014 06:19 AM, Jeff Layton wrote:
>> > Due to some unfortunate history, POSIX locks have very strange and
>> > unhelpful semantics. The thing that usually catches people by surprise
>> > is that they are dropped whenever the process closes any file descriptor
>> > associated with the inode.
>> >
>>
>> [...]
>>
>> > +#define F_GETLKP   36
>> > +#define F_SETLKP   37
>> > +#define F_SETLKPW  38
>> > +
>> > +#ifndef CONFIG_64BIT
>> > +#ifndef F_GETLK64
>> > +#define F_GETLKP64 39
>> > +#define F_SETLKP64 40
>> > +#define F_SETLKPW64        41
>> > +#endif
>> > +#endif
>> > +
>>
>> Since there are no existing callers of these fcntls, can you get rid of
>> the non-64-bit variants?  The implementation might be a bit more of
>> departure from current code, but it should make everything a lot cleaner
>> and make it easier (aka automatic) for new architectures to support this
>> feature.
>>
>
> That sounds reasonable, but I'll admit I had some trouble slogging
> through the morass of fcntl/fcntl64 syscall handling code. I mostly did
> the cargo-cult thing on this patch to get something that worked.
>
> So, to make sure I understand...
>
> You're basically suggesting that we just require that 32-bit userland
> always use fcntl64() to access these new cmd values?

Exactly.

It's general Linux policy these days to avoid introducing new
interfaces that need compat support.  (The OABI thing is probably
unavoidable here, but at least the compat mess could be restricted to
ARM.)

You may be able to do pretty well by undoing the compat changes and
leaving everything else alone.  I suspect that everything will just
work.

>
> I'll try to do that, but I'll probably need someone to carefully review
> what I come up with (hint, hint).

I'll try.  I'm not an expert on this particular morass :)

--Andy
