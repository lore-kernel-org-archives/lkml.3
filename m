Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaG2I20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:28:26 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58155 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaG2I2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <1406309851-10628-1-git-send-email-adas@redhat.com>
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 29 Jul 2014 10:19:58 +0200
X-Google-Sender-Auth: Ym-XQ_sDf8o29hdTfY_Lkv-y7CM
Message-ID: <CAHO5Pa3FO+oRQY3U+7xdQ3ahS=d8YZMO2eDLJdQ81+1GsnoOmA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
To: Abhi Das <adas@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 7:37 PM, Abhi Das <adas@redhat.com> wrote:
> This system call takes 3 arguments:
> fd      - file descriptor of the directory being readahead
> *offset - offset in dir from which to resume. This is updated
>           as we move along in the directory
> count   - The max number of entries to readahead
>
> The syscall is supposed to read upto 'count' entries starting at
> '*offset' and cache the inodes corresponding to those entries. It
> returns a negative error code or a positive number indicating
> the number of inodes it has issued readaheads for. It also
> updates the '*offset' value so that repeated calls to dirreadahead
> can resume at the right location. Returns 0 when there are no more
> entries left.

Hello Abhi,

As per Documentation/SubmitChecklist, please CC linux-api on patches
that change the kerne-user-space API/ABI. (See
https://www.kernel.org/doc/man-pages/linux-api-ml.html for more
details.)

Cheers,

Michael


> Abhi Das (2):
>   fs: Add dirreadahead syscall and VFS hooks
>   gfs2: GFS2's implementation of the dir_readahead file operation
>
>  arch/x86/syscalls/syscall_32.tbl |   1 +
>  arch/x86/syscalls/syscall_64.tbl |   1 +
>  fs/gfs2/Makefile                 |   3 +-
>  fs/gfs2/dir.c                    |  49 ++++++---
>  fs/gfs2/dir.h                    |  15 +++
>  fs/gfs2/dir_readahead.c          | 209 +++++++++++++++++++++++++++++++++++++++
>  fs/gfs2/file.c                   |   2 +
>  fs/gfs2/main.c                   |  10 +-
>  fs/gfs2/super.c                  |   1 +
>  fs/readdir.c                     |  49 +++++++++
>  include/linux/fs.h               |   3 +
>  11 files changed, 328 insertions(+), 15 deletions(-)
>  create mode 100644 fs/gfs2/dir_readahead.c
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
