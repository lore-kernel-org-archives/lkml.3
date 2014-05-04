Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaEDHEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 03:04:23 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35846 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaEDHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 03:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140303210359.26624.qmail@science.horizon.com>
References: <20140303210359.26624.qmail@science.horizon.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 4 May 2014 09:04:00 +0200
X-Google-Sender-Auth: QEpfp_ikgtNGObULtpGF9JLCfdU
Message-ID: <CAHO5Pa2tJ2XRj7R69o=0i2yV+0mmxg9uOyDQ_HFFudZ0xGmPsQ@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
To: George Spelvin <linux@horizon.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ouch! I've just seen that trimming the CC on this reply took me out of
a large part of the subsequent conversation. PLEASE don't trim CCs,
and especially not the address of the OP!!

On Mon, Mar 3, 2014 at 10:03 PM, George Spelvin <linux@horizon.com> wrote:
>>  struct fd {
>>       struct file *file;
>> -     int need_put;
>> +     unsigned need_put:1, need_pos_unlock:1;
>>  };
>
> Since we're rounding up to 2*sizeof(struct file *) anyway, is this a case
> where wasting space on a couple of char (or bool) flags would generate
> better code than a bitfield?
>
> In particular, the code to set need_pos_unlock (which will be executed
> each read/write for most files) is messy in the bitfield case.
> A byte store is much cleaner.
>
> (If you want to use bits, why not use the two lsbits of the file pointer
> for the purpose?  That would save a lot of space.)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
