Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3HWPsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:48:19 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61044 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3HWPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <1374774659-13121-12-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<1374774659-13121-12-git-send-email-dave.kleikamp@oracle.com>
Date: Fri, 23 Aug 2013 17:48:17 +0200
X-Google-Sender-Auth: 0GDpqtomb6MI5Wr9RRyK4Qlnqxc
Message-ID: <CAMuHMdXthZ5RUctCWuKXVM+iqoWkthSgLeFXthFqT-ijsNAHdw@mail.gmail.com>
Subject: Re: [PATCH V8 11/33] dio: Convert direct_IO to use iov_iter
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, driverdevel <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 7:50 PM, Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> Change the direct_IO aop to take an iov_iter argument rather than an iovec.
> This will get passed down through most filesystems so that only the
> __blockdev_direct_IO helper need be aware of whether user or kernel memory
> is being passed to the function.

Lustre in -next also needs to be updated:

drivers/staging/lustre/lustre/llite/rw26.c:549: warning:
initialization from incompatible pointer type

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
