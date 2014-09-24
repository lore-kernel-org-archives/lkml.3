Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaIXS6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:58:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40537 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaIXS6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:58:52 -0400
Date: Wed, 24 Sep 2014 19:58:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] shmem: fix nlink for rename overwrite directory
Message-ID: <20140924185849.GD7996@ZenIV.linux.org.uk>
References: <20140924155617.GD7441@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924155617.GD7441@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 05:56:17PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If overwriting an empty directory with rename, then need to drop the extra
> nlink.

Hmm...  OK, point.  It doesn't actually check for ->i_nlink for directories,
and it only affects the sucker while it (a directory) is opened-but-rmdired,
but yes, it's visible to userland, so...  Applied.
