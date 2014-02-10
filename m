Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBJR1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:27:33 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61329 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaBJR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:27:31 -0500
Date: Mon, 10 Feb 2014 22:57:51 +0530
From: Balbir Singh <bsingharora@gmail.com>
To: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, paulus@samba.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of callback
 registration functions
Message-ID: <20140210172751.GA30766@balbir-System-Product-Name>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
 <20140206184103.GA31410@redhat.com>
 <20140207191125.GA8098@in.ibm.com>
 <52F898CB.6030900@linux.vnet.ibm.com>
 <20140210105130.GA14693@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210105130.GA14693@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:21:30PM +0530, Gautham R Shenoy wrote:
> On Mon, Feb 10, 2014 at 02:45:55PM +0530, Srivatsa S. Bhat wrote:
> 
> +	cpuhp_lock_acquire_read();
>  	mutex_lock(&cpu_hotplug.lock);

Don't you want to abstract cpuhp_lock_acquire_read and mutex_lock into a
more useful primitive. Ditto for the unlock bits - specifically if they
will always be used together.

