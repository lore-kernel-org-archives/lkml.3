Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaHFSfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:35:21 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:44042 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbaHFSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <17153.1407349640@turing-police.cc.vt.edu>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
	<17153.1407349640@turing-police.cc.vt.edu>
Date: Wed, 6 Aug 2014 14:35:19 -0400
X-Google-Sender-Auth: WnJj4f7QB31fjjQbKHmVxU0odcU
Message-ID: <CAKb7Uvj7CRE3O8N8+_1pk_aHVWWWBWUit2N+2=yy5NTG0Gaidw@mail.gmail.com>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Valdis.Kletnieks@vt.edu
Cc: Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 2:27 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 06 Aug 2014 13:53:17 -0400, Nick Krause said:
>> Remove unused definition which cause the following warnings
>>
>> drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
>> include/linux/fs.h:193:0: note: this is the location of the previous definition
>> drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
>> include/linux/fs.h:192:0: note: this is the location of the previous definition
>
>> -#define WRITE 0
>> -#define READ  1
>
> NAK.  Full stop.  These are potentially used in an inner macro someplace, and by
> removing these, the conflicting values from fs.h will be used instead.
>
> #define READ                    0
> #define WRITE                   RW_MASK
>
> So if there *is* a use in an inner macro, you just screwed the pooch
> and introduced a bug in this "clean up" - somebody will be expecting to see
> a 0 for a READ, and will receive a 1 instead.  This can't end well.

I was actually about to send a similar response, but then I noticed I
couldn't actually find any uses of READ/WRITE in the file... But I
could easily have missed them.

>
> Nick - how *exactly* did you identify that these are in fact not used?
> Given your history of submitting poorly researched patches, you're going to
> have to justify the "unused" better than the handwaving you've done here.
