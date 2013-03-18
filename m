Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3CRL1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:27:20 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:37509 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CRL1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:27:18 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130314225940.GQ21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
	<20130312222350.GK21522@ZenIV.linux.org.uk>
	<20130313185249.GL21522@ZenIV.linux.org.uk>
	<CAJfpeguViuL52fYw922KU1YxRs2YyD=T6tdFVg+buJPw7YUV_Q@mail.gmail.com>
	<20130313231918.GP21522@ZenIV.linux.org.uk>
	<CAJfpegsCirmYYimr6Nn4Q4Kdc7rMYaxWhk+fsmp+BLp6mjb_MQ@mail.gmail.com>
	<20130314225940.GQ21522@ZenIV.linux.org.uk>
Date: Mon, 18 Mar 2013 12:27:15 +0100
Message-ID: <CAJfpeguhZLQWz4bvyJoaB2BLkzu2Op68_woUaBts2tCqECndcQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Huh?
>         * from st_mode point of view, it's not going to conflict with
> anything; FFS "entry type" matches bits 12..15 of mode_t, and the value
> picked by whoever had first implemented whiteouts had been chosen so
> that it would not clash with any existing values.  We have
> #define S_IFMT  00170000
> #define S_IFSOCK 0140000
> #define S_IFLNK  0120000
> #define S_IFREG  0100000
> #define S_IFBLK  0060000
> #define S_IFDIR  0040000
> #define S_IFCHR  0020000
> #define S_IFIFO  0010000
> and this sucker would've been 0160000; new filesystem object types are not
> frequently introduced, to put it mildly, so I wouldn't expect clashes.

I'm worried exactly because new filetypes are introduced so
infrequently.  No such thing happened during the lifetime of Linux,
AFAICT.  Backup/restore tools are not going to handle it.  File
managers are not going to show anything sane (and quite possibly some
will simply crash).

Yes, all that can be fixed, but it will be a slow and painful process,
since union/overlay type filesystems are themselves quite specialized
and problems are not going to be shaken out quickly with userspace
interaction.  On the other hand if a whiteout is exported to userspace
as a symlink with xattrs, there will be much less of those problems.

BTW I'm not against adding whiteout support to the VFS and possibly to
filesystems to clean up the security uglilness and optimize storage.

But I think the most important aspect is the userspace interface and
I'm far from sure that a new filetype is the best solution here.

Thanks,
Miklos
