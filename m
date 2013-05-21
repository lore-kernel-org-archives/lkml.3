Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3EUXex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:34:53 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56674 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab3EUXew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:34:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusOAEYEnFF5LNn3/2dsb2JhbABagwi8eoUcBAGBCRd0giMBAQU6HDMIAxgJJQ8FJQMhARKIDLtwFo1ngSSDVAOXN5FBgyEq
Date: Wed, 22 May 2013 09:34:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130521233429.GW29466@dastard>
References: <20130521225257.GA12713@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521225257.GA12713@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 06:52:57PM -0400, Dave Jones wrote:
> [  464.210598] XFS: Assertion failed: (mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID| ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 719

Never seen that fire before, but this is why we have ASSERT()s like
this - we're being handed something by the VFS we don't expect...

Can you give me some context of the file permissions before the
syscall and what the syscall parameters are? i.e. is this likely to
be trying to strip SUID/SGID during the truncate operation?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
