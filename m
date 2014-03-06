Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaCFHIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:08:49 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:60724 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCFHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:08:36 -0500
Date: Thu, 6 Mar 2014 08:08:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, drjones@redhat.com, toshi.kani@hp.com,
        prarit@redhat.com, kirill.shutemov@linux.intel.com, JBeulich@suse.com,
        peterz@infradead.org, paul.gortmaker@windriver.com,
        seiji.aguchi@hds.com, bp@suse.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, tglx@linutronix.de, riel@redhat.com
Subject: Re: [PATCH] abort secondary CPU bring-up gracefully if do_boot_cpu
 timed out on cpu_callin_mask
Message-ID: <20140306070832.GA1277@gmail.com>
References: <1394030723-15084-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394030723-15084-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> Master CPU may timeout before cpu_callin_mask is set and cancel
> booting CPU, but being onlined CPU still continues to boot, sets
> cpu_active_mask (CPU_STARTING notifiers) and spins in
> check_tsc_sync_target() for master cpu to arrive. Following attempt
> to online another cpu hangs in stop_machine, initiated from here:

The changelog needs to prominently contain a description of the 
practical relevance of this patch: has the hang triggered on any 
system and under what circumstances, and did the patch resolve the 
hang, etc.?

Thanks,

	Ingo
