Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaK0PTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:19:15 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46962 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaK0PTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:19:12 -0500
Date: Thu, 27 Nov 2014 16:19:05 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141127161905.7c6220ee@thinkpad-w530>
In-Reply-To: <alpine.DEB.2.11.1411271602320.3961@nanos>
References: <20141126151729.GB9612@redhat.com>
	<20141126152334.GA9648@redhat.com>
	<20141126163207.63810fcb@thinkpad-w530>
	<20141126154717.GB10568@redhat.com>
	<5475FAB1.1000802@de.ibm.com>
	<20141126163216.GB10850@redhat.com>
	<547604FC.4030300@de.ibm.com>
	<20141126170447.GC11202@redhat.com>
	<20141127070919.GA4390@osiris>
	<20141127090301.3ddc3077@thinkpad-w530>
	<20141127120441.GB4390@osiris>
	<alpine.DEB.2.11.1411271602320.3961@nanos>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112715-0009-0000-0000-0000022ADE54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OTOH, there is no reason why we need to disable preemption over that
> page_fault_disabled() region. There are code pathes which really do
> not require to disable preemption for that.
> 
> We have that seperated in preempt-rt for obvious reasons and IIRC
> Peter Zijlstra tried to distangle it in mainline some time ago. I
> forgot why that never got merged.
> 

Of course, we can completely separate that in our page fault code by doing
pagefault_disabled() checks instead of in_atomic() checks (even in add on
patches later).

> We tie way too much stuff on the preemption count already, which is a
> mightmare because we have no clear distinction of protection
> scopes. 

Although it might not be optimal, but keeping a separate counter for
pagefault_disable() as part of the preemption counter seems to be the only
doable thing right now. I am not sure if a completely separated counter is even
possible, increasing the size of thread_info.

I am working on a prototype right now.

Thanks!

> 
> Thanks,
> 
> 	tglx
> 

