Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaF0MUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:20:46 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36193 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaF0MUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:20:45 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140627115057.GC13337@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-9-git-send-email-vgoyal@redhat.com> <20140626204303.GE11136@redhat.com>
 <CALCETrU8mixFxpS2Bt2Q7S08zUFxZwE1zfqHw8PEetqewgR7RQ@mail.gmail.com> <20140627115057.GC13337@redhat.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 27 Jun 2014 14:20:24 +0200
Message-ID: <CAKgNAkioWzEgTXUP-r9u+WvkhqfX4=76gtsKs0AE5SHyT2TL=Q@mail.gmail.com>
Subject: Re: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>,
        dyoung@redhat.com, WANG Chao <chaowang@redhat.com>, bhe@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 1:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jun 26, 2014 at 02:03:17PM -0700, Andy Lutomirski wrote:
>> On Thu, Jun 26, 2014 at 1:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Jun 26, 2014 at 04:33:37PM -0400, Vivek Goyal wrote:
>> >> This is the new syscall kexec_file_load() declaration/interface. I have
>> >> reserved the syscall number only for x86_64 so far. Other architectures
>> >> (including i386) can reserve syscall number when they enable the support
>> >> for this new syscall.
>> >>
>> >> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> >> CC: linux-api@vger.kernel.org
>> >
>> > +.BR KEXEC_FILE_NO_INITRAMFS
>> > +Loading initrd/initramfs is optional. Specify this flag if no initramfs
>> > +is being loaded. If this flag is set, kernel will ignore the value passed
>> > +in
>>
>> This seems pointless.  Why not just pass -1 for initrd_fd to indicate
>> that no initrd is needed?
>
> I was not sure whether negative fd should be treated as error and system
> call should fail or it should be treated as user does not want to load
> initrd and system call succeeds.
>
> I was concerned about the cases where application does an fd = open(),
> operation fails and fd contains -1. Caller does not check fd and
> passed it to kexec system call.
>
> I thought that in such cases we should error out saying initrd fd is
> not valid. Instead of continuing and loading kernel without initrd. A
> user might be surprised.
>
> This is little defensive programming. But I am open to change it if
> the perception is that above is not a valid concern.

Your logic for using a flag rather than -1 sounds reasonable to me.
The nearest precedent I can think of offhand is mmap(), which also
takes a file descriptor argument for some use cases. However, if
MAP_ANONYMOUS is specified, no file descriptor ir required. The
treatment of the 'fd' argument in that case depends on the system. On
Linux, the fd argument is just ignored. However, many other systems
require 'fd' to be negative when MAP_ANONYMOUS is specified; one
presumes as a kind of safety check.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
