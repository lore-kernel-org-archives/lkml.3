Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3BKJaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:30:00 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40656 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3BKJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:29:57 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without dequeuing signals (v2)
Date: Mon, 11 Feb 2013 10:29:50 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Andrey Wagin <avagin@gmail.com>,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
In-Reply-To: <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201302111029.50998.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2013 21:15, Michael Kerrisk (man-pages) wrote:
> >> >Damn. But after I wrote this email I realized that llseek() probably can't
> >> > work. Because peek_offset/f_pos/whatever has to be shared with all processes
> >> > which have this file opened.
> >
> > Yes. but I thought you decided to ignore this oddity ;)
> >
> >> So I want to suggest a way how to forbid read() for SIGNALFD_PEEK.
> >> file->f_pos can be initialized to -1. read() returns EINVAL in this
> >> case. In a man page we will write that signals can be dumped only with
> >> help pread(). Is it overload or too ugly?
> >
> > Well. I do not know. Up to you and Michael.
> >
> > But honestly, I can't say this all looks really nice. And why do we
> > need SIGNALFD_PEEK then?
> 
> It surely is no beauty. The hope is at least to make it less ugly than it was.
> 
> > Seriously, perhaps we should simply add signalfd_fops->ioctl() for PEEK.
> > Or add PTRACE_{PEEK,POKE}_SIGNAL which looks even logical and useful...
> > And much simpler/straightforward.
> >
> > But I am not going to argue.

ptrace interface might find some use in debuggers.
Not that any of them expressed such desires so far,
but just maybe.

However, it needs coding in C to read it,
which brings me to:


> I suppose I had wondered along similar lines, but in a slightly
> different direction: would the use of a /proc interface to get the
> queued signals make some sense?

I think that /proc interface beats adding magic flags and magic semantic
to [p]read.

It also has the benefit of being human-readable. You don't need
to write a special C program to "cat /proc/$$/foo".

Andrey, I know that it is hard to let go of the code you invested time
and efforts in creating. But this isn't the last patch, is it?
You will need to retrieve yet more data for process checkpointing.
When you start working on the next patch for it, consider trying
/proc approach.

-- 
vda
