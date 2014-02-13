Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaBMLGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:06:36 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45368 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbaBMLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:06:32 -0500
Date: Thu, 13 Feb 2014 16:36:15 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of callback
 registration functions
Message-ID: <20140213110615.GA17359@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
 <1392081980.5612.123.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392081980.5612.123.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021311-9332-0000-0000-00000317D4F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:26:20PM -0700, Toshi Kani wrote:
> 
> get/put_online_cpus() is a reader-lock and concurrent executions are
> allowed among the readers.  They won't be serialized until a cpu
> online/offline operation begins.  By replacing this lock with
> cpu_maps_update_begin/done(), we now serialize all readers.

We're not serializing all the readers, just the ones which want to
register/unregister their cpu-hotplug notifiers. This is a one-off
event which typically happens during a module_init() or a
module_exit() time. So this patchset does not replace
get/put_online_cpus() if that is the concern!

--
Thanks and Regards
gautham.
 


