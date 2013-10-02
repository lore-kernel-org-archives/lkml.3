Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3JBQZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:25:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3JBQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:25:19 -0400
Date: Wed, 2 Oct 2013 09:25:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 16/26] mm: Provide get_user_pages_unlocked()
Message-ID: <20131002162519.GA9886@infradead.org>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-17-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380724087-13927-17-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:27:57PM +0200, Jan Kara wrote:
> Provide a wrapper for get_user_pages() which takes care of acquiring and
> releasing mmap_sem. Using this function reduces amount of places in
> which we deal with mmap_sem.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Seem like this should be the default one and the one without the locked
should be __unlocked.  Maybe a grand rename is in order?


get_user_pages_fast	-> get_user_pages
get_user_pages_unlocked	-> __get_user_pages
get_user_pages_unlocked	-> __get_user_pages_locked

steering people to the most sensible ones by default?

