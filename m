Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaIGSuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:50:00 -0400
Received: from verein.lst.de ([213.95.11.211]:41976 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaIGSt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:49:59 -0400
Date: Sun, 7 Sep 2014 20:49:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Message-ID: <20140907184956.GB23026@lst.de>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This works fine for me, although I still don't really like it very much.

If you really want to go down the path of major surgery in this area we
should probably allocate a flush request per hw_ctx, and initialize it
using the normal init/exit functions.  If we want to have proper multiqueue
performance on devices needing flushes we'll need something like that anyway.
