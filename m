Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3D0ByM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 21:54:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab3D0ByK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 21:54:10 -0400
Message-ID: <517B2FB4.30605@redhat.com>
Date: Fri, 26 Apr 2013 21:53:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
CC: hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, sonnyrao@chromium.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
References: <517B1153.8000401@valvesoftware.com>
In-Reply-To: <517B1153.8000401@valvesoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 07:44 PM, Pierre-Loup A. Griffais wrote:
> I initially observed this between kernels 3.2 and 3.5: on 3.2, copying a
> 180M shared object on the same ext4 filesystem takes 0.6s. On 3.5, it
> takes between two and three minutes. It looks like a similar throughput
> regression happens on any machine running an i386 PAE kernel with high
> amounts of memory; the threshold seems to be 16G; passing mem=15G to the
> kernel commandline fixes it.

If you have that much memory in the system, you will
want to run a 64 bit kernel to avoid all kinds of
memory management corner cases.

> I bisected it to the following change:
>
> commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d
> Author: Johannes Weiner <jweiner@redhat.com>
> Date:   Tue Jan 10 15:07:42 2012 -0800
>
>      mm: exclude reserved pages from dirtyable memory
>
> I realize running x86 kernels against high amounts of memory is not
> advised for various reasons, but I would assume that such a big
> regression in basic functionality to not be part of them. Is that
> accurate, or are these configurations expected to become unusable from
> 3.3 onwards?

Reverting that patch would probably break i686 PAE systems with
lots of memory at a different threshold.

With more than 8-12GB of memory, an i686 kernel is between a
rock and a hard place. Whether you move it closer to the rock,
or closer to the hard place, all you do is change the way in
which it breaks.

> Also CCing Sonny since it looks like he tried to fix an overflow issue
> related to the same change with commit c8b74c2f66049, but I'm still
> experiencing the problem with a kernel built from master.
>
> Thanks,
>   - Pierre-Loup


-- 
All rights reversed
