Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaIXTBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:01:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40542 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaIXTBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:01:01 -0400
Date: Wed, 24 Sep 2014 20:00:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix linkat error for unprivileged AT_EMPTY_PATH
Message-ID: <20140924190058.GE7996@ZenIV.linux.org.uk>
References: <20140924152523.GC7441@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924152523.GC7441@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 05:25:23PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Return proper error value for linkat(..., AT_EMPTY_PATH) without enough
> privileges.
> 
> I guess ENOENT was used here, because without AT_EMPTY_PATH that's what
> we'd return for an empty path.  But it is wrong for AT_EMPTY_PATH, since we
> might not even be passing an empty path, we are simply complaining about
> lack of privs for which EPERM is the proper error.

Umm...  Are you sure that nothing in userland is checking for that
return value?  I agree that EPERM would make more sense, but...
