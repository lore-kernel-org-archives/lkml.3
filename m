Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3JIBiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:38:50 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:33335 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3JIBis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:38:48 -0400
MIME-Version: 1.0
In-Reply-To: <20131009011833.GE13318@ZenIV.linux.org.uk>
References: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
	<CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
	<20131009011833.GE13318@ZenIV.linux.org.uk>
Date: Tue, 8 Oct 2013 18:38:47 -0700
X-Google-Sender-Auth: AkVJ-x3VZBxcsHWCQJcNtfLwKE0
Message-ID: <CA+55aFyej+u+JmWeGZgVECGFQPY909HkDc83+fuC5M1r1HSeHA@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 6:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Point, but I would argue that we should yell very loud if we get 0 from
> vfs_write() for non-zero size.  I'm not sure if POSIX allows write(2)
> to return that, but a lot of userland code won't be expecting that and
> won't be able to cope...

Actually POSIX very much allows zero returns. O_NDELAY is mentioned as
a possible cause, in addition to zero-sized writes themselves, of
course.

Also, writing to (but not past) the end of a block device returns 0
for "end of device", iirc.

                Linus
