Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030759Ab3HITJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:09:40 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31399 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030717Ab3HITJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:09:39 -0400
Date: Fri, 9 Aug 2013 14:09:34 -0500
From: scameron@beardog.cce.hp.com
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@kernel.dk, tj@kernel.org, scameron@beardog.cce.hp.com
Subject: Question about REQ_FLUSH and bios with data
Message-ID: <20130809190934.GL9905@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, I'm working on a block driver using the make_request_fn
interface, and have to handle a bio that comes in with
(bi_rw & REQ_FLUSH) set AND data to transfer. 

According to Documentation/block/writeback_cache_control.txt:

	The REQ_FLUSH flag can be OR ed into the r/w flags of a
	bio submitted from the filesystem and will make sure the
	volatile cache of the storage device has been flushed
	before the actual I/O operation is started. 

So I've written code that handles that case, along with the
various error cases I might encounter, I think, which leads
to my question:

How do I get such a bio with a data transfer AND the REQ_FLUSH bit
set to come into the driver?   Just wondering how to test this case.

Thanks,

(I cc'ed Tejun Heo just because his name is in block/blk-flush.c)

-- steve

