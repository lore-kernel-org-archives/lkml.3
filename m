Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaLJBUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:20:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbaLJBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:20:22 -0500
Date: Wed, 10 Dec 2014 01:26:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some
	cases - deadlock
Message-ID: <20141210002619.GB516@redhat.com>
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com> <20141209141903.GB25340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209141903.GB25340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Paul E. McKenney wrote:
>
> Would wait_event()/wake_up() work for the wakeup-writer case?

Yes, and in this case we could probably kill this puts_pending logic
and avoid cpu_hotplug.lock in put_online_cpus() altogether? Can't we
just make cpu_hotplug.refcount atomic_t?

Anyway, this makes me think again that this code should use percpu_rwsem.
Perhaps I'll try to make a patch next week...

(we need down_write_recursive_readers(), and probably rcusync patches).

Oleg.

