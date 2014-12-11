Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbaLKJ5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:57:11 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:35165 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaLKJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:57:08 -0500
Date: Thu, 11 Dec 2014 10:56:47 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v4] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141211105647.4e3a25d8@thinkpad-w530>
In-Reply-To: <20141210175055.GA11802@redhat.com>
References: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141210175055.GA11802@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121109-0025-0000-0000-000002D44C91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is subjective, but how about
> 
> 	static bool xxx(void)
> 	{
> 		mutex_lock(&cpu_hotplug.lock);
> 		if (atomic_read(&cpu_hotplug.refcount) == 0)
> 			return true;
> 		mutex_unlock(&cpu_hotplug.lock);
> 		return false;
> 	}
> 
> 	void cpu_hotplug_begin(void)
> 	{
> 		cpu_hotplug.active_writer = current;
> 
> 		cpuhp_lock_acquire();
> 		wait_event(&cpu_hotplug.wq, xxx());
> 	}
> 
> instead?
> 
> Oleg.
> 

Just checked wait_event(). It is safe against such race conditions as the same
pattern is used is applied internally.

Thanks!

David

