Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3JXPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:23:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3JXPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:23:15 -0400
Message-Id: <20131024151921.537751910@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Oct 2013 08:19:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] RFC: __smp_call_function_single improvements
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is on top of the blk-mq series Jens just set out and changes
the generic IPI mechanism to be directly usable for block completions.

Besides always making __smp_call_function_single constantly available it
changes it to use a lockless list that avoids the overhead of disabling
irq and a lock every time it is called.
