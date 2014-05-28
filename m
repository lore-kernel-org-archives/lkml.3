Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaE1Kwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:52:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38118 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaE1Kwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:52:44 -0400
Date: Wed, 28 May 2014 12:52:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Libo Chen <libo.chen@huawei.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: balance storm
Message-ID: <20140528105238.GB17196@pd.tnic>
References: <1401113960.23186.41.camel@marge.simpson.net>
 <53844510.1040502@huawei.com>
 <1401184553.5134.115.camel@marge.simpson.net>
 <53848A2C.5010209@huawei.com>
 <1401196807.5134.132.camel@marge.simpson.net>
 <53853604.50500@huawei.com>
 <1401242038.4721.14.camel@marge.simpson.net>
 <5385881D.4090601@huawei.com>
 <alpine.DEB.2.02.1405281106130.21720@ionos.tec.linutronix.de>
 <20140528103019.GT11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140528103019.GT11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:30:19PM +0200, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 11:08:40AM +0200, Thomas Gleixner wrote:
> > On Wed, 28 May 2014, Libo Chen wrote:
> > 
> > > On 2014/5/28 9:53, Mike Galbraith wrote:
> > > > On Wed, 2014-05-28 at 09:04 +0800, Libo Chen wrote:
> > > > 
> > > >> oh yes, no tsc only hpet in my box.
> > > > 
> > > > Making poor E5-2658 box a crippled wreck.
> > > 
> > > yes,it is. But cpu usage will be down from 15% to 5% when binding
> > > cpu, so maybe read_hpet is not the root cause.
> > 
> > Definitely hpet _IS_ the root cause on a machine as large as this,
> > simply because everything gets serialized on the hpet access.
> > 
> > Binding stuff to cpus just makes the timing behaviour different, so
> > the hpet serialization is not that prominent, but still bad enough.
> > 
> > Talk to your HW/BIOS vendor. The kernel cannot do anything about
> > defunct hardware.
> 
> ---
> Subject: x86: FW_BUG when the TSC goes funny on hardware where it really should be stable
> 
> It happens far too often on 'consumer' grade hardware, and sometimes on
> 'enterprise' too that the TSC gets marked unstable due to FW fuckage,
> complain more loudly in this case.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
