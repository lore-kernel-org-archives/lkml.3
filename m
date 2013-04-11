Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3DKUFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:05:22 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36660 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3DKUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:05:20 -0400
Date: Thu, 11 Apr 2013 13:05:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 02/10] staging: zcache: remove zcache_freeze
Message-ID: <20130411200518.GA5268@kroah.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1365553560-32258-3-git-send-email-liwanp@linux.vnet.ibm.com>
 <ecb7519b-669a-48e4-b217-a77ecb60afd4@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecb7519b-669a-48e4-b217-a77ecb60afd4@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:13:42AM -0700, Dan Magenheimer wrote:
> > From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> > Subject: [PATCH 02/10] staging: zcache: remove zcache_freeze
> > 
> > The default value of zcache_freeze is false and it won't be modified by
> > other codes. Remove zcache_freeze since no routine can disable zcache
> > during system running.
> > 
> > Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> 
> I'd prefer to leave this code in place as it may be very useful
> if/when zcache becomes more tightly integrated into the MM subsystem
> and the rest of the kernel.  And the subtleties for temporarily disabling
> zcache (which is what zcache_freeze does) are non-obvious and
> may cause data loss so if someone wants to add this functionality
> back in later and don't have this piece of code, it may take
> a lot of pain to get it working.
> 
> Usage example: All CPUs are fully saturated so it is questionable
> whether spending CPU cycles for compression is wise.  Kernel
> could disable zcache using zcache_freeze.  (Yes, a new entry point
> would need to be added to enable/disable zcache_freeze.)
> 
> My two cents... others are welcome to override.

I will not override, and did not take this patch.

greg k-h
