Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3BDBDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:03:44 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62674 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3BDBDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:03:43 -0500
Message-ID: <1359939818.9366.1.camel@kernel.cn.ibm.com>
Subject: Re: [PATCHv4 0/7] zswap: compressed swap caching
From: Simon Jeons <simon.jeons@gmail.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Date: Sun, 03 Feb 2013 19:03:38 -0600
In-Reply-To: <510BDB8F.5000104@linux.vnet.ibm.com>
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1359682784.3574.2.camel@kernel> <510BDB8F.5000104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-01 at 09:13 -0600, Seth Jennings wrote:
> On 01/31/2013 07:39 PM, Simon Jeons wrote:
> > Hi Seth,
> > On Tue, 2013-01-29 at 15:40 -0600, Seth Jennings wrote:
> <snip>
> >> Performance, Kernel Building:
> >>
> >> Setup
> >> ========
> >> Gentoo w/ kernel v3.7-rc7
> >> Quad-core i5-2500 @ 3.3GHz
> >> 512MB DDR3 1600MHz (limited with mem=512m on boot)
> >> Filesystem and swap on 80GB HDD (about 58MB/s with hdparm -t)
> >> majflt are major page faults reported by the time command
> >> pswpin/out is the delta of pswpin/out from /proc/vmstat before and after
> >> then make -jN
> >>
> >> Summary
> >> ========
> >> * Zswap reduces I/O and improves performance at all swap pressure levels.
> >>
> >> * Under heavy swaping at 24 threads, zswap reduced I/O by 76%, saving
> >>   over 1.5GB of I/O, and cut runtime in half.
> > 
> > How to get your benchmark?
> 
> It's just kernel building.  So "make" :)
> 
> I intentionally choose this workload so people wouldn't have to jump
> through hoops to replicate the results.

Since there already have zram which can handle anonymous pages
compression, why need zswap? What's the difference of design between
zram and zswap? 

> 
> Seth
> 


