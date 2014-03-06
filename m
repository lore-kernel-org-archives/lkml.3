Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaCFKVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:21:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaCFKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:21:28 -0500
Date: Thu, 6 Mar 2014 10:10:09 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, drjones@redhat.com, toshi.kani@hp.com,
        prarit@redhat.com, kirill.shutemov@linux.intel.com, JBeulich@suse.com,
        peterz@infradead.org, paul.gortmaker@windriver.com,
        seiji.aguchi@hds.com, bp@suse.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, tglx@linutronix.de, riel@redhat.com
Subject: Re: [PATCH] abort secondary CPU bring-up gracefully if do_boot_cpu
 timed out on cpu_callin_mask
Message-ID: <20140306101009.34ba6c3c@nial.usersys.redhat.com>
In-Reply-To: <20140306070832.GA1277@gmail.com>
References: <1394030723-15084-1-git-send-email-imammedo@redhat.com>
	<20140306070832.GA1277@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 08:08:32 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Igor Mammedov <imammedo@redhat.com> wrote:
> 
> > Master CPU may timeout before cpu_callin_mask is set and cancel
> > booting CPU, but being onlined CPU still continues to boot, sets
> > cpu_active_mask (CPU_STARTING notifiers) and spins in
> > check_tsc_sync_target() for master cpu to arrive. Following attempt
> > to online another cpu hangs in stop_machine, initiated from here:
> 
> The changelog needs to prominently contain a description of the 
> practical relevance of this patch: has the hang triggered on any 
> system and under what circumstances, and did the patch resolve the 
> hang, etc.?

Hang is observed on virtual machines during CPU hotplug,
especially in big guests with many CPUs. (It happens more
often if host is over-committed).

Similar patch is carried in RHEL6 since 2012 and it fixes
issue there, when applied to upstream kernel it also fixes
issue.

> 
> Thanks,
> 
> 	Ingo

Thanks,
  Igor.
