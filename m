Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3HaAuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:50:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42375 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3HaAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <1377905319.2070.38.camel@joe-AO722>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
	<52210D34.5030807@infradead.org>
	<CAOMFOmUav+3UqR9s5LF6n4c4oXZ-K5oBJrmLtz-PMY053vH8Rg@mail.gmail.com>
	<52212128.3000100@infradead.org>
	<1377905319.2070.38.camel@joe-AO722>
Date: Fri, 30 Aug 2013 17:50:14 -0700
Message-ID: <CAOMFOmVrNu2ZDrBrm7Rt_p-C3Po0d6HmyCQ2HvJSVT=cx+OjOw@mail.gmail.com>
Subject: Re: do_div() silently truncates "base" to 32bit
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, bernie@develer.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Joe

On Fri, Aug 30, 2013 at 4:28 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-08-30 at 15:48 -0700, Randy Dunlap wrote:
>> On 08/30/13 15:14, Anatol Pomozov wrote:
>> > But another question still remains: why compiler does not warn that
>> > size truncation happens? How to prevent bugs like CFQ one in the
>> > future? Should we add a compile-time assert to do_div() to prevent
>> > passing 64 numbers in "base" macro parameter?
>> That sounds like a fine idea to me.
>
> Geert thought so too and submitted a patch
>
> http://www.spinics.net/lists/linux-btrfs/msg26788.html

Thanks it works!

block/cfq-iosched.c: In function 'cfqg_prfill_avg_queue_size':
block/cfq-iosched.c:4423:3: error: size of unnamed array is negative
make[2]: *** [block/gfq-iosched.s] Error 1
make[1]: *** [block/gfq-iosched.s] Error 2



I see a number of other truncation errors. We need to fix them as well.
