Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaDQP0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:26:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59627 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaDQP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:26:13 -0400
Date: Thu, 17 Apr 2014 17:26:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "qmewlo@gmail.com" <qmewlo@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140417152611.GD4321@pd.tnic>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
 <20140417100944.GG11096@twins.programming.kicks-ass.net>
 <20140417102442.GA8215@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:03:34PM +0000, Luck, Tony wrote:
> > Hohum, __raw_spin_lock_irqsave does preempt_disable(). And
> > machine_check_poll should be running in irq context so why would the
> > original issue happen?
> >
> >> kernel: [    7.341085] BUG: using __this_cpu_write() in preemptible [00000000] code: modprobe/546
> >
> > Unfortunately, I have only one line in a mail CCed to me.
> >
> > Color me confused.
> 
> Is this just the missing put_cpu() that Chen Gong already sent a patch for?

I'm not sure. There's some bug report floating around which contains the
"BUG" line above but I can't seem to find/get it.

I'll boot latest Linus tree on my SNB machine to check whether it
triggers here. Ingo says CONFIG_DEBUG_PREEMPT=y is causing it but this
is all hearsay stuff from where I'm standing...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
