Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3JJXpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:45:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3JJXpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:45:41 -0400
Date: Thu, 10 Oct 2013 16:46:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: "sangjung.woo" <sangjung.woo@samsung.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
Message-Id: <20131010164630.63cedf60.akpm@linux-foundation.org>
In-Reply-To: <1381446840.14017.21.camel@joe-AO722>
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
	<1381291649.2040.1.camel@joe-AO722>
	<5254DD64.4090205@samsung.com>
	<1381294767.2040.5.camel@joe-AO722>
	<20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
	<1381446840.14017.21.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 16:14:00 -0700 Joe Perches <joe@perches.com> wrote:

> On Thu, 2013-10-10 at 16:06 -0700, Andrew Morton wrote:
> > On Tue, 08 Oct 2013 21:59:27 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > I was a bit surprised to find there isn't a devm_kmalloc.
> > 
> > Yes, the unconditional memset is silly.  Especially when the
> > function has a handy gfp_t and could be passed __GFP_ZERO.
> > 
> > The comment says "managed kzalloc/kfree for device drivers, no kmalloc,
> > always use kzalloc".  There's no explanation for this - it looks like
> > some ideological thing.
> 
> Try this patch instead:
> https://lkml.org/lkml/2013/10/9/14
> 

That looks rather better.

Apart from forcing a needless memset, the current code will defeat
kmemcheck used-uninitialized checking.
