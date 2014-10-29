Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaJ2Eaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 00:30:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37841 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaJ2Eag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 00:30:36 -0400
Date: Wed, 29 Oct 2014 12:30:30 +0800
From: Minfei Huang <mnfhuang@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Avoid overlap the fixmap area on i386
Message-ID: <20141029043030.GA4514@dhcp-17-62.nay.redhat.com>
References: <6B680A9E-6CE9-4C96-934B-CB01DCB58278@gmail.com>
 <alpine.DEB.2.11.1410281159590.5308@nanos>
 <544FD138.3030305@zytor.com>
 <alpine.DEB.2.11.1410281828340.5308@nanos>
 <54505B7A.80502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54505B7A.80502@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/14 at 08:14pm, H. Peter Anvin wrote:
> On 10/28/2014 10:29 AM, Thomas Gleixner wrote:
> > On Tue, 28 Oct 2014, H. Peter Anvin wrote:
> >> On 10/28/2014 04:06 AM, Thomas Gleixner wrote:
> >>>>
> >>>> The available address we can use is lower than FIXADDR_BOOT_START. So
> >>>> We will set the kmap boundary below the FIXADDR_BOOT_START, if configure
> >>>> the high memory.
> >>>>
> >>>> If we configure the high memory, the vmalloc reserve area should end
> >>>> up to PKMAP_BASE, otherwise should end up to FIXADDR_BOOT_START.
> >>>
> >>> Which is not really a problem, because the FIXADDR_BOOT area is only
> >>> used during boot for early_ioremap() and it's unused when ioremap() is
> >>> functional. vmalloc becomes available after early boot so the
> >>> FIXADDR_BOOT area is available for reuse.
> >>>
> >>
> >> Given the very limited address space available on i386, it would be
> >> extremely undesirable to not reuse address space when possible.
> > 
> > Fair enough. Then we should do that for the highmem=y case as well.
> > 
> 
> It is probably even more important for highmem=y...
> 
> 	-hpa

Agree. Maybe we can overlap the early_ioremap fix address to re-use
it. Virtual address is more precious on i386, especially when turn on the
high memory.

I will post an patch to fix it.

> 
> 
