Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaIXNA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:00:26 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58322 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIXNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:00:24 -0400
Date: Wed, 24 Sep 2014 15:00:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, bp@alien8.de,
        prarit@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Resend PATCH V2] X86/CPU: Avoid 100ms sleep for cpu offline
 during S3
Message-ID: <20140924130019.GA3277@gmail.com>
References: <1409039025-32310-1-git-send-email-tianyu.lan@intel.com>
 <54211EB6.3020306@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54211EB6.3020306@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lan Tianyu <tianyu.lan@intel.com> wrote:

> On 2014年08月26日 15:43, Lan Tianyu wrote:
> > With some bad kernel configures, cpu offline consumes more than 100ms
> > during S3. This because native_cpu_die() would fall into 100ms
> > sleep when cpu idle loop thread marked cpu state to DEAD slower. It's
> > timing related issue. What native_cpu_die() does is that poll cpu
> > state and wait for 100ms if cpu state hasn't been marked to DEAD.
> > The 100ms sleep doesn't make sense. To avoid such long sleep, this
> > patch is to add struct completion to each cpu, wait for the completion
> > in the native_cpu_die() and wakeup the completion when the cpu state is
> > marked to DEAD.
> > 
> > Tested on the Intel Xeon server with 48 cores, Ivbridge and Haswell laptops.
> > the times of cpu offline on these machines are reduced from more than 100ms
> > to less than 5ms. The system suspend time reduces 2.3s on the servers.
> > 
> > Borislav and Prarit also helped to test the patch on an AMD machine and
> > a few systems of various sizes and configurations (multi-socket,
> > single-socket, no hyper threading, etc.). No issues seen.
> > 
> > Acked-by: Borislav Petkov <bp@suse.de>
> > Tested-by: Prarit Bhargava <prarit@redhat.com>
> > Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> > ---
> >  arch/x86/kernel/smpboot.c | 23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> > 
> 
> Hi HPA, Ingo, Thomas & Peter Z:
> 	Is this patch ok for you?

Nice patch!

I cleaned up a few small details and will push it out if it 
passes testing.

Thanks,

	Ingo
