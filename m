Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaF0Lvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaF0Lvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:51:42 -0400
Date: Fri, 27 Jun 2014 07:50:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Borislav Petkov <bp@alien8.de>,
        dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
Message-ID: <20140627115057.GC13337@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-9-git-send-email-vgoyal@redhat.com>
 <20140626204303.GE11136@redhat.com>
 <CALCETrU8mixFxpS2Bt2Q7S08zUFxZwE1zfqHw8PEetqewgR7RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU8mixFxpS2Bt2Q7S08zUFxZwE1zfqHw8PEetqewgR7RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 02:03:17PM -0700, Andy Lutomirski wrote:
> On Thu, Jun 26, 2014 at 1:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Jun 26, 2014 at 04:33:37PM -0400, Vivek Goyal wrote:
> >> This is the new syscall kexec_file_load() declaration/interface. I have
> >> reserved the syscall number only for x86_64 so far. Other architectures
> >> (including i386) can reserve syscall number when they enable the support
> >> for this new syscall.
> >>
> >> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >> CC: linux-api@vger.kernel.org
> >
> > +.BR KEXEC_FILE_NO_INITRAMFS
> > +Loading initrd/initramfs is optional. Specify this flag if no initramfs
> > +is being loaded. If this flag is set, kernel will ignore the value passed
> > +in
> 
> This seems pointless.  Why not just pass -1 for initrd_fd to indicate
> that no initrd is needed?

I was not sure whether negative fd should be treated as error and system
call should fail or it should be treated as user does not want to load
initrd and system call succeeds.

I was concerned about the cases where application does an fd = open(),
operation fails and fd contains -1. Caller does not check fd and
passed it to kexec system call.

I thought that in such cases we should error out saying initrd fd is
not valid. Instead of continuing and loading kernel without initrd. A
user might be surprised.

This is little defensive programming. But I am open to change it if
the perception is that above is not a valid concern.

Thanks
Vivek
