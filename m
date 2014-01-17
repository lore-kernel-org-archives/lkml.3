Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaAQOkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:40:39 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48317 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaAQOkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:40:37 -0500
Date: Fri, 17 Jan 2014 15:41:26 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
 <20140113122517.GA10366@quack.suse.cz>
 <20140115182347.GB5715@fieldses.org>
 <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
 <20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
 <52D90B93.5010209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D90B93.5010209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Thanks for the review.  I updated the code and man page based on your and
Bruce's comments.

The code changes are pushed to the git tree and the updated man page is below.

Thanks,
Miklos
----


RENAMEAT(2)                Linux Programmer's Manual               RENAMEAT(2)



NAME
       renameat, renameat2 - rename a file relative to directory file descrip-
       tors

SYNOPSIS
       #include <fcntl.h> /* Definition of AT_* constants */
       #include <stdio.h>

       int renameat(int olddirfd, const char *oldpath,
                    int newdirfd, const char *newpath);

       int renameat2(int olddirfd, const char *oldpath,
                     int newdirfd, const char *newpath, unsigned int flags);

   Feature Test Macro Requirements for glibc (see feature_test_macros(7)):

       renameat():
           Since glibc 2.10:
               _XOPEN_SOURCE >= 700 || _POSIX_C_SOURCE >= 200809L
           Before glibc 2.10:
               _ATFILE_SOURCE

DESCRIPTION
       The renameat() and renameat2() system calls operate in exactly the same
       way  as  rename(2), except for the differences described in this manual
       page.

       If the pathname given in oldpath is relative, then  it  is  interpreted
       relative  to  the directory referred to by the file descriptor olddirfd
       (rather than relative to the current working directory of  the  calling
       process, as is done by rename(2) for a relative pathname).

       If oldpath is relative and olddirfd is the special value AT_FDCWD, then
       oldpath is interpreted relative to the current working directory of the
       calling process (like rename(2)).

       If oldpath is absolute, then olddirfd is ignored.

       The interpretation of newpath is as for oldpath, except that a relative
       pathname is interpreted relative to the directory referred  to  by  the
       file descriptor newdirfd.

       renameat2()  has an additional flags argument.  renameat2() call with a
       zero flags argument is equivalent to renameat().

       The flags argument is a bitfield consisting of zero or more of the fol-
       lowing constants defined in <linux/fs.h>:

       RENAME_NOREPLACE
              Don't  overwrite  the  target of the rename.  Fail if the target
              would be overwritten.

       RENAME_EXCHANGE
              Atomically exchange the source and destination.  Both must exist
              but  may  be of a different type (e.g. one a non-empty directory
              and the other a symbolic link).  Specifying this  flag  together
              with RENAME_NOREPLACE is invalid.

RETURN VALUE
       On  success,  renameat()  and  renameat2()  return  0.  On error, -1 is
       returned and errno is set to indicate the error.

ERRORS
       The same errors that occur for rename(2) can also occur for  renameat()
       and  renameat2().   The  following  additional  errors  can  occur  for
       renameat() and renameat2():

       EBADF  olddirfd or newdirfd is not a valid file descriptor.

       ENOTDIR
              oldpath is relative and olddirfd is a file descriptor  referring
              to  a  file  other  than a directory; or similar for newpath and
              newdirfd

       The following additional errors are defined for renameat2():

       EINVAL The filesystem does not support a flag in flags

       EINVAL Invalid combination of flags

       EEXIST flags contain RENAME_NOREPLACE and  the  target  of  the  rename
              exists

       ENOENT flags  contain  RENAME_EXCHANGE and either of the two files does
              not exist

VERSIONS
       renameat() was added to Linux in kernel  2.6.16;  library  support  was
       added to glibc in version 2.4.

CONFORMING TO
       renameat() is specified in POSIX.1-2008.

NOTES
       See openat(2) for an explanation of the need for renameat().

SEE ALSO
       openat(2), rename(2), path_resolution(7)



Linux                             2012-05-04                       RENAMEAT(2)
