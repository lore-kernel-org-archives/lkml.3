Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaIXSz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:55:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40526 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIXSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:55:25 -0400
Date: Wed, 24 Sep 2014 19:55:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mikhail Efremov <sem@altlinux.org>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140924185521.GC7996@ZenIV.linux.org.uk>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411582473-29184-1-git-send-email-sem@altlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:14:33PM +0400, Mikhail Efremov wrote:
> Only exchange source and destination filenames
> if flags contain RENAME_EXCHANGE.
> In case if executable file was running and replaced by
> other file /proc/PID/exe should still show correct file name,
> not the old name of the file by which it was replaced.

Yecchhhh...  Applied, but it's very ugly.  Oh, well - regression is
regression, and I don't see a cleaner fix at the moment.  If I don't
manage to come up with anything prettier, to Linus it goes in tonight
pull request ;-/
