Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaC3X5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:57:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaC3X5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:57:20 -0400
Date: Mon, 31 Mar 2014 00:57:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140330235717.GO18016@ZenIV.linux.org.uk>
References: <20140329223109.GA24098@redhat.com>
 <20140330234335.GB16336@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330234335.GB16336@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
> filldir on a directory inode vs page fault on regular file. Known
> issue, definitely a false positive. We have to change locking
> algorithms to avoid such deficiencies of lockdep (a case of "lockdep
> considered harmful", perhaps?) so it's not something I'm about to
> rush...

Give i_lock on directories a separate class, as it's been done for i_mutex...
