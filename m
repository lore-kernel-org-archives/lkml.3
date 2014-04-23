Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaDWOQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:16:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:8784 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaDWOQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:16:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="422522019"
Date: Wed, 23 Apr 2014 10:16:17 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: viro@zeniv.linux.org.uk, bcrl@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: Fix type of iterator variable in do_io_submit()
Message-ID: <20140423141617.GE13050@linux.intel.com>
References: <1398207423-21119-1-git-send-email-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398207423-21119-1-git-send-email-ebiggers3@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:57:03PM -0500, Eric Biggers wrote:
> do_io_submit() iterated over the userspace iocb structure pointers using
> a variable i of type 'int'.  This was wrong since 'nr', the number of
> iocb structure pointers, could potentially be up to LONG_MAX /
> sizeof(struct iocb *).  Fix it (and also remove the unnecessary
> initialization to 0).

You're not wrong, but do we *really* want users to be able to submit
144115188075855872 I/Os with a single system call?  How about limiting
them to a single billion?  Given that they have to allocate 64GB of
*control* data structures to submit this many I/Os, I think this will
be sufficient for many years to come.
