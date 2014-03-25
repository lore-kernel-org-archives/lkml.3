Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaCYVwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:52:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19156 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaCYVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:52:51 -0400
Message-ID: <5331FA9E.20506@oracle.com>
Date: Tue, 25 Mar 2014 17:52:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>, Tejun Heo <tj@kernel.org>
CC: Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
References: <5308E3AE.3040405@oracle.com>	<20140222205217.GC16272@mtj.dyndns.org> <20140224120427.6394d5dd@linux.lan.towertech.it>
In-Reply-To: <20140224120427.6394d5dd@linux.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 06:04 AM, Alessandro Zummo wrote:
> On Sat, 22 Feb 2014 15:52:17 -0500
> Tejun Heo <tj@kernel.org> wrote:
>
>> The problem is rtc_device_unregister().  It grabs rtc->ops_lock and
>> then tries to remove the sysfs files.  Some of those sysfs file
>> implementations acquire rtc->ops_lock, so it of course can lead to
>> deadlocks.  One can't try to delete a sysfs file which acquires a lock
>> while holding the same lock.
>
>   Pretty interesting indeed. One option would be to remove
>   the sys files before acquiring the lock. But I wonder
>   if this could lead to other issues.
>

Ping? Seems this thing got lost.


Thanks,
Sasha
