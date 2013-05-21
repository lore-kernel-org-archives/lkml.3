Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3EUXk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab3EUXk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:40:26 -0400
Date: Tue, 21 May 2013 19:40:16 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130521234016.GB14347@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130521225257.GA12713@redhat.com>
 <20130521233429.GW29466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521233429.GW29466@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 09:34:29AM +1000, Dave Chinner wrote:
 > On Tue, May 21, 2013 at 06:52:57PM -0400, Dave Jones wrote:
 > > [  464.210598] XFS: Assertion failed: (mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET| ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID| ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0, file: fs/xfs/xfs_iops.c, line: 719
 > 
 > Never seen that fire before, but this is why we have ASSERT()s like
 > this - we're being handed something by the VFS we don't expect...
 > 
 > Can you give me some context of the file permissions before the
 > syscall and what the syscall parameters are? i.e. is this likely to
 > be trying to strip SUID/SGID during the truncate operation?

no idea tbh. Is there something I can add to that assert to dump
which file it was triggered by ?

	Dave

