Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab3KOOLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:11:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:57208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3KOOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:11:03 -0500
Date: Fri, 15 Nov 2013 06:11:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com,
        linux-mtd@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] list: introduce list_last_entry_or_null()
Message-ID: <20131115141100.GA17659@infradead.org>
References: <5285A33C.4040808@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5285A33C.4040808@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:29:48PM +0800, Jeff Liu wrote:
> Hi Folks,
> 
> This patch is trying to introduce a new list helper to retrieve the
> last entry or return NULL if the list is empty corresponding to it,
> which is inspired by Jiri Pirko's list_first_entry_or_null().

How did we end up with the stupid _or_null prefix there?  I think the
functionality is useful, but the naming is way to verbose, especially
given that a list_first_entry or list_last_entry that optimizes away
that one check doesn't seem useful.

Instead of encoding detailed semantics in the name a good kerneldoc
comment is way better.
