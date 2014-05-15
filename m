Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaEOKn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:43:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaEOKn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:43:26 -0400
Date: Thu, 15 May 2014 12:43:17 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Mateusz Guzik <mguzik@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
In-Reply-To: <20140515100157.GB27289@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1405151242210.2112@localhost.localdomain>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com> <1400005862-3751-2-git-send-email-mguzik@redhat.com> <20140514215457.GC5421@dastard> <20140515094236.GE10637@mguzik.redhat.com> <20140515100157.GB27289@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Jan Kara wrote:

> Date: Thu, 15 May 2014 12:01:57 +0200
> From: Jan Kara <jack@suse.cz>
> To: Mateusz Guzik <mguzik@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
>     Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
>     Eric Sandeen <esandeen@redhat.com>
> Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
>     filesystems
> 
> On Thu 15-05-14 11:42:37, Mateusz Guzik wrote:
> > On Thu, May 15, 2014 at 07:54:57AM +1000, Dave Chinner wrote:
> > > On Tue, May 13, 2014 at 08:31:02PM +0200, Mateusz Guzik wrote:
> > > > This helps hang troubleshooting efforts when only dmesg is available.
> > > 
> > > I really don't think that spamming dmesg every time a filesystem is
> > > frozen or thawed is a good idea. This happens a *lot* when systems
> > > are using snapshots, and for the most part nobody cares about
> > > freeze/thaw cycles because they almost always work just fine.
> > > 
> > 
> > I agree it may get noisy.
> > 
> > > I'd think that /proc/self/mounts would be a much better place to
> > > indicate that the fs is frozen. After all, that's where we tell
> > > people whether the filesystem is ro or rw, and frozen is just
> > > a temporary, non-invasive ro state...
> > > 
> > 
> > Except you can't inspect /proc/self/mounts when the only thing you got
> > is dmesg, so this does not really help my case.
> > 
> > That said, I'll try to come up with a different solution.
> > 
> > Poorly reported side-effects of frozen I/O are only a part of the real
> > problem which is hung task detector being able to typically report
> > backtraces of "victims" only. I came up with printks becuase these are
> > a cheap way and would help us out in a lot of cases.
>   I was tracking down a couple of times what the hell is freezing the
> filesystem (and not unfreezing it) and I agree with Mateusz it would be
> nice if we could tell after the fact who froze the fs. Maybe we could store
> that information in superblock and dump it during emergency thaw?

I like that idea and if we agree to create procfs file to list
frozen file system this might be one of the useful information to
report there.

-Lukas

> 
> 								Honza
> 
