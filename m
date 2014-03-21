Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbaCUPh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:37:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaCUPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:37:54 -0400
Date: Fri, 21 Mar 2014 08:37:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
Message-ID: <20140321153749.GA17155@infradead.org>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
 <1395383538-18019-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395383538-18019-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious:  why do you think implementing this as a block remapper
inside device mapper is a better idea than as a blk-mq driver?

At the request layer you already get a lot of infrastucture for all the
queueing infrastructure for free, as well as all kinds of other helpers.
And the driver never remaps bios anyway but always submits new ones as
far as I can tell.

Does it even make sense to expose the underlying devices as block
devices?  It surely would help to send this together with a driver
that you plan to use it on top of.

