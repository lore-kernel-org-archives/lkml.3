Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaDNK4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:56:15 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41822 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaDNK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:56:10 -0400
Date: Mon, 14 Apr 2014 12:56:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 3/5] x86: fix list corruption on CPU hotplug
Message-ID: <20140414105605.GC3246@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
 <1397150061-29735-4-git-send-email-imammedo@redhat.com>
 <20140414091954.GB19771@gmail.com>
 <20140414115600.0d5dbbb5@thinkpad>
 <20140414100457.GD731@gmail.com>
 <20140414122333.0908c2a2@thinkpad>
 <20140414103413.GB2846@gmail.com>
 <20140414124838.1acedd14@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414124838.1acedd14@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> On Mon, 14 Apr 2014 12:34:13 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Igor Mammedov <imammedo@redhat.com> wrote:
> > 
> > > On Mon, 14 Apr 2014 12:04:57 +0200
> > > Ingo Molnar <mingo@kernel.org> wrote:
> > > 
> > > > 
> > > > * Igor Mammedov <imammedo@redhat.com> wrote:
> > > > 
> > > > > On Mon, 14 Apr 2014 11:19:54 +0200
> > > > > Ingo Molnar <mingo@kernel.org> wrote:
> > > > > 
> > > > > > 
> > > > > > * Igor Mammedov <imammedo@redhat.com> wrote:
> > > > > > 
> > > > > > > currently if AP wake up is failed, master CPU marks AP as not present
> > > > > > > in do_boot_cpu() by calling set_cpu_present(cpu, false).
> > > > > > > That leads to following list corruption on the next physical CPU
> > > > > > > hotplug:
> > > > > > 
> > > > > > Shouldn't this fix precede the main change to the smp bootup logic?
> > > > > > 
> > > > > > Can this bug trigger with current upstream kernels?
> > > > > That's not impossible, tests showed that with current kernel there will
> > > > > be other problems due wild AP running around.
> > > > > 
> > > > > I'll reorder patch anyway.
> > > > 
> > > > So, could you please first make sure that with only the fixes applied 
> > > > there's no problems left?
> > >
> > > Sure, I'll retest reordered series.
> > 
> > Please don't jus test a reodered series, but a 'fixes only' series, 
> > which does not include patch #1.
> >
>
> Yep, that's ^^^ what I've meant to do, I'm sorry for not being clear 
> enough. I'll check that bugs, that patches fix, are fixed and they 
> don't break something else except of issues #1 fixes of cause.

Great, thanks!

	Ingo
