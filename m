Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaDVEXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:23:38 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:32973 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaDVEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:23:34 -0400
Message-ID: <5355EEC2.4010304@colorfullife.com>
Date: Tue, 22 Apr 2014 06:23:30 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] ipc/shm.c: increase the limits for SHMMAX, SHMALL
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com> <1398101106.2623.6.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1398101106.2623.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 07:25 PM, Davidlohr Bueso wrote:
> On Mon, 2014-04-21 at 16:26 +0200, Manfred Spraul wrote:
>> Hi all,
>>
>> the increase of SHMMAX/SHMALL is now a 4 patch series.
>> I don't have ideas how to improve it further.
> Manfred, is there any difference between this set and the one you sent a
> couple of days ago?
a) I updated the comments.
b) the initial set used TASK_SIZE, not I switch to ULONG_MAX-(1L<<24)

>>    - Using "0" as a magic value for infinity is even worse, because
>>      right now 0 means 0, i.e. fail all allocations.
> Sorry but I don't quite get this. Using 0 eliminates the need for all
> these patches, no? I mean overflows have existed since forever, and
> taking this route would naturally solve the problem. 0 allocations are a
> no no anyways.
No. The patches are required to handle e.g. shmget(,ULONG_MAX,):
Right now, shmget(,ULONG_MAX,) results in a 0-byte segment.

The risk of using 0 is that it reverses the current behavior:
Up to now,
     # sysctl kernel.shmall=0
disables allocations.
If we define 0 a infinity, then the same configuration would allow 
unlimited allocations.

--
     Manfred
