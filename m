Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3KLCv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:51:59 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:44436 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3KLCvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:51:52 -0500
MIME-Version: 1.0
In-Reply-To: <x498uwuhjrb.fsf@segfault.boston.devel.redhat.com>
References: <CAK2Ky6wEUDS0bQbbYSKv+hX=f6sCjJM7Fu4zOzAR_ftVX1obUg@mail.gmail.com>
	<x498uwuhjrb.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 12 Nov 2013 10:51:52 +0800
Message-ID: <CAK2Ky6ygXiHamJS_u0hGyZYvG0sUrSkWcEQ+VSRYbq9M-tHu-A@mail.gmail.com>
Subject: Re: About read/write requests in IO scheduler
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much!

2013/11/12 Jeff Moyer <jmoyer@redhat.com>:
> º«ÀÚ <bonben1989@gmail.com> writes:
>
>> In IO scheduler level, whether all the read requests are synchronous?
>
> Generically, yes, I/O schedulers (and the whole block layer, in fact)
> consider READs synchronous:
>
> /*
>  * We regard a request as sync, if either a read or a sync write
>  */
> static inline bool rw_is_sync(unsigned int rw_flags)
> {
>         return !(rw_flags & REQ_WRITE) || (rw_flags & REQ_SYNC);
> }
