Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3HNVXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:23:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:18466 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203Ab3HNVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:23:12 -0400
Message-ID: <520BF53D.4020304@tilera.com>
Date: Wed, 14 Aug 2013 17:23:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] mm: make lru_add_drain_all() selective
References: <20130814200748.GI28628@htj.dyndns.org> <201308142029.r7EKTMRw023404@farm-0002.internal.tilera.com> <20130814141258.6289d9926944245befffa3af@linux-foundation.org>
In-Reply-To: <20130814141258.6289d9926944245befffa3af@linux-foundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2013 5:12 PM, Andrew Morton wrote:
> On Wed, 14 Aug 2013 16:22:18 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:
>
>> This change makes lru_add_drain_all() only selectively interrupt
>> the cpus that have per-cpu free pages that can be drained.
>>
>> This is important in nohz mode where calling mlockall(), for
>> example, otherwise will interrupt every core unnecessarily.
> Changelog isn't very informative.  I added this:
>
> : This is important on workloads where nohz cores are handling 10 Gb traffic
> : in userspace.  Those CPUs do not enter the kernel and place pages into LRU
> : pagevecs and they really, really don't want to be interrupted, or they
> : drop packets on the floor.
>
> to attempt to describe the rationale for the patch.

Thanks.  More motivational text is always a good thing.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

