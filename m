Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbbAYOzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:55:22 -0500
Received: from mail.efficios.com ([78.47.125.74]:45082 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbbAYOzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:55:15 -0500
Date: Sun, 25 Jan 2015 14:55:18 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        lttng-dev <lttng-dev@lists.lttng.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <8237170.50348.1422197718126.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141027184809.GW11522@wil.cx>
References: <1254279794.1957.1414240389301.JavaMail.zimbra@efficios.com> <465653369.1985.1414241485934.JavaMail.zimbra@efficios.com> <20141027184809.GW11522@wil.cx>
Subject: Re: Progress on system crash traces with LTTng using DAX and pmem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.222.176.50]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF35 (Linux)/8.0.7_GA_6021)
Thread-Topic: Progress on system crash traces with LTTng using DAX and pmem
Thread-Index: OVW1XsyfXhSfvC7LkuztGPTCwO7Orw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <willy@linux.intel.com>, "Ross Zwisler" <ross.zwisler@linux.intel.com>, "lttng-dev"
> <lttng-dev@lists.lttng.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Sent: Monday, October 27, 2014 2:48:09 PM
> Subject: Re: Progress on system crash traces with LTTng using DAX and pmem
> 
> On Sat, Oct 25, 2014 at 12:51:25PM +0000, Mathieu Desnoyers wrote:
> > A quick follow up on my progress on using DAX and pmem with
> > LTTng. I've been able to successfully gather a user-space
> > trace into buffers mmap'd into an ext4 filesystem within
> > a pmem block device mounted with -o dax to bypass the page
> > cache. After a soft reboot, I'm able to mount the partition
> > again, and gather the very last data collected in the buffers
> > by the applications. I created a "lttng-crash" program that
> > extracts data from those buffers and converts the content
> > into a readable Common Trace Format trace. So I guess
> > you have a use-case for your patchsets on commodity hardware
> > right there. :)
> 
> Sweet!
> 
> > I've been asked by my customers if DAX would work well with
> > mtd-ram, which they are using. To you foresee any roadblock
> > with this approach ?
> 
> Looks like we'd need to add support to mtd-blkdevs.c for DAX.  I assume
> they're already using one of the block-based ways to expose MTD to
> filesystems, rather than jffs2/logfs/ubifs?
> 
> I'm thinking we might want to add a flag somewhere in the block_dev / bdi
> that indicates whether DAX is supported.  Currently we rely on whether
> ->direct_access is present in the block_device_operations to indicate
> that, so we'd have to have two block_dev_operations in mtd-blkdevs,
> depending on whether direct access is supported by the underlying
> MTD device.  Not a show-stopper.
> 
> > Please keep me in CC on your next patch versions. I'm willing
> > to spend some more time reviewing them if needed. By the way,
> > do you guys have a target time-frame/kernel version you aim
> > at for getting this work upstream ?
> 
> We're trying to get it upstream ASAP.  We've been working on it
> publically since December last year, and it's getting frustrating that
> it's not upstream already.  I sent a v12 a few minutes before you sent
> this message ...  I thought git would add you to the cc's since your
> Reviewed-by is on some of the patches.

Hi Matthew,

I've noticed that Andrew Morton picked up your DAX patchset, which is
really good news!

About the topic of DAX support on mtd-ram: I'm wonder if we would
need the pmem patchset at all if mtd-ram gets DAX support ? How
do the two approaches differ ? Has anyone tried out mtd-ram over
DAX at this point ?

Thanks for the great work! :)

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
