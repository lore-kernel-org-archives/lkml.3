Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaBWViZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:38:25 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:40363 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbaBWViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:38:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkJAHZpClN5LJYe/2dsb2JhbABZDoJ4g0O4XoVTgQcXdIIlAQEFOhwzCAMYCSUPBSUDIQESiATGNhcWjlWDJIEUBJgzilKHVoJuUyg
Date: Mon, 24 Feb 2014 08:36:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>,
        viro@zeniv.linux.org.uk, bpm@sgi.com, adilger.kernel@dilger.ca,
        jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
 fallocate
Message-ID: <20140223213606.GE4317@dastard>
References: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
 <20140222140625.GD26637@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140222140625.GD26637@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 09:06:25AM -0500, Theodore Ts'o wrote:
> On Wed, Feb 19, 2014 at 01:37:43AM +0900, Namjae Jeon wrote:
> > +	/*
> > +	 * There is no need to overlap collapse range with EOF, in which case
> > +	 * it is effectively a truncate operation
> > +	 */
> > +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> > +	    (offset + len >= i_size_read(inode)))
> > +		return -EINVAL;
> > +
> 
> I wonder if we should just translate a collapse range that is
> equivalent to a truncate operation to, in fact, be a truncate
> operation?

Trying to collapse a range that extends beyond EOF, IMO, is likely
to only happen if the DVR/NLE application is buggy. Hence I think
that telling the application it is doing something that is likely to
be wrong is better than silently truncating the file....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
