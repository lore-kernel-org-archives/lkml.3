Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaDKHp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:45:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbaDKHp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:45:28 -0400
Date: Fri, 11 Apr 2014 00:45:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] FS: Add generic data flush to fsync
Message-ID: <20140411074522.GA15518@infradead.org>
References: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411065242.42916952dd5d8e4e53848b3b@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 06:52:42AM +0200, Fabian Frederick wrote:
> Currently, there's no generic HW flush management support in kernel.
> Only 7 filesystems have their own way to manage the barrier flag.
> 
> This patch adds MS_BARRIER in sb_flags and conditionnaly issues the flush
> in generic_file_fsync.

Please don't add a binary mount option for something thast already is a
text option in many filesystems.  We can actually enable/disable cache
flushes at the block device level, so I think this can be
unconditional.
