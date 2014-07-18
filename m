Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762447AbaGRULF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:11:05 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41481 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbaGRULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:11:03 -0400
Date: Fri, 18 Jul 2014 23:10:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] proc: fix PAGE_SIZE limit of /proc/$PID/cmdline
Message-ID: <20140718201059.GA26857@p183.telecom.by>
References: <20140716213247.GC21290@p183.telecom.by>
 <20140717155346.afadf6243dc6c0ebfda95853@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717155346.afadf6243dc6c0ebfda95853@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 03:53:46PM -0700, Andrew Morton wrote:
> On Thu, 17 Jul 2014 00:32:47 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Convert /proc/$PID/cmdline to seq_file interface.
> > 
> > XXX
> 
> Unsure what XXX signifies.
> 
> > This one must be buggy.
> > 
> > seq_file buffer is adjustable, so userspace can execute itself
> > with huge command line (which can be arbitrarily long now), then read 1 byte.
> > 
> > Voila, whole command line now is in kmalloced/vmalloced memory.
> > 
> > Imposing limit is trivial but equally lame to current PAGE_SIZE limit.
> 
> Confused. Why send the patch if you don't like it?
> 
> Why not go ahead and impose the PAGE_SIZE limit?

I thought someone smarter than me would suggest what to do.

Please replace with v2.
