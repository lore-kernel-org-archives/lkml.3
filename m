Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaDWPZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:25:07 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33891 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaDWPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:25:03 -0400
Date: Wed, 23 Apr 2014 10:24:59 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: Fix type of iterator variable in do_io_submit()
Message-ID: <20140423152459.GA7609@zzz.student-wireless05.macalester.edu>
References: <1398207423-21119-1-git-send-email-ebiggers3@gmail.com>
 <20140423141617.GE13050@linux.intel.com>
 <20140423144237.GY22552@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423144237.GY22552@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:42:37AM -0400, Benjamin LaHaise wrote:
> Practically speaking, this change has no effect.  The io_submit() syscall 
> will exit far before we even hit INT_MAX because of the limits on the 
> number of iocbs.

Yes it looks like it doesn't actually make a difference due to the default
'aio-max-nr' limit of 1048576 (although you actually can submit just over twice
this many).  In my opinion this change should still be made so that the
correctness of the code doesn't rely on that nonlocal assumption, however.
And/or the explicit limit of (LONG_MAX / sizeof(struct iocb *)) elements could
be changed to something lower, as Matthew suggested.

Eric
