Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3JTH5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:57:18 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:62784 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3JTH5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
Date: Sun, 20 Oct 2013 09:57:16 +0200
Message-ID: <CAFLxGvwgd95ZOGZ_F1_S9skqbrZ2wVV4Zwrd7Q9m92G_4RTnPA@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: Richard Weinberger <richard.weinberger@gmail.com>
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 9:06 AM, jiaweiwei <jiaweiwei.xiyou@gmail.com> wrote:
> Hi all,
>
> Recently, I just do some stupid stuffs as follows.
>
> # mv /lib/x86_64-linux-gnu/libc.so.6  /tmp
>
> After move "/lib/x86_64-linux-gnu/libc.so.6" away, you could not run lots
> of commands, which show you some errors like this.
>
> # ls
> ls: error while loading shared libraries: libc.so.6: cannot open
> shared object file: No such file or directory
> # mv
> mv: error while loading shared libraries: libc.so.6: cannot open
> shared object file: No such file or directory
> ...
>
> Because they all depend on libc.so.
>
> You could also happen to above boring stuffs when you remove some key
> files in Linux OS. Now, I have a good idea to solve above problems.
>
> We could implement a File System to record all the operations which
> send to VFS. Then when you think you have done a mistake command, you
> could rollback from this File System.
>
> This is just a RFC, I would give detail implementations. Would anyone
> please give me some suggestions? Thanks very much.

What about having a good backup and a statically linked busybox somewhere on
your filesystem?

-- 
Thanks,
//richard
