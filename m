Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161147Ab3LFWvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:51:42 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45885 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab3LFWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:51:40 -0500
MIME-Version: 1.0
In-Reply-To: <20131204130038.GY11295@suse.de>
References: <CAGVrzcZidrUV93x9t_BwPaDuzgxs-88HoF-HUDRrSEYcfJB_rw@mail.gmail.com>
 <20131204130038.GY11295@suse.de>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 6 Dec 2013 14:51:00 -0800
Message-ID: <CAGVrzcYMSVX=xkVqROjouvHpVup+jO00Wb66h2Wd=LFX47rDiw@mail.gmail.com>
Subject: Re: high kswapd CPU usage when executing binaries from NFS w/ CMA and COMPACTION
To: Mel Gorman <mgorman@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mhocko <mhocko@suse.cz>, hannes <hannes@cmpxchg.org>,
        riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "m.szyprowski" <m.szyprowski@samsung.com>,
        "marc.ceeeee" <marc.ceeeee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/4 Mel Gorman <mgorman@suse.de>:
> On Tue, Dec 03, 2013 at 06:30:28PM -0800, Florian Fainelli wrote:
>> Hi all,
>>
>> I am experiencing high kswapd CPU usage on an ARMv7 system running
>> 3.8.13 when executing relatively large binaries from NFS. When this
>> happens kswapd consumes around 55-60% CPU usage and the applications
>> takes a huge time to load.
>>
>
> There were a number of changes made related to how and when kswapd
> stalls, particularly when pages are dirty. Brief check confirms that
>
> git log v3.8..v3.12 --pretty=one --author "Mel Gorman" mm/vmscan.c
>
> NFS dirty pages are problematic for compaction as dirty pages cannot be
> migrated until cleaned. I'd suggest checking if current mainline suffers
> the same problem and if not, focus on patches related to dirty page
> handling and kswapd throttling in mm/vmscan.c as backport candidates.

I have just backported these patches to 3.8.13 and am still seeing the
problem, although kswapd usage dropped considerably (by half
approximately). Will keep you updated once I have properly tested
current mainline on my platform. Thanks!
-- 
Florian
