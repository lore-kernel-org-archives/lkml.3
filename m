Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaHAHFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:05:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56624 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaHAHE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:04:59 -0400
X-Greylist: delayed 1167 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2014 03:04:59 EDT
Date: Fri, 1 Aug 2014 07:45:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, suruchi <suruchi.a.kadu@intel.com>,
        ak <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for
 OLTP benchmark
Message-ID: <20140801064524.GL18016@ZenIV.linux.org.uk>
References: <1406584299.2970.924.camel@schen9-DESK>
 <20140729141908.GA4464@infradead.org>
 <1406651702.2970.927.camel@schen9-DESK>
 <20140729164951.GA23863@infradead.org>
 <1406678232.2970.943.camel@schen9-DESK>
 <20140730001248.GA32367@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730001248.GA32367@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 05:12:48PM -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 04:57:12PM -0700, Tim Chen wrote:
> > Christoph, we're glad to report that this patch does fix the problem.
> > Wonder if Al or someone can pick it up.  It is a large regression
> > that should not be left unfixed for 3.16.
> 
> Al has been away for a bit, and I prepared the last VFS pull.  I'll pick
> it up for now and either Al or I will send it on before next weekend.

Back now (and almost dug myself from under the huge mail pile - only ~1500
left to deal with, out of more than 30000 ;-/)

In addition to this fix there is "vfs: fix check for fallocate on active
swapfile".  There might be more in the pending pile, but so far that's
the only obvious missing bugfix.

Really big thanks for taking care of that mess while I'd been MIA (spent a lot
of time sick; I _hate_ the summer in NC, and this one had been particulary
lousy).  I'm trying to put together a queue for 3.17 right now; your
vfs-for-3.17 branch looks like a sane starting point.  Sigh...

Do you have anything else for 3.16 at the moment?  I've pushed these two
into vfs.git#for-linus; right now the stuff in there is

Shortlog:
Christoph Hellwig (1):
      direct-io: fix AIO regression

Eric Biggers (1):
      vfs: fix check for fallocate on active swapfile

Diffstat:
 fs/direct-io.c |    9 ++++-----
 fs/open.c      |    5 ++---
 2 files changed, 6 insertions(+), 8 deletions(-)

