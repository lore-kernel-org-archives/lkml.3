Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633Ab3BOCVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:21:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56381 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BOCVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:21:36 -0500
Date: Fri, 15 Feb 2013 02:21:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Louis Huemiller <lhuemill@google.com>
Subject: Re: [PATCH] fs: Preserve error code in get_empty_filp()
Message-ID: <20130215022134.GA11376@ZenIV.linux.org.uk>
References: <1347505915-27984-1-git-send-email-anatol.pomozov@gmail.com>
 <CAOMFOmWEifGsiq3t93FL6xjPDy1Y0OTJ+h+mek0Q=cn_sb+j2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmWEifGsiq3t93FL6xjPDy1Y0OTJ+h+mek0Q=cn_sb+j2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 11:16:12AM -0700, Anatol Pomozov wrote:
> Hi, AlViro
> 
> Is any reason why this change is ignored? For me it looks like a
> straightforward bugfix.
> 
> A little bit of context for this change. We at Google work on a test
> framework that shows how kernel behaves under memory pressure. In the
> codepath that I am fixing the syscalls return ENFILE error, but in
> fact the correct error would be ENOMEM. get_empty_filp() should
> preserve the original error and not to replace all errors with ENFILE.

The trouble is, you are introducing previously impossible return values
for pipe(2).  The rest of it is probably OK (even though I'd prefer to
split get_empty_filp() part into a separate commit), but this one has
potential for breaking previously correct userland code.  OTOH, FreeBSD has
done that a while ago and they apparently had been able to cope with the
fallout.

I'll put that thing sans the fs/pipe.c part in for-next, but IMO the
change of pipe(2) shouldn't go in at the moment.
