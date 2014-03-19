Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbaCSCaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:30:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbaCSCaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:30:19 -0400
Date: Wed, 19 Mar 2014 02:31:35 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
Message-ID: <20140319023135.GB25178@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <20140317214145.GA29105@kroah.com>
 <CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
 <20140318003725.GA12217@kroah.com>
 <CAHb8M2D9Hf6pRza8-xgoSQrWx0x8CBv-qrThLWF3Hb6nZQQn7Q@mail.gmail.com>
 <CAHb8M2C0pBFuzA_Q+-zBkHT2ZckDKEkAvD0oiM900_ZhxxH2PQ@mail.gmail.com>
 <20140319005832.GB18725@kroah.com>
 <CAHb8M2D1vGZ1xk=Xs6y2hTPAy_9efXV1LVvi7t2MscBW+_CyEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2D1vGZ1xk=Xs6y2hTPAy_9efXV1LVvi7t2MscBW+_CyEg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:04:40AM +0900, DaeSeok Youn wrote:
> oh...
> You didn't get my reply about vmalloc usage.
> 
> My replay attach again, below.
> 
> > 2014-03-18 9:37 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> >> On Tue, Mar 18, 2014 at 09:26:07AM +0900, DaeSeok Youn wrote:
> >>> I think vmalloc/kmalloc in uislib_malloc() can be removed and just use
> >>> vmalloc/kmalloc directly.
> >>
> >> Yes.  Actually, just use kmalloc, I don't knwo why vmalloc is being
> >> used, but cc: the driver maintainers just to be sure.
> >
> Here, need to check by you.
> > It try to allocate 128KiB(131072byte) with vmalloc(). I think if it
> > trying to allocate with kmalloc()
> > it has a possibility to fail because of memory fragmentation even if
> > system has enough memory to use.
> > Just my opinion. If I'm wrong, let me know.

Check to see just how big you are allocating, you should know based on
the flags which code path happened uislib_malloc().

Just keep the logic the same and you should be fine.

greg k-h
