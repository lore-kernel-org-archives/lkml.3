Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaCRILp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:11:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33281 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbaCRILl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:11:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140318003725.GA12217@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
	<20140317214145.GA29105@kroah.com>
	<CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
	<20140318003725.GA12217@kroah.com>
Date: Tue, 18 Mar 2014 17:11:40 +0900
Message-ID: <CAHb8M2D9Hf6pRza8-xgoSQrWx0x8CBv-qrThLWF3Hb6nZQQn7Q@mail.gmail.com>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-18 9:37 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Mar 18, 2014 at 09:26:07AM +0900, DaeSeok Youn wrote:
>> I think vmalloc/kmalloc in uislib_malloc() can be removed and just use
>> vmalloc/kmalloc directly.
>
> Yes.  Actually, just use kmalloc, I don't knwo why vmalloc is being
> used, but cc: the driver maintainers just to be sure.

It try to allocate 128KiB(131072byte) with vmalloc(). I think if it
trying to allocate with kmalloc()
it has a possibility to fail because of memory fragmentation even if
system has enough memory to use.
Just my opinion. If I'm wrong, let me know.

>
>> (UISMALLOC() macro is also removed.)
>
> Yes.
>
>> And uislib_malloc() is renamed to "uislib_trace_buffer_status()" which
>> is just tracing buffer status(Malloc_FailuresAlloc, Malloc_BytesInUse
>> ...) for info_proc_read_helper().
>
> The whole tracing stuff needs to be ripped out, so no problem deleting
> it here as well.

OK. I will remove that information in info_proc_read_helper().

>
>> If this change is accepted, it also need to change uislib_free().
>
> Drop it and just use kfree().
OK. replace kfree() with uislib_free().

>
> thanks,
>
> greg k-h
