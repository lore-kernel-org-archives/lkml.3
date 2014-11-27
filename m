Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaK0S1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:27:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaK0S1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:27:38 -0500
Date: Thu, 27 Nov 2014 20:27:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, tglx@linutronix.de,
        David.Laight@ACULAB.COM
Subject: Re: [PATCH RFC 2/2] mm, sched: trigger might_sleep() in
 might_fault() when pagefaults are disabled
Message-ID: <20141127182710.GA30735@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <1417108217-42687-1-git-send-email-dahi@linux.vnet.ibm.com>
 <1417108217-42687-3-git-send-email-dahi@linux.vnet.ibm.com>
 <20141127172449.GA30380@redhat.com>
 <20141127173218.GA30419@redhat.com>
 <20141127190842.75a9cce3@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127190842.75a9cce3@thinkpad-w530>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:08:42PM +0100, David Hildenbrand wrote:
> > > > -
> > > > -	__might_sleep(__FILE__, __LINE__, 0);
> > > > +	if (unlikely(!pagefault_disabled()))
> > > > +		__might_sleep(__FILE__, __LINE__, 0);
> > > >    
> > 
> > Same here: so maybe make might_fault a wrapper
> > around __might_fault as well.
> 
> Yes, I also noticed that. It was part of the original code.
> For now I kept this revert as close as possible to
> the original patch.
> 
> Better fix this in an add-on patch? Or directly in this commit?

IMHO it's up to you really.

> At least for
> the in-header function it is easy to fix in this patch.
> 
> Thanks!

Right.
