Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbaIOVPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:15:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaIOVP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:15:27 -0400
Date: Mon, 15 Sep 2014 14:15:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/7] Prepare for adding a new readv/writev with user
 flags.
Message-ID: <20140915211523.GA5481@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <e434e839351324641e10cc0a309a5c5f86e196c5.1410810247.git.milosz@adfin.com>
 <20140915202828.GV7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915202828.GV7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:28:28PM +0100, Al Viro wrote:
> On Mon, Sep 15, 2014 at 04:20:17PM -0400, Milosz Tanski wrote:
> > Plumbing the flags argument through the vfs code so they can be passed down to
> > __generic_file_(read/write)_iter function that do the acctual work.
> 
> NAK.  Put these flags into iocb, it'll be less noisy that way.

Fine with me.  My initial prototype had it in the iov_iter type field
which is another possibility.

But if we get rid of the explicit flags field and make it more invisible
I'd really like to add a features field struct file_operations where
instances can advertize that they support it (and other things like
actual AIO support in the future) so that we won't have a situation
like with AIO where we can submit I/O but it might actually still block
anyway because lots of operations don't support it.
