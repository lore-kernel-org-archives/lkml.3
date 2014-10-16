Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaJPM1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:27:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaJPM1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:27:42 -0400
Date: Thu, 16 Oct 2014 14:27:40 +0200
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Subject: IO request merging
Message-ID: <20141016122740.GI6085@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  one of our customers was complaining that elv_attempt_insert_merge()
merges two requests (via blk_attempt_req_merge()) without asking IO
scheduler for permission (->elevator_allow_merge_fn() callback). Now for
them this is a problem because of their custom IO scheduler but looking
into the code this can result in somewhat suboptimal behavior for CFQ as
well (merging two requests from different IO contexts, possibly merging
sync & async request). What do others think about this?

Regarding possible fix, we cannot really call ->elevator_allow_merge_fn()
because that assumes it is called from a context of a process submitting the
passed bio. So we would need to create a separate allow merge callback for
this.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
