Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaG3AMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:12:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaG3AMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:12:51 -0400
Date: Tue, 29 Jul 2014 17:12:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        suruchi <suruchi.a.kadu@intel.com>, ak <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for
 OLTP benchmark
Message-ID: <20140730001248.GA32367@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
 <20140729141908.GA4464@infradead.org>
 <1406651702.2970.927.camel@schen9-DESK>
 <20140729164951.GA23863@infradead.org>
 <1406678232.2970.943.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406678232.2970.943.camel@schen9-DESK>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:57:12PM -0700, Tim Chen wrote:
> Christoph, we're glad to report that this patch does fix the problem.
> Wonder if Al or someone can pick it up.  It is a large regression
> that should not be left unfixed for 3.16.

Al has been away for a bit, and I prepared the last VFS pull.  I'll pick
it up for now and either Al or I will send it on before next weekend.

Can I get a tested-by tag from you for the patch?  Can anyone else
please cross check it?  The new total value might be different from
the old size value when we do a short write, but I can't see how
an async write would be a good thing if we had to finish the remainder
using buffered I/O if the old code really allowed that.

