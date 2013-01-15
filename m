Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3AORt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:49:27 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62107 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3AORt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:49:26 -0500
Date: Tue, 15 Jan 2013 09:50:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Soeren Moch <smoch@web.de>, Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20130115175020.GA3764@kroah.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
 <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
 <50F3F289.3090402@web.de>
 <20130115165642.GA25500@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115165642.GA25500@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:56:42AM -0500, Jason Cooper wrote:
> Greg,
> 
> I've added you to the this thread hoping for a little insight into USB
> drivers and their use of coherent and GFP_ATOMIC.  Am I barking up the
> wrong tree by looking a the drivers?

I don't understand, which drivers are you referring to?  USB host
controller drivers, or the "normal" drivers?  Most USB drivers use
GFP_ATOMIC if they are creating memory during their URB callback path,
as that is interrupt context.  But it shouldn't be all that bad, and the
USB core hasn't changed in a while, so something else must be causing
this.

greg k-h
