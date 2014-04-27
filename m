Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaD0KZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:25:00 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57250 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaD0KY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:24:59 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.103.39]
In-Reply-To: <alpine.DEB.2.02.1404271135590.2006@localhost6.localdomain6>
References: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
	<20140427051428.GA2671@katana>
	<CABxcv==8F2CghQKVDp==5Mx8-OBJnc+yZWEBqi7OFGij8OHaeg@mail.gmail.com>
	<alpine.DEB.2.02.1404271135590.2006@localhost6.localdomain6>
Date: Sun, 27 Apr 2014 12:24:57 +0200
Message-ID: <CABxcv=nzGJczrYZbGarK8-tM6WXc5JQrTRsX=_88a1npkcBXQw@mail.gmail.com>
Subject: Re: [Cocci] [PATCH 1/1] scripts/coccinelle: use BIT() macro if possible
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Wolfram Sang <wsa@the-dreams.de>, Michal Marek <mmarek@suse.cz>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Julia,

On Sun, Apr 27, 2014 at 11:36 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
> On Sun, 27 Apr 2014, Javier Martinez Canillas wrote:
>
>> Hello Wolfram,
>>
>> Thanks a lot for your feedback.
>>
>> On Sun, Apr 27, 2014 at 7:14 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>> > On Sun, Apr 27, 2014 at 02:29:46AM +0200, Javier Martinez Canillas wrote:
>> >> Using the BIT() macro instead of manually shifting bits
>> >> makes the code less error prone and also more readable.
>> >
>> > Does it? It is a taste thing, yet I don't think it makes the code that
>> > much more readable that it is worth changing the whole tree.
>> >
>>
>> I believe there is a reason for that macro but yes I agree with you
>> that is a matter of taste and the it shouldn't be enforced.
>>
>> I'm doing a big refactoring for the GPIO subsystem and was told to use
>> coccinelle so this patch was part of my learning. I posted it because
>> I thought that it could be useful but I don't mind the patch to be
>> dropped if that is not the case.
>
> Perhaps it could be useful in files that already use BIT somewhere?
>

Well the semantic patch already has a rule that checks if the file
includes <linux/bitops.h> so files that don't include this header will
be skipped.

I've checked and in most cases when that header is included is because
at least the BIT macro is used once on the file. My guess is that the
original author included the header and used the macro but other
people modifying the file after its original creation just used 1 << n
instead.

But as I said, I've no strong opinion about this patch. I just used to
learn the basics of SmPL and to cleanup a driver I maintain and
thought it was a good touch to post it in case more people find it
useful.

> julia

Thanks a lot and best regards,
Javier
