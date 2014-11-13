Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbaKMPwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:52:13 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54236 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaKMPwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:52:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141112140801.ae8029c7c769d1b606a76f7c@linux-foundation.org>
References: <1415379664-31555-1-git-send-email-drysdale@google.com> <20141112140801.ae8029c7c769d1b606a76f7c@linux-foundation.org>
From: David Drysdale <drysdale@google.com>
Date: Thu, 13 Nov 2014 15:51:47 +0000
Message-ID: <CAHse=S-=43+vAK=jm-ONd4RasDpLfOr1JO-ZUMhh+peuS4FjxQ@mail.gmail.com>
Subject: Re: [PATCHv7 0/3] syscalls,x86: Add execveat() system call
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>,
        Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:08 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  7 Nov 2014 17:01:01 +0000 David Drysdale <drysdale@google.com> wrote:
>
>> This patch set adds execveat(2) for x86
>
> I grabbed these.  If someone else was planning to do so, feel free to
> shout at me.
>
> I haven't been following the discussion closely so some reviewed-by's
> and tested-by's would be nice.

Yes please -- Andy, Eric, Al?

> Thanks for writing a manpage.  mtk.manpages@gmail.com should have been
> cc'ed.  He is now ;)

Thanks (for some reason I though cc'ing linux-api took care of Michael
seeing it).

> Your syscall number was taken by sys_bpf.  I renumbered it
> appropriately.

Looks like the robots have also found a few things that need fixing:
 1) Sparse warning on "close_on_exec(fd, current->files->fdt)": I guess
    that needs a rcu_dereference_raw() or some such around arg2.
 2) Syscall not implemented warning on sparc build: I could attempt to wire
    up the sparc syscall (although I can only cross-compile it, not run it),
    or is it best to leave it and ask sparclinux / David Miller nicely to take
    care of it?  Or have I just missed some bit of syscall machinery?
 3) Non-canonical comment format just before the close_on_exec() call.
(Well, that last wasn't found by a robot -- thanks Andrew!)

When I generate a new version, would it be easier for you if I also merged up
against v3.18-rc4?  That would at least take care of the syscall renumbering.
