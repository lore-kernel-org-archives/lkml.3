Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488Ab3DHQ7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:59:21 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56906 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934895Ab3DHQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:59:18 -0400
Date: Mon, 8 Apr 2013 11:59:16 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130408165916.GA3672@sgi.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162EC1A.4050204@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 09:11:06AM -0700, H. Peter Anvin wrote:
> On 04/08/2013 08:57 AM, Ingo Molnar wrote:
> > 
> > I think the original commit:
> > 
> >   f96972f2dc63 kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
> > 
> > actually regressed your 1024 CPU systems, and should possibly be reverted or fixed 
> > in some other fashion - such as by migrating to the primary CPU (on architectures 
> > that require that), instead of hotplug offlining every secondary CPU on every 
> > architecture!
> > 
> > Alternatively, disable_nonboot_cpus() could perhaps be improved to down CPUs in 
> > parallel: issue the CPU-down requests to every CPU, then wait for them to complete 
> > - instead of the loop over every CPU?
> > 
> > This would be the conceptual counter part to parallel boot up of CPUs - something 
> > SGI might be interested in as well?
> > 
> 
> Migrating to the boot processor and then calling stop_machine() to
> defang any other processors should be sufficient, no?
> 
> I don't know if there is any reason to deschedule all tasks?

My reading of the original commit indicated that some architecture's
firmware needs the boot cpu to be the one initiating reboot.

If that is correct, then I can not see why a stop_machine() implementation
will not work.

Since this is in generic kernel code, how can I proceed?

Robin
