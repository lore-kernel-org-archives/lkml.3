Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaE1JIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:08:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:33076 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaE1JIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:08:32 -0400
Date: Wed, 28 May 2014 11:08:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Libo Chen <libo.chen@huawei.com>
cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org, Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: balance storm
In-Reply-To: <5385881D.4090601@huawei.com>
Message-ID: <alpine.DEB.2.02.1405281106130.21720@ionos.tec.linutronix.de>
References: <5382AF2E.1040407@huawei.com>  <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>  <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>  <1401184553.5134.115.camel@marge.simpson.net>
 <53848A2C.5010209@huawei.com>  <1401196807.5134.132.camel@marge.simpson.net> <53853604.50500@huawei.com> <1401242038.4721.14.camel@marge.simpson.net> <5385881D.4090601@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Libo Chen wrote:

> On 2014/5/28 9:53, Mike Galbraith wrote:
> > On Wed, 2014-05-28 at 09:04 +0800, Libo Chen wrote:
> > 
> >> oh yes, no tsc only hpet in my box.
> > 
> > Making poor E5-2658 box a crippled wreck.
> 
> yes,it is. But cpu usage will be down from 15% to 5% when binding
> cpu, so maybe read_hpet is not the root cause.

Definitely hpet _IS_ the root cause on a machine as large as this,
simply because everything gets serialized on the hpet access.

Binding stuff to cpus just makes the timing behaviour different, so
the hpet serialization is not that prominent, but still bad enough.

Talk to your HW/BIOS vendor. The kernel cannot do anything about
defunct hardware.

Thanks,

	tglx
