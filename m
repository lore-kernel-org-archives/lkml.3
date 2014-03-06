Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaCFNcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:32:17 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45327 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaCFNcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:32:15 -0500
Date: Thu, 6 Mar 2014 14:32:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, drjones@redhat.com, toshi.kani@hp.com,
        prarit@redhat.com, kirill.shutemov@linux.intel.com, JBeulich@suse.com,
        peterz@infradead.org, paul.gortmaker@windriver.com,
        seiji.aguchi@hds.com, bp@suse.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, tglx@linutronix.de, riel@redhat.com
Subject: Re: [PATCH] abort secondary CPU bring-up gracefully if do_boot_cpu
 timed out on cpu_callin_mask
Message-ID: <20140306133211.GA2220@gmail.com>
References: <1394030723-15084-1-git-send-email-imammedo@redhat.com>
 <20140306070832.GA1277@gmail.com>
 <20140306101009.34ba6c3c@nial.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306101009.34ba6c3c@nial.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> On Thu, 6 Mar 2014 08:08:32 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Igor Mammedov <imammedo@redhat.com> wrote:
> > 
> > > Master CPU may timeout before cpu_callin_mask is set and cancel
> > > booting CPU, but being onlined CPU still continues to boot, sets
> > > cpu_active_mask (CPU_STARTING notifiers) and spins in
> > > check_tsc_sync_target() for master cpu to arrive. Following attempt
> > > to online another cpu hangs in stop_machine, initiated from here:
> > 
> > The changelog needs to prominently contain a description of the 
> > practical relevance of this patch: has the hang triggered on any 
> > system and under what circumstances, and did the patch resolve the 
> > hang, etc.?
> 
> Hang is observed on virtual machines during CPU hotplug, especially 
> in big guests with many CPUs. (It happens more often if host is 
> over-committed).
> 
> Similar patch is carried in RHEL6 since 2012 and it fixes issue 
> there, when applied to upstream kernel it also fixes issue.

Okay, cool - please update the patch description with that and 
resubmit.

Thanks,

	Ingo
