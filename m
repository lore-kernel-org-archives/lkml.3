Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaDRRvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:51:10 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56767 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaDRRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:51:08 -0400
Message-ID: <53516608.8090409@colorfullife.com>
Date: Fri, 18 Apr 2014 19:51:04 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net> <5350EFAA.2030607@colorfullife.com> <CAKgNAkhY94Y5Nut9+Jj1gcnio81CEmE5sQL_gH_zFnHD-yNx2Q@mail.gmail.com>
In-Reply-To: <CAKgNAkhY94Y5Nut9+Jj1gcnio81CEmE5sQL_gH_zFnHD-yNx2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 05:36 PM, Michael Kerrisk (man-pages) wrote:
> On Fri, Apr 18, 2014 at 11:26 AM, Manfred Spraul
> <manfred@colorfullife.com> wrote:
>> Obviously my patch has the opposite problem: 64-bit wrap-arounds.
> I know you alluded to a case in another thread, but I couldn't quite
> work out from the mail you referred to whether this was really the
> problem. (And I assume those folks were forced to fix their set-up
> scripts anyway.) So, it's not clear to me whether this is a real
> problem. (And your patch does not worsen things from the current
> situation, right?)
a) When I wrote the comment it was just an idea.
But now I think wrap-around could be an issue, e.g. 
find_vma_intersection(,addr,addr+ULONG_MAX) always returns false, even 
if there are vmas inbetween.

b) If we make ULONG_MAX the default, then it should work.

--
     Manfred
