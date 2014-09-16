Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaIPKHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:07:32 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:49500 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaIPKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:07:30 -0400
Date: Tue, 16 Sep 2014 12:07:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, hpa@linux.intel.com, ak@linux.intel.com,
        Alex Chiang <achiang@hp.com>, Borislav Petkov <bp@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916100725.GB4796@osiris>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <5417F228.9060301@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5417F228.9060301@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091610-8372-0000-0000-00000130E06B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 01:17:44AM -0700, Dave Hansen wrote:
> >> The sysfs effects here cause an issue with the hwloc tool where
> >> it gets confused and thinks there are more sockets than are
> >> physically present.
> > 
> > Meh, so then we need another mask.
> 
> s390 has this concept of a "book" although it's not obvious at all where
> this fits in to the hierarchy to me.  The help text and comments are
> pretty funny:
> 
> 	Book scheduler support improves the CPU scheduler's decision
> 	making when dealing with machines that have several books.
> 
> Wow, really?  Book scheduling helps with books?  I would have never
> guessed.

I'm glad the help text did enlighten you.

>  Wish I knew what a book was. :)  Google helped a bit:
> 	http://sysmagazine.com/posts/150430/
> but it's still not clear.  I think a book is below a node?
> 
> 	SMT <= LLC <= MC <= BOOK <= NODE

This one is correct. s390 does not have NUMA support. So we have one
node with multiple books.

