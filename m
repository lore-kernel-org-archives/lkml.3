Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbaLJTXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:23:54 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59780 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaLJTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:23:51 -0500
Date: Wed, 10 Dec 2014 20:23:40 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v4] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141210202340.1cc25999@thinkpad-w530>
In-Reply-To: <20141210160025.GR25340@linux.vnet.ibm.com>
References: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141210142619.790e3b38@thinkpad-w530>
	<20141210160025.GR25340@linux.vnet.ibm.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121019-0017-0000-0000-000002294E13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only thing that is bugging me is this part. Without the lock we can't
> > guarantee that another get_online_cpus() just arrived and bumped the refcount
> > to 0.
> > 
> > Of course this only applies to misuse of put/get_online_cpus.
> > 
> > We could hack some loop that tries to cmp_xchng with the old value until it
> > fits to work around this, but wouldn't make the code any better readable.
> 
> Well, we didn't have this diagnostic in the original, so one approach
> would be to simply leave it out.  Another approach would be to just
> have the WARN_ON() without the attempt to fix it up.
> 
> 							Thanx, Paul

Well, I think the WARN_ON would be sufficient for debugging purposes.

Thanks!

David

