Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3APRHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:07:43 -0500
Received: from mout.web.de ([212.227.15.4]:62633 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab3APRHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:07:40 -0500
Message-ID: <50F6DDF7.9080605@web.de>
Date: Wed, 16 Jan 2013 18:05:59 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ata: sata_mv: fix sg_tbl_pool alignment
References: <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com> <50F3F289.3090402@web.de> <20130115165642.GA25500@titan.lakedaemon.net> <20130115175020.GA3764@kroah.com> <20130115201617.GC25500@titan.lakedaemon.net> <20130115215602.GF25500@titan.lakedaemon.net> <50F5F1B7.3040201@web.de> <20130116024014.GH25500@titan.lakedaemon.net> <50F61D86.4020801@web.de> <50F66B1B.40301@web.de> <20130116155045.GI25500@titan.lakedaemon.net>
In-Reply-To: <20130116155045.GI25500@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:k0m/AqQjiXe9XalEc3K02tffxEggzBMp9v3de8wArVz
 QXSIkwPLYUP1XIZ9sLqh8ux2Q4QmMsCQ1WWb/VhreonseVbZDW
 YD0gQxEqG67rKW8FDBGffneVaiPxXW349GUe/O0piCUaaBKPwt
 wu2T46OBxcoOYn6jpZURFdcVbEysa07i7s0x9bfRvUMDWabjho
 9cWFBuqwAb6961b5ThB3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.01.2013 16:50, Jason Cooper wrote:
> On Wed, Jan 16, 2013 at 09:55:55AM +0100, Soeren Moch wrote:
>> On 16.01.2013 04:24, Soeren Moch wrote:
>>> On 16.01.2013 03:40, Jason Cooper wrote:
>>>> On Wed, Jan 16, 2013 at 01:17:59AM +0100, Soeren Moch wrote:
>>>>> On 15.01.2013 22:56, Jason Cooper wrote:
>>>>>> On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:
>
>> OK, I could trigger the error
>>    ERROR: 1024 KiB atomic DMA coherent pool is too small!
>>    Please increase it with coherent_pool= kernel parameter!
>> only with em28xx sticks and sata, dib0700 sticks removed.
>
> Did you test the reverse scenario?  ie dib0700 with sata_mv and no
> em28xx.

Maybe I can test this next night.

> What kind of throughput are you pushing to the sata disk?

Close to nothing. In the last test I had the root filesystem running
on the sata disk plus a few 10 megabytes per hour.

>>>> What would be most helpful is if you could do a git bisect between
>>>> v3.5.x (working) and the oldest version where you know it started
>>>> failing (v3.7.1 or earlier if you know it).
>>>>
>>> I did not bisect it, but Marek mentioned earlier that commit
>>> e9da6e9905e639b0f842a244bc770b48ad0523e9 in Linux v3.6-rc1 introduced
>>> new code for dma allocations. This is probably the root cause for the
>>> new (mis-)behavior (due to my tests 3.6.0 is not working anymore).
>>
>> I don't want to say that Mareks patch is wrong, probably it triggers a
>> bug somewhere else! (in em28xx?)
>
> Of the four drivers you listed, none are using dma.  sata_mv is the only
> one.

usb_core is doing the actual DMA for the usb bridge drivers, I think.

> If one is to believe the comments in sata_mv.c:~151, then the alignment
> is wrong for the sg_tbl_pool.
>
> Could you please try the following patch?

OK, what should I test first, the setup from last night (em28xx, no
dib0700) plus your patch, or the reverse setup (dib0700, no em28xx)
without your patch, or my normal setting (all dvb sticks) plus your
patch?

Regards,
Soeren

