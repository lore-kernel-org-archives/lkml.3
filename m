Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaBVOGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:06:38 -0500
Received: from imap.thunk.org ([74.207.234.97]:32829 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaBVOGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:06:36 -0500
Date: Sat, 22 Feb 2014 09:06:25 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
 fallocate
Message-ID: <20140222140625.GD26637@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk,
	david@fromorbit.com, bpm@sgi.com, adilger.kernel@dilger.ca,
	jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
References: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:37:43AM +0900, Namjae Jeon wrote:
> +	/*
> +	 * There is no need to overlap collapse range with EOF, in which case
> +	 * it is effectively a truncate operation
> +	 */
> +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> +	    (offset + len >= i_size_read(inode)))
> +		return -EINVAL;
> +

I wonder if we should just translate a collapse range that is
equivalent to a truncate operation to, in fact, be a truncate
operation?

						- Ted
