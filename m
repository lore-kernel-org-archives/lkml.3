Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaDYN03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaDYN02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:26:28 -0400
Message-ID: <535A6263.10009@redhat.com>
Date: Fri, 25 Apr 2014 09:25:55 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Randy Dunlap <rdunlap@infradead.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, linux-next@vger.kernel.org
Subject: Re: mmotm 2014-04-24-13-07 uploaded
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com> <535992DD.3060808@infradead.org> <20140425024924.GR4496@linux.vnet.ibm.com>
In-Reply-To: <20140425024924.GR4496@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 10:49 PM, Paul E. McKenney wrote:
> On Thu, Apr 24, 2014 at 03:40:29PM -0700, Randy Dunlap wrote:
>> On 04/24/14 13:08, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2014-04-24-13-07 has been uploaded to
>>>
>>>    http://www.ozlabs.org/~akpm/mmotm/
>>>
>>> mmotm-readme.txt says
>>>
>>> README for mm-of-the-moment:
>>>
>>> http://www.ozlabs.org/~akpm/mmotm/
>>>
>>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>>> more than once a week.
>>>
>>> You will need quilt to apply these patches to the latest Linus release (3.x
>>> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
>>> http://ozlabs.org/~akpm/mmotm/series
>>>
>>
>> uml on x86_64 defconfig:
>>
>> drivers/built-in.o: In function `__handle_sysrq':
>> drivers/tty/sysrq.c:514: undefined reference to `rcu_sysrq_start'
>> drivers/tty/sysrq.c:558: undefined reference to `rcu_sysrq_end'
> 
> Hmmm...  Looks like Rik's patch needs declarations in rcupdate.h.
> Not sure how I missed that...  :-/

Looks like maybe sysrq.c should explicitly #include rcupdate.h.

On x86-64 the code compiled just fine, because something else
included rcupdate.h. Apparently on UML this breaks...

-- 
All rights reversed
