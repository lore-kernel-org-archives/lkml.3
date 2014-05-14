Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaENSnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:43:10 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:3407 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbaENSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:43:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMNAFS4c1NXQ68k/2dsb2JhbABZgwasbAEBAQEBAQUBmh0BgSQXdIIlAQEEAScTHCMFCwgDDgouOR4GE4g5DAHRMheFVIh6B4RAAQOPKoomAZMUgzg7
Date: Wed, 14 May 2014 20:43:04 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        hch <hch@infradead.org>, Viro <viro@zeniv.linux.org.uk>,
        tytso <tytso@mit.edu>
Subject: Re: [PATCH V5 1/2] FS: Add generic data flush to fsync
Message-Id: <20140514204304.94b0703f593626c2ea6f9465@skynet.be>
In-Reply-To: <20140512145027.e60426e59d99961236344827@linux-foundation.org>
References: <20140512072027.e715c362ff587e46ea83fb0c@skynet.be>
	<20140512145027.e60426e59d99961236344827@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 14:50:27 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 12 May 2014 07:20:27 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > This patch issues a flush in generic_file_fsync.
> > (Modern filesystems already do it)
> > 
> > Behaviour can be reversed using /sys/devices/.../cache_type
> > or by calling __generic_file_fsync
> 
> Well OK, but why?  What effect does the patch have?  Does it make the
> kernel better and if so, how?
> 
> >
> > +/**
> > + * generic_file_fsync - generic fsync implementation for simple filesystems
> > + *			with flush
> > + * @file:	file to synchronize
> > + * @start:	start offset in bytes
> > + * @end:	end offset in bytes (inclusive)
> > + * @datasync:	only synchronize essential metadata if true
> > + *
> > + */
> > +
> > +int generic_file_fsync(struct file *file, loff_t start, loff_t end,
> > +		       int datasync)
> > +{
> > +	struct inode *inode = file->f_mapping->host;
> > +	int err;
> > +
> > +	err = __generic_file_fsync(file, start, end, datasync);
> > +	if (err)
> > +		return err;
> > +
> > +	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
> > +
> > +}
> 
> Documentation/SubmitChecklist, section 2b ;)

Hi Andrew,

   As Jan suggested, I can resubmit patches with #ifdef CONFIG_BLOCK around
blkdev_issue_flush and further description. Do you see something else ?

Thanks,
Fabian

