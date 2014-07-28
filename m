Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaG1WBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:01:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31618 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaG1WBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:01:43 -0400
Message-ID: <53D6C80F.8010307@oracle.com>
Date: Mon, 28 Jul 2014 18:00:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>
CC: Gilad Ben-Yossef <gilad@benyossef.com>,
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
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>	<53D31101.8000107@oracle.com>	<alpine.DEB.2.11.1407281353450.15405@gentwo.org> <20140728145443.dce6fe72aed1bbdcf95b21f6@linux-foundation.org>
In-Reply-To: <20140728145443.dce6fe72aed1bbdcf95b21f6@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 05:54 PM, Andrew Morton wrote:
> Also, Sasha's report showed this:
> 
> [  490.464613] kernel BUG at mm/vmstat.c:1278!
> 
> That's your VM_BUG_ON() in vmstat_update().  That ain't no false
> positive!
> 
> 
> 
> Is this code expecting that schedule_delayed_work() will schedule the
> work on the current CPU?  I don't think it will do that.  Maybe you
> should be looking at schedule_delayed_work_on().

I suspected that the re-queue might be wrong (schedule_delayed_work vs
schedule_delayed_work_on) and tried fixing that, but that didn't solve
the issue.

I could give it another go unless someone sees the issue, I might have
messed something up.


Thanks,
Sasha
