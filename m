Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3JYOds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:33:48 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:63153 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3JYOdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <20131025142547.GE13318@ZenIV.linux.org.uk>
References: <20131025142547.GE13318@ZenIV.linux.org.uk>
Date: Fri, 25 Oct 2013 15:33:46 +0100
X-Google-Sender-Auth: PJmF9J87XIFw5NU_w2acxceiZCk
Message-ID: <CA+55aFx2XQvf1pbhoRP7EJL=We04d3E0i0-DY3gCfcqv7T76Hg@mail.gmail.com>
Subject: Re: [git pull] a couple of fixes for rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 3:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> nfsd performance regression fix + seq_file lseek(2) fix.
> Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Not acceptable.

fs/file_table.c: In function ‘fput’:
fs/file_table.c:320:4: warning: passing argument 1 of
‘schedule_delayed_work’ from incompatible pointer type [enabled by
default]
    schedule_delayed_work(&delayed_fput_work, 1);
    ^
In file included from include/linux/srcu.h:34:0,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:797,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from fs/file_table.c:9:
include/linux/workqueue.h:594:60: note: expected ‘struct delayed_work
*’ but argument is of type ‘struct work_struct *’
 static inline bool schedule_delayed_work(struct delayed_work *dwork,

Plase stop sending me untested crap that doesn't even compile cleanly!

                Linus
