Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaCTJCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:02:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:42797 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:02:08 -0400
Message-ID: <532AAE7B.2030501@parallels.com>
Date: Thu, 20 Mar 2014 13:01:47 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
        <john.stultz@linaro.org>, Greg Kroah-Hartman <greg@kroah.com>,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 3/6] shm: add memfd_create() syscall
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com> <1395256011-2423-4-git-send-email-dh.herrmann@gmail.com> <20140320084748.GK1728@moon>
In-Reply-To: <20140320084748.GK1728@moon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 12:47 PM, Cyrill Gorcunov wrote:
> On Wed, Mar 19, 2014 at 08:06:48PM +0100, David Herrmann wrote:
>> memfd_create() is similar to mmap(MAP_ANON), but returns a file-descriptor
>> that you can pass to mmap(). It explicitly allows sealing and
>> avoids any connection to user-visible mount-points. Thus, it's not
>> subject to quotas on mounted file-systems, but can be used like
>> malloc()'ed memory, but with a file-descriptor to it.
>>
>> memfd_create() does not create a front-FD, but instead returns the raw
>> shmem file, so calls like ftruncate() can be used. Also calls like fstat()
>> will return proper information and mark the file as regular file. Sealing
>> is explicitly supported on memfds.
>>
>> Compared to O_TMPFILE, it does not require a tmpfs mount-point and is not
>> subject to quotas and alike.
> 
> If I'm not mistaken in something obvious, this looks similar to /proc/pid/map_files
> feature, Pavel?

Thanks, Cyrill.

It is, but the map_files will work "in the opposite direction" :) In the memfd
case one first gets an FD, then mmap()s it; in the /proc/pis/map_files case one
should first mmap() a region, then open it via /proc/self/map_files.

But I don't know whether this matters.

Thanks,
Pavel
