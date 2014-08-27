Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbaH0XUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:20:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965249AbaH0XUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:20:08 -0400
Date: Wed, 27 Aug 2014 16:20:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/2] x86: Speed up ioremap operations
Message-Id: <20140827162006.580e83d57696b5eba203b18c@linux-foundation.org>
In-Reply-To: <53FE6690.80608@sgi.com>
References: <20140827225927.364537333@asylum.americas.sgi.com>
	<20140827160610.4ef142d28fd7f276efd38a51@linux-foundation.org>
	<53FE6690.80608@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 16:15:28 -0700 Mike Travis <travis@sgi.com> wrote:

> 
> > 
> >> There are two causes for requiring a restart/reload of the drivers.
> >> First is periodic preventive maintenance (PM) and the second is if
> >> any of the devices experience a fatal error.  Both of these trigger
> >> this excessively long delay in bringing the system back up to full
> >> capability.
> >>
> >> The problem was tracked down to a very slow IOREMAP operation and
> >> the excessively long ioresource lookup to insure that the user is
> >> not attempting to ioremap RAM.  These patches provide a speed up
> >> to that function.
> > 
> > With what result?
> > 
> 
> Early measurements on our in house lab system (with far fewer cpus
> and memory) shows about a 60-75% increase.  They have a 31 devices,
> 3000+ cpus, 10+Tb of memory.  We have 20 devices, 480 cpus, ~2Tb of
> memory.  I expect their ioresource list to be about 5-10 times longer.
> [But their system is in production so we have to wait for the next
> scheduled PM interval before a live test can be done.]

So you expect 1+ hours?  That's still nuts.
