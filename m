Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaKZHqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:46:09 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39249 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZHqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:46:08 -0500
Date: Wed, 26 Nov 2014 08:46:03 +0100
From: Pieter Smith <pieter@boesman.nl>
To: josh@joshtriplett.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] fs/fuse: support compiling out splice
Message-ID: <20141126074603.GB15377@smipidev>
References: <1416899996-21315-1-git-send-email-pieter@boesman.nl>
 <1416899996-21315-5-git-send-email-pieter@boesman.nl>
 <20141125141713.GA9137@tucsk.suse.de>
 <20141125194242.GA21633@smipidev>
 <20141125204916.GD24891@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125204916.GD24891@cloud>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:49:16PM -0800, josh@joshtriplett.org wrote:
> On Tue, Nov 25, 2014 at 08:42:42PM +0100, Pieter Smith wrote:
> > On Tue, Nov 25, 2014 at 03:17:13PM +0100, Miklos Szeredi wrote:
> > > [Trimming CC.  Please do the same for other patches.  I for one am not
> > > interested in the general tinification discussion]
> > > 
> > > On Tue, Nov 25, 2014 at 08:19:39AM +0100, Pieter Smith wrote:
> > > > To implement splice support, fs/fuse makes use of nosteal_pipe_buf_ops. This
> > > > struct is exported by fs/splice. The goal of the larger patch set is to
> > > > completely compile out fs/splice, so uses of the exported struct need to be
> > > > compiled out along with fs/splice.
> > > > 
> > > > This patch therefore compiles out splice support in fs/fuse when
> > > > CONFIG_SYSCALL_SPLICE is undefined.
> > > > 
> > > > Signed-off-by: Pieter Smith <pieter@boesman.nl>
> > > > ---
> > > >  fs/fuse/dev.c | 9 +++++++--
> > > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > > > index ca88731..e984302 100644
> > > > --- a/fs/fuse/dev.c
> > > > +++ b/fs/fuse/dev.c
> > > > @@ -1191,8 +1191,9 @@ __releases(fc->lock)
> > > >   * request_end().  Otherwise add it to the processing list, and set
> > > >   * the 'sent' flag.
> > > >   */
> > > > -static ssize_t fuse_dev_do_read(struct fuse_conn *fc, struct file *file,
> > > > -				struct fuse_copy_state *cs, size_t nbytes)
> > > > +static ssize_t __maybe_unused
> > > > +fuse_dev_do_read(struct fuse_conn *fc, struct file *file,
> > > > +		 struct fuse_copy_state *cs, size_t nbytes)
> > > 
> > > fuse_dev_do_read() is definitely going to remain used.  So no point in adding
> > > __maybe_unused.
> > 
> > Off course, but at least gcc now also is aware that this is intentional and
> > nicely refrains from nagging you with a warning.
> 
> GCC shouldn't be warning about an unused fuse_dev_do_read; please
> recheck.  It will always get used by fuse_dev_read, which
> unconditionally gets used in the .aio_read field of fuse_dev_operations.
> 
> - Josh Triplett

Thanks for pointing this out. I was too hasty in my response.

- Pieter Smith
