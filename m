Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3CZIFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:05:55 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:64621 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3CZIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:05:51 -0400
Date: Tue, 26 Mar 2013 09:05:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Russ Anderson <rja@sgi.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-ID: <20130326080545.GA26852@gmail.com>
References: <20130318155619.GA18828@sgi.com>
 <20130321105516.GC18484@gmail.com>
 <20130321123505.GA6051@dhcp22.suse.cz>
 <20130321180321.GB4185@gmail.com>
 <20130325142630.faf41b11416c2e4ac3d61550@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130325142630.faf41b11416c2e4ac3d61550@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 21 Mar 2013 19:03:21 +0100 Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > IMO the local scope is more obvious as this is and should only be 
> > > used for caching purposes.
> > 
> > It's a pattern we actively avoid in kernel code.
> 
> On the contrary, I always encourage people to move the static 
> definitions into function scope if possible.  So the reader can see the 
> identifier's scope without having to search the whole file. 
> Unnecessarily giving the identifier file-scope seems weird.

A common solution I use is to move such variables right before the 
function itself. That makes the "this function's scope only" aspect pretty 
apparent - without the risks of hiding globals amongst local variables. 

The other approach is to comment the variables very clearly that they are 
really globals as the 'static' keyword is easy to miss while reading 
email.

Both solutions are basically just as visible as the solution you prefer - 
but more robust.

Anyway, I guess we have to agree to disagree on that, we probably already 
spent more energy on discussing this than any worst-case problem the 
placement of these variables could ever cause in the future ;-)

Thanks,

	Ingo
