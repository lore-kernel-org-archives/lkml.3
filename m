Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaKMNFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:05:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41607 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaKMNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:05:15 -0500
Date: Thu, 13 Nov 2014 13:05:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix thinko in iov_iter_single_seg_count
Message-ID: <20141113130509.GI7996@ZenIV.linux.org.uk>
References: <20141113091523.GC26910@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113091523.GC26910@iris.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 08:15:23PM +1100, Paul Mackerras wrote:
> The branches of the if (i->type & ITER_BVEC) statement in
> iov_iter_single_seg_count() are the wrong way around; if ITER_BVEC is
> clear then we use i->bvec, when we should be using i->iov.  This fixes
> it.
> 
> In my case, the symptom that this caused was that a KVM guest doing
> filesystem operations on a virtual disk would result in one of qemu's
> threads on the host going into an infinite loop in
> generic_perform_write().  The loop would hit the copied == 0 case and
> call iov_iter_single_seg_count() to reduce the number of bytes to try
> to process, but because of the error, iov_iter_single_seg_count()
> would just return i->count and the loop made no progress and continued
> forever.

ACK.  Applied, will push today.
