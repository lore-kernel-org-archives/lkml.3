Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaCSEcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:32:45 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45452 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaCSEco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140319023135.GB25178@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
	<20140317214145.GA29105@kroah.com>
	<CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
	<20140318003725.GA12217@kroah.com>
	<CAHb8M2D9Hf6pRza8-xgoSQrWx0x8CBv-qrThLWF3Hb6nZQQn7Q@mail.gmail.com>
	<CAHb8M2C0pBFuzA_Q+-zBkHT2ZckDKEkAvD0oiM900_ZhxxH2PQ@mail.gmail.com>
	<20140319005832.GB18725@kroah.com>
	<CAHb8M2D1vGZ1xk=Xs6y2hTPAy_9efXV1LVvi7t2MscBW+_CyEg@mail.gmail.com>
	<20140319023135.GB25178@kroah.com>
Date: Wed, 19 Mar 2014 13:32:44 +0900
Message-ID: <CAHb8M2DC51QMxmn-2ZwrjuMSCBzGKidvXpRZSd-8YUccuJhNag@mail.gmail.com>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reply.
I will do that.

Regards,
Daeseok Youn.

2014-03-19 11:31 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Mar 19, 2014 at 10:04:40AM +0900, DaeSeok Youn wrote:
>> oh...
>> You didn't get my reply about vmalloc usage.
>>
>> My replay attach again, below.
>>
>> > 2014-03-18 9:37 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>> >> On Tue, Mar 18, 2014 at 09:26:07AM +0900, DaeSeok Youn wrote:
>> >>> I think vmalloc/kmalloc in uislib_malloc() can be removed and just use
>> >>> vmalloc/kmalloc directly.
>> >>
>> >> Yes.  Actually, just use kmalloc, I don't knwo why vmalloc is being
>> >> used, but cc: the driver maintainers just to be sure.
>> >
>> Here, need to check by you.
>> > It try to allocate 128KiB(131072byte) with vmalloc(). I think if it
>> > trying to allocate with kmalloc()
>> > it has a possibility to fail because of memory fragmentation even if
>> > system has enough memory to use.
>> > Just my opinion. If I'm wrong, let me know.
>
> Check to see just how big you are allocating, you should know based on
> the flags which code path happened uislib_malloc().
>
> Just keep the logic the same and you should be fine.
>
> greg k-h
