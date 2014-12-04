Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaLDQaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:30:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaLDQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:30:34 -0500
Date: Thu, 4 Dec 2014 08:30:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: suppress build warning
Message-ID: <20141204163032.GA29076@kroah.com>
References: <1417703910-2474-1-git-send-email-prabhakar.csengg@gmail.com>
 <12630889.EI0exeDoNc@wuerfel>
 <CA+V-a8vH9McTLVSWhQZun04AP7SZ7wGHeobBK1hA+EKn5fYgKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+V-a8vH9McTLVSWhQZun04AP7SZ7wGHeobBK1hA+EKn5fYgKw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:13:00PM +0000, Prabhakar Lad wrote:
> On Thu, Dec 4, 2014 at 2:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 04 December 2014 14:38:30 Lad, Prabhakar wrote:
> >> this patch fixes following build warning:
> >>
> >> drivers/misc/ioc4.c: In function ‘ioc4_probe’:
> >> drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >>   period = (end - start) /
> >>                 ^
> >> drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
> >>   uint64_t start, end, period;
> >>
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >
> > Please explain why the compiler thinks there is a bug, why you
> > are sure that there isn't, and why you picked '0' as the
> > initialization value.
> >
> Its a false positive, to suppress the warning '0' was picked.

Are you _sure_ it's a false positive?  That odd do/while loop looks like
it might just not ever initialize the start variable, are you sure the
logic there is correct?

thanks,

greg k-h
