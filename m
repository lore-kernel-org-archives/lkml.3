Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaDSIpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 04:45:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45426 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDSIpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 04:45:36 -0400
Message-ID: <535237AA.7080000@colorfullife.com>
Date: Sat, 19 Apr 2014 10:45:30 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com, Davidlohr Bueso <davidlohr@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] ipc/shm: Increase the defaults for SHMALL, SHMMAX to
 infinity
References: <1397812720-5629-1-git-send-email-manfred@colorfullife.com> <1397890512.19331.21.camel@buesod1.americas.hpqcorp.net> <CAKgNAkgMrWhSky8Cys2gxiS_s0=ya=wi=R5ehuT0bdjEBpDgdg@mail.gmail.com>
In-Reply-To: <CAKgNAkgMrWhSky8Cys2gxiS_s0=ya=wi=R5ehuT0bdjEBpDgdg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 09:10 AM, Michael Kerrisk (man-pages) wrote:
> On Sat, Apr 19, 2014 at 8:55 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> On Fri, 2014-04-18 at 11:18 +0200, Manfred Spraul wrote:
>>> Risks:
>>> - The patch breaks installations that use "take current value and increase
>>>    it a bit". [seems to exist, http://marc.info/?l=linux-mm&m=139638334330127]
>> This really scares me. The probability of occurrence is now much higher,
>> and not just theoretical. It would legitimately break userspace.
> I'm missing something. Manfred's patch doesn't actually change the
> behavior on this point does it? If the problem is more than
> theoretical, then it _already_ affects users, right? (And they would
> therefore already be working around the problem.)
The current default is 32 MB. if some increases it by 1 MB, then the 
result is 33 MB.
The new default would be ULONG_MAX. If someone increases it by 1 MB, 
then the result is 1 MB - 1 byte.

--
     Manfred
