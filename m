Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaCNK7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:59:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaCNK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:59:08 -0400
Date: Fri, 14 Mar 2014 03:58:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140314105854.GA4077@infradead.org>
References: <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
 <20140314093458.GA19451@infradead.org>
 <5322D177.8050408@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5322D177.8050408@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:52:55AM +0100, Hannes Reinecke wrote:
> No, I haven't. This issue is only exhibited if you try to run
> multipath on a non-SCSI device (in this case it was cciss).
> But then that project got abandoned, and there never was a machine
> with a multipathed cciss controller.

We still shouldn't be able to easily crash the kernel because someone
configured the wrong device.  And with scsi-mq that wrong devices case
might become a lot more common..

