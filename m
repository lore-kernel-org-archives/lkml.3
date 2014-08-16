Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaHPPmC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 11:42:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44937 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaHPPl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 11:41:59 -0400
Date: Sat, 16 Aug 2014 17:41:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Drysdale <drysdale@google.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC PATCH 00/11] Adding FreeBSD's Capsicum security framework
 (part 1)
Message-ID: <20140816154154.GA12400@Nokia-N900>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <53B51E81.4090700@redhat.com>
 <20140703183927.GA1629@google.com>
 <53B651C5.80602@redhat.com>
 <CAHse=S83APPfnEwO1fQbV_tNd=9zsAsZr42KbYM_He-c3C3P6A@mail.gmail.com>
 <53BA9094.9080401@redhat.com>
 <CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+c2E6eG_juEDh-GyheveqScxQ=98jqO1ZOjp1PgfVBGQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> I think that's more easily done by opening the file as O_RDONLY/O_WRONLY
> >>> /O_RDWR.   You could do it by running the file descriptor's seccomp-bpf
> >>> program once per iocb with synthesized syscall numbers and argument
> >>> vectors.
> >>
> >>
> >> Right, but generating the equivalent seccomp input environment for an
> >> equivalent single-fd syscall is going to be subtle and complex (which
> >> are worrying words to mention in a security context).  And how many
> >> other syscalls are going to need similar special-case processing?
> >> (poll? select? send[m]msg? ...)
> >
> >
> > Yeah, the difficult part is getting the right balance between:
> >
> > 1) limitations due to seccomp's impossibility to chase pointers (which is
> > not something that can be lifted, as it's required for correctness)
> 
> btw once seccomp moves to eBPF it will be able to 'chase pointers',
> since pointer walking will be possible via bpf_load_pointer() function call,
> which is a wrapper of:

Even if you could make capscium work with eBPF... please don't.

Capscium is kind of obvious, elegant solution. BPF is quite
complex. And security semantics should not be pushed to userspace...

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
