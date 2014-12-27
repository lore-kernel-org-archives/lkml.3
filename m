Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaL0PCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:02:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaL0PCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:02:11 -0500
Date: Sat, 27 Dec 2014 07:02:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>,
        Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [RFC PATCH 01/17] block: make generic_make_request handle
 arbitrarily sized bios
Message-ID: <20141227150207.GC1094@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <20141223101614.GA13138@infradead.org>
 <20141223114140.GB15080@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223114140.GB15080@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 12:41:40PM +0100, Dongsu Park wrote:
> You mean, checking rq->cmd_type == REQ_TYPE_BLOCK_PC, right?
> 
> I'm wondering about how to check that in blk_queue_split().
> At the moment when blk_queue_split() is called, it's even before a request
> is mapped e.g. in blk_sq_make_request().
> Unlike scsi drivers where it's easy to get cmd->rq, blk_queue_split()
> doesn't seem to be able to get a request by blk_get_request().
> 
> Or am I missing something?

You're probably missing what I didn't notice either: BLOCK_PC requests
are never sent through ->make_request.  Consider my comment withdrawn
and sorry for the confusion.
