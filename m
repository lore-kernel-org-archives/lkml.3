Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaLPFoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:44:10 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64334 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaLPFoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:44:08 -0500
Date: Tue, 16 Dec 2014 14:43:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/zsmalloc: adjust order of functions
Message-ID: <20141216054357.GA17615@blaptop>
References: <1418478203-17687-1-git-send-email-opensource.ganesh@gmail.com>
 <20141216003941.GA17665@blaptop>
 <CADAEsF99yOT0ZHD3yDxT_tOM-48=3gut+-GB6SR5BBZxZ_XY6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADAEsF99yOT0ZHD3yDxT_tOM-48=3gut+-GB6SR5BBZxZ_XY6w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:08:02PM +0800, Ganesh Mahendran wrote:
> Hello Minchan,
> 
> 
> 2014-12-16 8:40 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> > Hello Ganesh,
> >
> > On Sat, Dec 13, 2014 at 09:43:23PM +0800, Ganesh Mahendran wrote:
> >> Currently functions in zsmalloc.c does not arranged in a readable
> >> and reasonable sequence. With the more and more functions added,
> >> we may meet below inconvenience. For example:
> >>
> >> Current functions:
> >>     void zs_init()
> >>     {
> >>     }
> >>
> >>     static void get_maxobj_per_zspage()
> >>     {
> >>     }
> >>
> >> Then I want to add a func_1() which is called from zs_init(), and this new added
> >> function func_1() will used get_maxobj_per_zspage() which is defined below zs_init().
> >>
> >>     void func_1()
> >>     {
> >>         get_maxobj_per_zspage()
> >>     }
> >>
> >>     void zs_init()
> >>     {
> >>         func_1()
> >>     }
> >>
> >>     static void get_maxobj_per_zspage()
> >>     {
> >>     }
> >>
> >> This will cause compiling issue. So we must add a declaration:
> >>     static void get_maxobj_per_zspage();
> >> before func_1() if we do not put get_maxobj_per_zspage() before func_1().
> >
> > Yes, I suffered from that when I made compaction but was not sure
> > it's it was obviously wrong.
> > Stupid question:
> > What's the problem if we should put function declaration on top of
> > source code?
> 
> There is no problem if we do this. But if we obey to some coding
> style, then it will
> be convenient for the later developers.
> Normally I put the global or important interface function at the
> bottom of the file, and
> the static or helper functions on the top. Because usually global
> functions is the caller, and
> static functions is the callee.
> 
> >
> >>
> >> In addition, puting module_[init|exit] functions at the bottom of the file
> >> conforms to our habit.
> >
> > Normally, we do but without any strong reason, I don't want to rub git-blame
> > by clean up patches.
> 
> Sorry, I did not consider this when I made this patch.:)
> 
> >
> > In summary, I like this patch but don't like to churn git-blame by clean-up
> > patchset without strong reason so I need something I am sure.
> 
> Now, zsmalloc module is active in development. More and more changes
> will be included.
> If we do not clean up, then this file may looks messy.
> 
> Thanks a lot.

Okay, you move my heart

Acked-by: Minchan Kim <minchan@kernel.org>

