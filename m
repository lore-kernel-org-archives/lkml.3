Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaJWAW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:22:26 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:48082 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933411AbaJWAWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:22:23 -0400
Date: Wed, 22 Oct 2014 19:22:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        seth.forshee@canonical.com
Subject: Re: [PATCH v5 4/4] fuse: Allow user namespace mounts
Message-ID: <20141023002200.GA138443@ubuntu-hedt>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-5-git-send-email-seth.forshee@canonical.com>
 <CALCETrV_4euS+iDi3imBvBW3L7sutQ6kGJ1Z9CRHUPRL7n9v0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV_4euS+iDi3imBvBW3L7sutQ6kGJ1Z9CRHUPRL7n9v0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:51:56PM -0700, Andy Lutomirski wrote:
> On Wed, Oct 22, 2014 at 2:24 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  fs/fuse/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index b88b5a780228..7d0e73e36e7b 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -1201,7 +1201,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
> >  static struct file_system_type fuse_fs_type = {
> >         .owner          = THIS_MODULE,
> >         .name           = "fuse",
> > -       .fs_flags       = FS_HAS_SUBTYPE,
> > +       .fs_flags       = FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
> >         .mount          = fuse_mount,
> >         .kill_sb        = fuse_kill_sb_anon,
> >  };
> > @@ -1233,7 +1233,7 @@ static struct file_system_type fuseblk_fs_type = {
> >         .name           = "fuseblk",
> >         .mount          = fuse_mount_blk,
> >         .kill_sb        = fuse_kill_sb_blk,
> > -       .fs_flags       = FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
> > +       .fs_flags       = FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
> >  };
> >  MODULE_ALIAS_FS("fuseblk");
> >
> > --
> > 1.9.1
> >
> 
> This is mostly a sign of my ignorance, but how does this actually end
> up working?  I assume that the mounter opens /dev/fuse and then passes
> the fd to the mount call.  Which userns is captured?  The opener of
> /dev/fuse or the mounter of the fs?

You're correct that the mounter passes the fd to /dev/fuse to the mount
call. The namespace of the mounter is used, but there's also a check to
make sure that's the same as that of the opener of /dev/fuse, otherwise
the mount fails.

Seth
