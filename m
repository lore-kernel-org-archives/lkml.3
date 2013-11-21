Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3KURfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:35:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KURff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:35:35 -0500
Date: Thu, 21 Nov 2013 09:35:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [RFC PATCH v2 1/5] locks: consolidate checks for compatible
 filp->f_mode values in setlk handlers
Message-ID: <20131121173534.GA12032@infradead.org>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
 <1384965906-27327-2-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384965906-27327-2-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:45:02AM -0500, Jeff Layton wrote:
> Add a wrapper around assign_type that does this instead of duplicating
> this check in two places. This also fixes a minor wart in the code where
> we continue referring to the struct flock after converting it to struct
> file_lock.

I don't think posix_assign_type is a good name for this helper, but
as Bruce already pointed out more work is required in that area anyway.

