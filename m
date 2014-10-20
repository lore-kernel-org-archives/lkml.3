Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaJTJvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:51:45 -0400
Received: from www17.your-server.de ([213.133.104.17]:41704 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaJTJvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:51:44 -0400
Date: Mon, 20 Oct 2014 11:51:33 +0200
Subject: Re: [uml-devel] [UM] Long loop in __getnsdayoftime() after resume
 from ram
From: Thomas Meyer <thomas@m3y3r.de>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <E1Xg9cr-0007LK-S6@www17.your-server.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9K9pp6J023498

Am 20.10.2014 10:27 schrieb Richard Weinberger <richard.weinberger@gmail.com>:
>
> On Sun, Oct 19, 2014 at 2:39 PM, Thomas Meyer <thomas@m3y3r.de> wrote: 
> > Hello, 
> > 
> > in UML kernel I get a long cpu using loop in __getnstimeofday() 
> > (kernel/time/timekeeping.c:315) in the call of timespec_add_ns(), 
> > when I left the host kernel suspended to ram for a few hours and resume 
> > again. 
> > this is because it seems like the tk->xtime_sec wasn't updated yet, but 
> > the nsecs were. nsecs can be as high as 8111000111000111000l 
> > 
> > the function timespec_add_ns() (include/linux/time.h:266) will call 
> > __iter_div_u64_rem() which has an optimized loop for the case 
> > that the dividend is not much bigger as the divisior. 
> > but this isn't the case for resume from ram on the host kernel. 
> > 
> > any ideas how to fix this? is it possible to intercept the resume from 
> > ram and update the timekeeper->xtime_sec somehow? 
> > or can the um arch somehow overwrite timespec_add_ns() to always use 
> > div_u64_rem() instead? 
>
> Hmm, does this always happen?

Yes, my single core system seems to trigger this every time after resume from ram.

> At least on my notebook it did not happen. I've started an UML yesterday 
> suspended it and after more than 12h it worked fine today. 
>
> BTW: Do you see the issue also then freezing UML using the freezer cgroup?

I'm not sure what do you mean by this. Do I need to enable some special configs for this in the host or uml kernel?

> Would be easier to debug. :) 
>
> -- 
> Thanks, 
> //richard 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
