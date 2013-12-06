Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab3LFT5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:57:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3LFT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:57:21 -0500
Date: Fri, 6 Dec 2013 11:57:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, clm@fb.com,
        viro@zeniv.linux.org.uk, zab@redhat.com, shaggy@kernel.org
Subject: Re: [PATCH 10/11] block: Add bio_get_user_pages()
Message-ID: <20131206195719.GA9872@infradead.org>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
 <1386108017-27964-11-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386108017-27964-11-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:00:16PM -0800, Kent Overstreet wrote:
> This replaces some of the code that was in __bio_map_user_iov(), and
> soon we're going to use this helper in the dio code.
> 
> Note that this relies on the recent change to make
> generic_make_request() take arbitrary sized bios - we're not using
> bio_add_page() here.

__bio_map_user_iov was using bio_add_pc_page anyway.  I might
misremember some of the earlier patches, but how do you do arbitrary
splitting of BLOCK_PC bios?  Given that they come with a SCSI CDB
attached I can't see how we could split them at all.

Also when you factor code out and change behaviour please always
try to do that in two separate patches so that it's easier reviewable.

