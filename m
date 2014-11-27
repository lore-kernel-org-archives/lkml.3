Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaK0SIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:08:53 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:32886 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaK0SIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:08:52 -0500
Date: Thu, 27 Nov 2014 19:08:42 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, tglx@linutronix.de,
        David.Laight@ACULAB.COM
Subject: Re: [PATCH RFC 2/2] mm, sched: trigger might_sleep() in
 might_fault() when pagefaults are disabled
Message-ID: <20141127190842.75a9cce3@thinkpad-w530>
In-Reply-To: <20141127173218.GA30419@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
	<1417108217-42687-1-git-send-email-dahi@linux.vnet.ibm.com>
	<1417108217-42687-3-git-send-email-dahi@linux.vnet.ibm.com>
	<20141127172449.GA30380@redhat.com>
	<20141127173218.GA30419@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112718-0029-0000-0000-000001E852D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > -
> > > -	__might_sleep(__FILE__, __LINE__, 0);
> > > +	if (unlikely(!pagefault_disabled()))
> > > +		__might_sleep(__FILE__, __LINE__, 0);
> > >    
> 
> Same here: so maybe make might_fault a wrapper
> around __might_fault as well.

Yes, I also noticed that. It was part of the original code.
For now I kept this revert as close as possible to
the original patch.

Better fix this in an add-on patch? Or directly in this commit? At least for
the in-header function it is easy to fix in this patch.

Thanks!

