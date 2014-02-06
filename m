Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaBFSlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:41:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaBFSlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:41:50 -0500
Date: Thu, 6 Feb 2014 19:41:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
	callback registration functions
Message-ID: <20140206184103.GA31410@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Srivatsa S. Bhat wrote:
>
> The following method of CPU hotplug callback registration is not safe
> due to the possibility of an ABBA deadlock involving the cpu_add_remove_lock
> and the cpu_hotplug.lock.

Off-topic, but perhaps it also makes sense to add the lockdep annotations
later, to catch other similar problems. Currently get_online_cpus() acquires
nothing from lockdep pov.


As for the this patch/series, personally I agree.

Oleg.

