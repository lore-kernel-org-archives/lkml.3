Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3J1DBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:01:07 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52732 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab3J1DBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:01:04 -0400
Date: Mon, 28 Oct 2013 11:00:55 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, cl@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new
 group
Message-ID: <20131028030055.GC15642@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123008.GJ14934@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027123008.GJ14934@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102803-2674-0000-0000-00000B400555
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 08:30:08AM -0400, Tejun Heo wrote:
>On Mon, Oct 21, 2013 at 04:58:11PM +0800, Wei Yang wrote:
>> When a cpu belongs to a new group, there is no cpu has the same group id. This
>> means it can be assigned a new group id without checking with every others.
>> 
>> This patch does this optimiztion.
>
>Does this actually matter?  If so, it'd probably make a lot more sense
>to start inner loop at @cpu + 1 so that it becomes O(N).

One of the worst case in my mind:

CPU:        0    1    2    3    4    ...
Group:      0    1    2    3    4    ...
(sounds it is impossible in the real world)

Every time, when we encounter a new CPU and try to assign it to a group, we
found it belongs to a new group. The original logic will iterate on all old
CPUs again, while the new logic could skip this and assign it to a new group.

Again, this is a tiny change, which doesn't matters a lot.

BTW, I don't get your point for "start inner loop at @cpu+1".

The original logic is:
	loop 1:   0 - nr_cpus
	loop 2:      0 - (cpu - 1)

If you found one better approach to improve the logic, I believe all the users
will appreciate your efforts :-)

Thanks for your review and comments again ~

>
>Thanks.
>
>-- 
>tejun

-- 
Richard Yang
Help you, Help me

