Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaCKMyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:54:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:54599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbaCKMx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="470174521"
Date: Tue, 11 Mar 2014 08:53:57 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 06/22] Replace XIP read and write with DAX I/O
Message-ID: <20140311125357.GA7580@linux.intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
 <1393337918-28265-7-git-send-email-matthew.r.wilcox@intel.com>
 <1394497958.6784.204.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394497958.6784.204.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 06:32:38PM -0600, Toshi Kani wrote:
> On Tue, 2014-02-25 at 09:18 -0500, Matthew Wilcox wrote:
> > Use the generic AIO infrastructure instead of custom read and write
> > methods.  In addition to giving us support for AIO, this adds the missing
> > locking between read() and truncate().
> > 
>  :
> > +static void dax_new_buf(void *addr, unsigned size, unsigned first,
> > +					loff_t offset, loff_t end, int rw)
> > +{
> > +	loff_t final = end - offset;	/* The final byte in this buffer */
> 
> I may be missing something, but shouldn't it take first into account?
> 
> 	loff_t final = end - offset + first;

Yes it should.  Thanks!  (Fortunately, this is only a performance problem
as we'll end up zeroing more than we ought to, which is fine as it will
be overwritten by the copy_from_user later)

