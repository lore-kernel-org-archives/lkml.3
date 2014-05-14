Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaENLjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:39:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbaENLjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:39:48 -0400
Date: Wed, 14 May 2014 13:39:45 +0200
From: Jan Kara <jack@suse.cz>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140514113945.GC5824@quack.suse.cz>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
 <1400018683-5565-2-git-send-email-mguzik@redhat.com>
 <20140514111449.GB5824@quack.suse.cz>
 <20140514112619.GA10637@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514112619.GA10637@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-05-14 13:26:21, Mateusz Guzik wrote:
> On Wed, May 14, 2014 at 01:14:49PM +0200, Jan Kara wrote:
> > On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
> > > This helps hang troubleshooting efforts when only dmesg is available.
> > > 
> > > While here remove code duplication with MS_RDONLY case and fix a
> > > whitespace nit.
> >   I'm somewhat undecided here I have to say. On one hand I don't like
> > printing to kernel log when everything is fine and kernel is operating
> > normally. On the other hand I've seen quite a few cases where people have
> > shot themselves in the foot with filesystem freezing so having some trace
> > of this in the log doesn't seem like a completely bad thing either. What do
> > other people think?
> > 
> 
> I would like to note that the kernel already prints messages when e.g.
> filesystems get mounted.
  Yeah, that's a fair point.

> And yes, situations where I/O is frozen and hung task detector comes into
> play happen more often than you may think. I can hide these behind a
> sysctl if this helps.
  No, I don't think hiding behind sysctl is really needed.

> Finally, somewhat related to the first mail, my preferred message format
> (which I was somewhat reluctant to propose earlier) would be:
> 
> VFS (%s): Filesystem frozen by %s:%d
> 
> with device, process and pid respectively.
  More common seems to be "%s (%d)" for process & pid but whatever. I like
the format change.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
