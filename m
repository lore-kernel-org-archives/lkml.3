Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaKKHe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:34:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:57875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaKKHe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:34:27 -0500
Date: Mon, 10 Nov 2014 23:34:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Eric Paris <eparis@parisplace.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ftruncate, truncate: create fanotify events
Message-ID: <20141111073415.GA21776@infradead.org>
References: <20141007192330.GE30038@quack.suse.cz>
 <1414100107-3750-1-git-send-email-xypron.glpk@gmx.de>
 <20141110203029.GA8125@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110203029.GA8125@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:30:29PM +0100, Jan Kara wrote:
>   So what I somewhat dislike about this patch is that notify_change() is
> sometimes called with dentry and sometimes with path. That way it's not
> completely clear when fanotify events will be generated and when not.
> Sadly it isn't easy to provide struct path in all the places where we are
> calling notify_change() so I'm not sure what would a better solution look
> like either :(

I suspect the right thing to do is to split out the truncate path
from notify_change, as it's fairly different anyway.
