Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaDNJ4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaDNJ4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:56:30 -0400
Date: Mon, 14 Apr 2014 11:56:00 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 3/5] x86: fix list corruption on CPU hotplug
Message-ID: <20140414115600.0d5dbbb5@thinkpad>
In-Reply-To: <20140414091954.GB19771@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
	<1397150061-29735-4-git-send-email-imammedo@redhat.com>
	<20140414091954.GB19771@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 11:19:54 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Igor Mammedov <imammedo@redhat.com> wrote:
> 
> > currently if AP wake up is failed, master CPU marks AP as not present
> > in do_boot_cpu() by calling set_cpu_present(cpu, false).
> > That leads to following list corruption on the next physical CPU
> > hotplug:
> 
> Shouldn't this fix precede the main change to the smp bootup logic?
> 
> Can this bug trigger with current upstream kernels?
That's not impossible, tests showed that with current kernel there will
be other problems due wild AP running around.

I'll reorder patch anyway.

> 
> Thanks,
> 
> 	Ingo


-- 
Regards,
  Igor
