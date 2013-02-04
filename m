Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3BDPII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:08:08 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33733 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab3BDPIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:08:06 -0500
Message-ID: <510FCECC.6020703@linux.vnet.ibm.com>
Date: Mon, 04 Feb 2013 09:07:56 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv4 0/7] zswap: compressed swap caching
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359682784.3574.2.camel@kernel> <510BDB8F.5000104@linux.vnet.ibm.com> <1359939818.9366.1.camel@kernel.cn.ibm.com>
In-Reply-To: <1359939818.9366.1.camel@kernel.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020415-7182-0000-0000-000004EA9E54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 07:03 PM, Simon Jeons wrote:
> On Fri, 2013-02-01 at 09:13 -0600, Seth Jennings wrote:
>> On 01/31/2013 07:39 PM, Simon Jeons wrote:
>>> Hi Seth,
>>> On Tue, 2013-01-29 at 15:40 -0600, Seth Jennings wrote:
>> <snip>
>>>> Performance, Kernel Building:
>>>>
>>>> Setup
>>>> ========
>>>> Gentoo w/ kernel v3.7-rc7
>>>> Quad-core i5-2500 @ 3.3GHz
>>>> 512MB DDR3 1600MHz (limited with mem=512m on boot)
>>>> Filesystem and swap on 80GB HDD (about 58MB/s with hdparm -t)
>>>> majflt are major page faults reported by the time command
>>>> pswpin/out is the delta of pswpin/out from /proc/vmstat before and after
>>>> then make -jN
>>>>
>>>> Summary
>>>> ========
>>>> * Zswap reduces I/O and improves performance at all swap pressure levels.
>>>>
>>>> * Under heavy swaping at 24 threads, zswap reduced I/O by 76%, saving
>>>>   over 1.5GB of I/O, and cut runtime in half.
>>>
>>> How to get your benchmark?
>>
>> It's just kernel building.  So "make" :)
>>
>> I intentionally choose this workload so people wouldn't have to jump
>> through hoops to replicate the results.
> 
> Since there already have zram which can handle anonymous pages
> compression, why need zswap? What's the difference of design between
> zram and zswap? 

zram is implemented is a virtual block device.  It interfaces with the
block device layer, not the swap code.  In fact, zram can be used as a
generic compressed RAM disk, not only for compressed swap.  One can
think of it as a RAM disk + compression.

So zram is the actual swap device while zswap is a caching layer above
the swap device.  zswap is not the swap device itself like zram.

Hope this clears up the difference :)

Seth

