Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823Ab3DSPmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:42:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030656Ab3DSPma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:42:30 -0400
Date: Fri, 19 Apr 2013 17:01:56 +0200
From: Jan Kara <jack@suse.cz>
To: "lkml@tigusoft.pl" <lkml@tigusoft.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Very poor latency when using hard drive (raid1)
Message-ID: <20130419150156.GC26647@quack.suse.cz>
References: <kkgj31$jc6$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kkgj31$jc6$1@ger.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-04-13 11:59:59, lkml@tigusoft.pl wrote:
> There are 2 hard drives (normal, magnetic) in software raid 1
> on 3.2.41 kernel.
  Any possibility in trying a newer kernel? Like 3.8 / 3.9?

> When I write into them e.g. using dd from /dev/zero to a local file
> (ext4 on default settings), running 2 dd at once (writing two files) it
> starves all other programs that try to use the disk.
  That shouldn't really happen. I presume you use the default IO scheduler?
i.e. CFQ?

> Running ls on any directory on same disk (same fs btw), takes over half
> minute to execute, same for any other disk touching action.
> 
> Did anyone seen such problem, where too look, what to test?
  Not in such a simple setting as yours.

> What could solve it (other then ionice on applications that I expect to
> use hard drive)?
  ionice wouldn't help because dd writes the data into page cache and from
there flusher thread writes them to disk. So IO happens in flusher context
which won't be ioniced.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
