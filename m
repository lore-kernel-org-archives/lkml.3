Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaENQwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:52:21 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45369 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaENQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:52:18 -0400
Message-ID: <53739F3B.4060608@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 12:52:11 -0400
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com>
In-Reply-To: <537180B9.6080407@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051416-1344-0000-0000-0000018BBE63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 10:17 PM, Sasha Levin wrote:
> I don't have an easy way to reproduce it as I only saw the bug once, but
> it happened when I started pressuring CPU hotplug paths by adding and removing
> CPUs often. Maybe it has anything to do with that?

As per the original report 
(http://article.gmane.org/gmane.linux.kernel/1643027)
I am able to reproduce the problem.

The workload is (on S390 architecture):
2 processes onlining random cpus in a tight loop by using 'echo 1 >
/sys/bus/cpu.../online'
2 processes offlining random cpus in a tight loop by using 'echo 0 >
/sys/bus/cpu.../online'
Otherwise, fairly idle system. load average: 5.82, 6.27, 6.27

The machine has 10 processors.
The warning message some times hits within a few minutes on starting the
workload. Other times it takes several hours.


-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

