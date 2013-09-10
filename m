Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3IJGFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:05:52 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:64979 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3IJGFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:05:50 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
Date: Tue, 10 Sep 2013 09:05:49 +0300
Message-ID: <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of cpus.
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 5, 2013 at 11:07 PM, Christoph Lameter <cl@linux.com> wrote:
> I am not sure how to call this kernel option but we need something like
> that. I see drivers and the kernel spawning processes on the nohz cores.
> The name kthread is not really catching the purpose.
>
> os_cpus=? highlatency_cpus=?
>

First off, thank you for doing this. It is very useful :-)

Currently if one wishes to run a single task on an isolated CPU with
as little interference as possible, one needs to pass
rcu_nocbs, isolcpus, nohz_full parameters and now kthread parameter,
all pretty much with the same values

I know some people won't like this, but can we perhaps fold all these
into a single parameter, perhaps even the existing isolcpus?

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
