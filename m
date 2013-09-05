Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3IECfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:35:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:54811 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab3IECff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:35:35 -0400
Date: Wed, 4 Sep 2013 22:35:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: T Makphaibulchoke <tmac@hp.com>
Cc: adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, aswin@hp.com,
        torvalds@linux-foundation.org, aswin_proj@groups.hp.com
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Message-ID: <20130905023522.GA21268@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	T Makphaibulchoke <tmac@hp.com>, adilger.kernel@dilger.ca,
	viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	aswin@hp.com, torvalds@linux-foundation.org,
	aswin_proj@groups.hp.com
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1378312756-68597-1-git-send-email-tmac@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378312756-68597-1-git-send-email-tmac@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:39:14AM -0600, T Makphaibulchoke wrote:
> 
> Here are the performance improvements in some of the aim7 workloads,

How did you gather these results?  The mbcache is only used if you are
using extended attributes, and only if the extended attributes don't
fit in the inode's extra space.

I checked aim7, and it doesn't do any extended attribute operations.
So why are you seeing differences?  Are you doing something like
deliberately using 128 byte inodes (which is not the default inode
size), and then enabling SELinux, or some such?

						- Ted
