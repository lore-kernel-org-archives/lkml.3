Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3IJVIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:08:12 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:45748 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab3IJVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:08:11 -0400
Date: Tue, 10 Sep 2013 21:08:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
Message-ID: <0000014109b3f0bf-c60a4ca2-91f2-4058-acec-bedfa4718a8d-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.10-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Gilad Ben-Yossef wrote:

> as little interference as possible, one needs to pass
> rcu_nocbs, isolcpus, nohz_full parameters and now kthread parameter,
> all pretty much with the same values
>
> I know some people won't like this, but can we perhaps fold all these
> into a single parameter, perhaps even the existing isolcpus?

I have made similar suggestions before. Maybe even autoconfigure the whole
thing? Dedicate the first processor on each numa node to high latency OS
tasksk and keep the rest as noisefree as possible?


