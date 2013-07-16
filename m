Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab3GPEHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:07:08 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44401 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3GPEHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:07:06 -0400
Date: Mon, 15 Jul 2013 23:07:03 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RESEND] The initmpfs patches.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20130715140135.0f896a584fec9f7861049b64@linux-foundation.org>
	(from akpm@linux-foundation.org on Mon Jul 15 16:01:35 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373947623.3719.6@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 04:01:35 PM, Andrew Morton wrote:
> On Tue, 09 Jul 2013 21:06:39 -0500 Rob Landley <rob@landley.net>  
> wrote:
> 
> > Attached, so you don't have to fish them out of:
> >
> >    http://lkml.indiana.edu/hypermail/linux/kernel/1306.3/04204.html
> 
> Too hard.  Especially when I want to reply to a patch.  Please resend
> as a patch series in the time-honoured fashion?

Ok.

(Balsa is such an incompetent email client I wrote a python script to  
do this via raw smtp, and I'm always convinced it's going to screw up  
the send. But I think I've got it debugged now...)

> > --- a/fs/ramfs/inode.c
> > +++ b/fs/ramfs/inode.c
> > @@ -247,7 +247,14 @@ struct dentry *ramfs_mount(struct  
> file_system_type *fs_type,
> >  static struct dentry *rootfs_mount(struct file_system_type  
> *fs_type,
> >  	int flags, const char *dev_name, void *data)
> >  {
> > -	return mount_nodev(fs_type, flags|MS_NOUSER, data,  
> ramfs_fill_super);
> > +	static int once;
> > +
> > +	if (once)
> > +		return ERR_PTR(-ENODEV);
> > +	else
> > +		once++;
> > +
> > +	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
> >  }
> 
> The patches do this in a couple of places.  The treatment of `once' is
> obviously racy.  Probably it is unlikely to matter in these contexts,
> but it does set a poor example.  And it's so trivially fixed with, for
> example, test_and_set_bit() that I do think it's worth that change.

Fixing in new series. Retesting will probably delay the resend until  
morning.

Thanks,

Rob