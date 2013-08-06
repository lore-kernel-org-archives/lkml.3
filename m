Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3HFKMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:12:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39920 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3HFKMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:12:37 -0400
MIME-Version: 1.0
In-Reply-To: <6501.1375719606@turing-police.cc.vt.edu>
References: <6501.1375719606@turing-police.cc.vt.edu>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 6 Aug 2013 18:12:15 +0800
Message-ID: <CA+a=Yy53ghZQQEYAYH9+vp8QDVZecZB_eAL7JqAF=G2au-ZdtQ@mail.gmail.com>
Subject: Re: next-20130805 - compile errors in drivers/staging/lustre/lustre/llite/file.c
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Kent Overstreet <koverstreet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 12:20 AM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> Not sure how this train wreck happened - 'git log' shows the last patch to
> touch include/linux/aio.h was some stuff of Kent's back in May, and 'git blame'
> says the 2 lines of code that died were added on 2013-05-02.
>
> It compiled when I build next-0730.
>
> And yet, this morning, I get this building -0805:
>
>   CC [M]  drivers/staging/lustre/lustre/llite/file.o
> drivers/staging/lustre/lustre/llite/file.c: In function 'll_file_read':
> drivers/staging/lustre/lustre/llite/file.c:1012:7: error: 'struct kiocb' has no member named 'ki_left'
>   kiocb->ki_left = count;
>        ^
> drivers/staging/lustre/lustre/llite/file.c: In function 'll_file_write':
> drivers/staging/lustre/lustre/llite/file.c:1071:7: error: 'struct kiocb' has no member named 'ki_left'
>   kiocb->ki_left = count;
>        ^
Lustre doesn't on depend ki_left. We can just remove it but it seems
we have missed kiocb->ki_nbytes here.

I'll fix this but please confirm whom the patch should go to? Benjamin LaHaise?

Thanks,
Tao

> make[5]: *** [drivers/staging/lustre/lustre/llite/file.o] Error 1
>
> Any ideas?  Only thing I can think of is that Kent's stuff went into some
> tree in May, but only surfaced in linux-next in the last little bit...
>
