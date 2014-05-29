Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaE2Xh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:37:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45085 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaE2Xh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140529231921.GO18016@ZenIV.linux.org.uk>
References: <CA+jWvaKyLPfFb6b-aGCz8RhCCcsSZ+kz5Co3xSKwPOhsguHFMA@mail.gmail.com>
	<20140529231921.GO18016@ZenIV.linux.org.uk>
Date: Fri, 30 May 2014 01:37:55 +0200
Message-ID: <CA+jWvaJech43W4DXNy-YJHq=rngfmKP__mnQ3Rtt+8hF5ru0fQ@mail.gmail.com>
Subject: Re: BUG?: super.c:sget spin_lock not released?
From: Kai <wildex999@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 1:19 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, May 30, 2014 at 12:49:56AM +0200, Kai wrote:
>> Hello,
>>
>> I have recently been playing around with writing a custom filesystem
>> for Linux, and have been reading the source of other filesystems, and
>> the functions they call into the linux kernel.
>> While looking at the function sget in super.c I found something strange.
>>
>> before if(test) it takes a spinlock, however there seems to be two
>> cases where it does not unlock it.
>> (Kernel 3.14, super.c line 441)
>>
>> One:
>> if(!grab_super(old)) goto retry;
>> Will jump to before spin_lock(), without releasing it first.
>
> Er...  So either grab_super() releases that spinlock, or that thing
> is screwed.  The next obvious step would be to look into grab_super()...
>
>> Two:
>> And if it finds an old sb, it will return without releasing the lock.
>
> ... unless something it calls does just that.

AH, I knew I was missing something. And so obvious too =(

Thank you for pointing it out to me.
Seems I need to spend more time reading the source code and figuring
out how it all connects.
