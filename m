Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3IISHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:07:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53929 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3IISHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:07:23 -0400
Date: Mon, 9 Sep 2013 19:07:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130909180720.GP13318@ZenIV.linux.org.uk>
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com>
 <1378743493-33546-2-git-send-email-Waiman.Long@hp.com>
 <20130909172905.GN13318@ZenIV.linux.org.uk>
 <522E0B7A.2080401@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522E0B7A.2080401@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:55:06PM -0400, Waiman Long wrote:

> >I'm not sure I like mixing rcu_read_lock() into that - d_path() and friends
> >can do that themselves just fine (it needs to be taken when seq is even),
> >and e.g. d_walk() doesn't need it at all.  Other than that, I'm OK with
> >this variant.
> 
> I think rcu_read_lock() is needed to make sure that the dentry won't
> be freed as we don't take d_lock now.

Sure, you do need that; the question is whether you need to take it in
the primitives you are introducing.
