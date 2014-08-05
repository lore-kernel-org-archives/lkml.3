Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaHEOvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:51:50 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:38799 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbaHEOvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:51:49 -0400
Date: Tue, 5 Aug 2014 09:51:44 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
In-Reply-To: <53DFFD28.2030502@oracle.com>
Message-ID: <alpine.DEB.2.11.1408050950390.16902@gentwo.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <53DFFD28.2030502@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014, Sasha Levin wrote:

> On 07/25/2014 10:22 PM, Sasha Levin wrote:
> > On 07/10/2014 10:04 AM, Christoph Lameter wrote:
> >> > This patch creates a vmstat shepherd worker that monitors the
> >> > per cpu differentials on all processors. If there are differentials
> >> > on a processor then a vmstat worker local to the processors
> >> > with the differentials is created. That worker will then start
> >> > folding the diffs in regular intervals. Should the worker
> >> > find that there is no work to be done then it will make the shepherd
> >> > worker monitor the differentials again.
> > Hi Christoph, all,
> >
> > This patch doesn't interact well with my fuzzing setup. I'm seeing
> > the following:
>
> I think we got sidetracked here a bit, I've noticed that this issue
> is still happening in -next and discussions here died out.

Ok I saw in another thread that this issue has gone away. Is there an
easy way to reproduce this on my system?

