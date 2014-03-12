Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaCLLAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:00:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaCLLAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:00:21 -0400
Date: Wed, 12 Mar 2014 04:00:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org
Subject: SuSE O_DIRECT|O_NONBLOCK overload
Message-ID: <20140312110015.GA29907@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <53203BE5.402@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53203BE5.402@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SLES12 tree has various patches to implement special
O_DIRECT|O_NONBLOCK semantics for block devices:

	https://gitorious.org/opensuse/kernel-source/source/806eab3e4b02e798c1ae942440051f81c822ca35:patches.suse/block-nonblock-causes-failfast

this seems genuinely useful and I'd be really happy if people would do
this work upstream for two reasons:

 a) implementing different semantics only in a vendor kernel is a
    nightmare.  No proper way to document it in the man pages for
    example, and silent breakage of applications that expect it to be
    present, or even more nasty not present.
 b) Which brings us to: we had various issues with adding O_NONBLOCK to
    files that didn't support it before.  How well was this whole feature
    tested?

