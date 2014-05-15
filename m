Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaEOJmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:42:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaEOJmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:42:46 -0400
Date: Thu, 15 May 2014 11:42:37 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515094236.GE10637@mguzik.redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <20140514215457.GC5421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140514215457.GC5421@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 07:54:57AM +1000, Dave Chinner wrote:
> On Tue, May 13, 2014 at 08:31:02PM +0200, Mateusz Guzik wrote:
> > This helps hang troubleshooting efforts when only dmesg is available.
> 
> I really don't think that spamming dmesg every time a filesystem is
> frozen or thawed is a good idea. This happens a *lot* when systems
> are using snapshots, and for the most part nobody cares about
> freeze/thaw cycles because they almost always work just fine.
> 

I agree it may get noisy.

> I'd think that /proc/self/mounts would be a much better place to
> indicate that the fs is frozen. After all, that's where we tell
> people whether the filesystem is ro or rw, and frozen is just
> a temporary, non-invasive ro state...
> 

Except you can't inspect /proc/self/mounts when the only thing you got
is dmesg, so this does not really help my case.

That said, I'll try to come up with a different solution.

Poorly reported side-effects of frozen I/O are only a part of the real
problem which is hung task detector being able to typically report
backtraces of "victims" only. I came up with printks becuase these are
a cheap way and would help us out in a lot of cases.

So general idea is to support providing callbacks when setting tasks to
TASK_UNINTERRUPTIBLE which could either tell the user what's up directly
or would perform some heuristics. I'll post this in a separate thread
later, maybe with PoC.

Thanks,
-- 
Mateusz Guzik
