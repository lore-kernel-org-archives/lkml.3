Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaLHTa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:30:27 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:56586 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:30:26 -0500
Date: Mon, 8 Dec 2014 20:30:18 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v1] CPU hotplug: active_reader not woken up in some
 cases - deadlock
Message-ID: <20141208203018.24f23bdb@thinkpad-w530>
In-Reply-To: <20141208190803.GR25340@linux.vnet.ibm.com>
References: <1418062383-39657-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141208183134.GQ25340@linux.vnet.ibm.com>
	<20141208195814.663007dd@thinkpad-w530>
	<20141208190803.GR25340@linux.vnet.ibm.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120819-0041-0000-0000-000002674CF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > active_writer is cleared while holding cpuhp_lock, so this should be safe,
> > right?
> 
> You lost me on that one.  Don't we get to that piece of code precisely
> because we don't hold any of the CPU-hotplug locks?  If so, the
> writer might well hold all the locks it needs, and might well change
> cpu_hotplug.active_writer out from under us.
> 
> What am I missing here?
> 
> 							Thanx, Paul

I was missing that cpuhp_lock_* are simply lockdep anotations ... it's
getting late :)

So you're right, we need to verify that we don't get a 0 on the second access.

Will send an updated version soon.

Thanks!

