Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaDNHWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:22:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaDNHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:22:44 -0400
Date: Mon, 14 Apr 2014 00:22:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: Christoph Hellwig <hch@infradead.org>, Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] FS: Add generic data flush to fsync
Message-ID: <20140414072242.GE7860@infradead.org>
References: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
 <20140411074522.GA15518@infradead.org>
 <20140411230530.984a9d57b3dec487af936d29@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411230530.984a9d57b3dec487af936d29@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 11:05:30PM +0200, Fabian Frederick wrote:
> Ok, that would mean 'older' filesystems -without barrier flag-
> to call generic_file_fsync would result in a flush but ext4 without journal 
> also calls it ; maybe with nobarrier and I'm not sure it's the only case.
> How can I deal with this problem ?

I don't really think not implementing the barrier option is a problem.
For ext4 if you want consistency either opencode generic_file_fsync
there and add the check, or add a __generic_file_fsync that doesn't
do the flush.
