Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaAZTXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 14:23:32 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58013 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 14:23:31 -0500
MIME-Version: 1.0
In-Reply-To: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
Date: Sun, 26 Jan 2014 11:23:30 -0800
X-Google-Sender-Auth: lpOv9Hymlgq4PcOqA0s_1RTJGNI
Message-ID: <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 4:27 AM, David Howells <dhowells@redhat.com> wrote:
>
> -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);

So the S_IFREG isn't necessary.

And quite frankly, I personally think S_IRUGO | S_IWUSR is _less_
readable than 0644. It's damn hard to parse those random letter
combinations, and at least I have to really think about it, in a way
that the octal representation does *not* make me go "I have to think
about that".

So my personal preference would be to just see that simple 0644 in
proc_create. Hmm?

                Linus
