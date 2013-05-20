Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3ETEu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:50:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3ETEuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:50:25 -0400
Date: Mon, 20 May 2013 06:50:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule, round 2
Message-ID: <20130520045023.GA12690@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130509125040.GF27333@pd.tnic>
 <20130509125859.GG27333@pd.tnic>
 <20130515184528.GO4442@linux.vnet.ibm.com>
 <20130515224358.GF11783@pd.tnic>
 <20130515235512.GT4442@linux.vnet.ibm.com>
 <20130517135641.GF23035@pd.tnic>
 <51999591.8030401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51999591.8030401@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:16:33AM +0800, Michael Wang wrote:
> I suppose the reason is that the cpu we passed to
> mod_delayed_work_on() has a chance to become offline before we
> disabled irq, what about check it before send resched ipi? like:

I think this is only addressing the symptoms - what we should be doing
instead is asking ourselves why are we even scheduling work on a cpu if
the machine goes offline?

I don't know though who should be responsible for killing all that
work - the workqueue itself or the guy who created it, i.e. cpufreq
governor...

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
