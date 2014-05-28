Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaE1LzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:55:22 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40872 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaE1LzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:55:20 -0400
Message-ID: <1401278112.9793.45.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org, Huang Qiang <h.huangqiang@huawei.com>,
        Borislav Petkov <bp@alien8.de>
Date: Wed, 28 May 2014 13:55:12 +0200
In-Reply-To: <5385CBCE.9040507@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>
	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>
	 <1401184553.5134.115.camel@marge.simpson.net> <53848A2C.5010209@huawei.com>
	 <1401196807.5134.132.camel@marge.simpson.net> <53853604.50500@huawei.com>
	 <1401242038.4721.14.camel@marge.simpson.net> <5385881D.4090601@huawei.com>
	 <alpine.DEB.2.02.1405281106130.21720@ionos.tec.linutronix.de>
	 <5385CBCE.9040507@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 19:43 +0800, Libo Chen wrote: 
> On 2014/5/28 17:08, Thomas Gleixner wrote:
> > On Wed, 28 May 2014, Libo Chen wrote:
> > 
> >> On 2014/5/28 9:53, Mike Galbraith wrote:
> >>> On Wed, 2014-05-28 at 09:04 +0800, Libo Chen wrote:
> >>>
> >>>> oh yes, no tsc only hpet in my box.
> >>>
> >>> Making poor E5-2658 box a crippled wreck.
> >>
> >> yes,it is. But cpu usage will be down from 15% to 5% when binding
> >> cpu, so maybe read_hpet is not the root cause.
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
> thank you for your reply.but suse sp2 is very good in this scene.
> Can it be said there has a bug, then community fix it later,
> so it's just a coincidence?

I'm quite sure it's because of the patches I mentioned.

-Mike

