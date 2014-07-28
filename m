Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaG1SzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:55:23 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:52301 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbaG1SzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:55:21 -0400
Date: Mon, 28 Jul 2014 13:55:17 -0500 (CDT)
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
In-Reply-To: <53D31101.8000107@oracle.com>
Message-ID: <alpine.DEB.2.11.1407281353450.15405@gentwo.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Sasha Levin wrote:

> This patch doesn't interact well with my fuzzing setup. I'm seeing
> the following:
>
> [  490.446927] BUG: using __this_cpu_read() in preemptible [00000000] code: kworker/16:1/7368
> [  490.447909] caller is __this_cpu_preempt_check+0x13/0x20

__this_cpu_read() from vmstat_update is only called from a kworker that
is bound to a single cpu. A false positive?
