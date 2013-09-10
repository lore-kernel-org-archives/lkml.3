Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3IJGr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:47:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3IJGr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:47:56 -0400
Message-ID: <1378795659.6046.41.camel@marge.simpson.net>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
From: Mike Galbraith <bitbucket@online.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 10 Sep 2013 08:47:39 +0200
In-Reply-To: <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	 <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:mFO8fjnaFKErGl6nqjcek2QtxV+IT8zzgdm/zbiKwCl
 OiaFy0iy7cuc5eH/go1fr23iYpCNMC/zijn6wNKgcCoIUlsJ2q
 Zq50XzqSfAmj5UiU38wBlGKTb89Z8IAD+947vN3YG1Qoh9aoDi
 6mOq1/LheFvFBaiHWZ74UnVQLb6qWNUS92JjXk4BQx4FNJaGaM
 hmluV/he1fav7tILI4O1GYD+ylqy/Vle09/jJSGrOnDvG+AM3V
 rn6O0FQ+Yq1r7ms09wrGq30LSROps3TboBCI3ybfsE0h5NZEWN
 RfaAl0ehlWbvJ880ZXSWAzya0yunUPkoZSyzJkwDOvGsJxNZOR
 vAqt25rakTsjk+S8SNeYvoZ/8I6x3bj/KawOlFBT1Mmu16cnzm
 J1QUfKa8aRJ7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 09:05 +0300, Gilad Ben-Yossef wrote: 
> Hi,
> 
> On Thu, Sep 5, 2013 at 11:07 PM, Christoph Lameter <cl@linux.com> wrote:
> > I am not sure how to call this kernel option but we need something like
> > that. I see drivers and the kernel spawning processes on the nohz cores.
> > The name kthread is not really catching the purpose.
> >
> > os_cpus=? highlatency_cpus=?
> >
> 
> First off, thank you for doing this. It is very useful :-)
> 
> Currently if one wishes to run a single task on an isolated CPU with
> as little interference as possible, one needs to pass
> rcu_nocbs, isolcpus, nohz_full parameters and now kthread parameter,
> all pretty much with the same values
> 
> I know some people won't like this, but can we perhaps fold all these
> into a single parameter, perhaps even the existing isolcpus?

isolcpus is supposed to go away, as cpusets can isolate CPUs, and can
turn off load balancing.

-Mike

