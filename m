Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaDSJSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 05:18:04 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51034 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaDSJSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 05:18:02 -0400
Message-ID: <53523F41.2080601@gmail.com>
Date: Sat, 19 Apr 2014 11:17:53 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH] ipc/shm: Increase the defaults for SHMALL, SHMMAX to
 infinity
References: <1397812720-5629-1-git-send-email-manfred@colorfullife.com> <1397890512.19331.21.camel@buesod1.americas.hpqcorp.net> <535235DE.5080304@colorfullife.com>
In-Reply-To: <535235DE.5080304@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 10:37 AM, Manfred Spraul wrote:
> On 04/19/2014 08:55 AM, Davidlohr Bueso wrote:
>> On Fri, 2014-04-18 at 11:18 +0200, Manfred Spraul wrote:
>>> - ULONG_MAX is not really infinity, but 18 Exabyte segment size and
>>>    75 Zettabyte total size. This should be enough for the next few weeks.
>>>    (assuming a 64-bit system with 4k pages)
> Note: I found three integer overflows, none of them critical.
> I will send patches, I just must get a 32-bit test setup first.
>>> Risks:
>>> - The patch breaks installations that use "take current value and increase
>>>    it a bit". [seems to exist, http://marc.info/?l=linux-mm&m=139638334330127]
>> This really scares me. The probability of occurrence is now much higher,
>> and not just theoretical. It would legitimately break userspace.
> That's why I mentioned it.
> For shmmax, there is a simple answer: Use TASK_SIZE instead of ULONG_MAX.
> - sufficiently far away from overflow.
> - values beyond TASK_SIZE are useless anyway, you can't map such segments.
> 
> I don't have a good answer for shmall. 1L<<(BITS_PER_LONG-1) is too ugly.
> Any proposals?

If shmmax is TASK_SIZE, would not the existing
#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
suffice?


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
