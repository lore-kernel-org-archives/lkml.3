Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab3APWha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:37:30 -0500
Received: from mout.web.de ([212.227.15.4]:50821 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880Ab3APWh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:37:28 -0500
Message-ID: <50F72B73.5070504@web.de>
Date: Wed, 16 Jan 2013 23:36:35 +0100
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
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent()
 calls
References: <50F3F289.3090402@web.de> <20130115165642.GA25500@titan.lakedaemon.net> <20130115175020.GA3764@kroah.com> <20130115201617.GC25500@titan.lakedaemon.net> <20130115215602.GF25500@titan.lakedaemon.net> <50F5F1B7.3040201@web.de> <20130116024014.GH25500@titan.lakedaemon.net> <50F61D86.4020801@web.de> <50F66B1B.40301@web.de> <50F6E419.5080007@web.de> <20130116174736.GJ25500@titan.lakedaemon.net>
In-Reply-To: <20130116174736.GJ25500@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:c/GZB1m+7RRzV4zDAIDy+G0smUGqfufSdvqrIHT9ZTy
 lSJoyo+EsZNrL72/NgoWsOWoDStQVB7k7N9sLxG0PswTB8Z8TT
 ccOSsTQzSpvUM8XQSDmdhl9x7/6WtmBeqmtJA/FFVm3oeuvn1+
 NeFORQwindOuz+FF5lTrpIonVLYLnZInvN9I3W7wwcRQHcYJzC
 +OXyzPMZF695KuWp7vvmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.01.2013 18:47, Jason Cooper wrote:
> On Wed, Jan 16, 2013 at 06:32:09PM +0100, Soeren Moch wrote:
>> On 16.01.2013 09:55, Soeren Moch wrote:
>>> On 16.01.2013 04:24, Soeren Moch wrote:
>>>> I did not bisect it, but Marek mentioned earlier that commit
>>>> e9da6e9905e639b0f842a244bc770b48ad0523e9 in Linux v3.6-rc1 introduced
>>>> new code for dma allocations. This is probably the root cause for the
>>>> new (mis-)behavior (due to my tests 3.6.0 is not working anymore).
>>>
>>> I don't want to say that Mareks patch is wrong, probably it triggers a
>>> bug somewhere else! (in em28xx?)
>>
>> The em28xx sticks are using isochronous usb transfers. Is there a
>> special handling for that?
>
> I'm looking at that now.  It looks like the em28xx wants (as a maximum)
> 655040 bytes (em28xx-core.c:1088).  There are 5 transfer buffers, with
> 64 max packets and 2047 max packet size (runtime reported max & 0x7ff).
>
> If it actually needs all of that, then the answer may be to just
> increase coherent_pool= when using that driver.  I'll keep digging.

I already tested with 4M coherent pool size and could not see
significant improvement. Would it make sense to further increase the
buffer size?

Regards,
Soeren



