Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3CaHgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 03:36:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60559 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3CaHgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 03:36:11 -0400
Date: Sun, 31 Mar 2013 09:36:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Andreas Dilger <adilger@dilger.ca>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130331073604.GA13159@amd.pavel.ucw.cz>
References: <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <512BD44C.40907@amacapital.net>
 <20130226210232.GA19510@logfs.org>
 <20130330194933.GB1005@amd.pavel.ucw.cz>
 <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
 <20130330214509.GB4322@amd.pavel.ucw.cz>
 <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Hmm, really? AFAICT it would be simple to provide an
> >>> open_deleted_file("directory") syscall. You'd open_deleted_file(),
> >>> copy source file into it, then fsync(), then link it into filesystem.
> >>> 
> >>> That should have atomicity properties reflected.
> >> 
> >> Actually, the open_deleted_file() syscall is quite useful for many
> >> different things all by itself.  Lots of applications need to create
> >> temporary files that are unlinked at application failure (without a
> >> race if app crashes after creating the file, but before unlinking).
> >> It also avoids exposing temporary files into the namespace if other
> >> applications are accessing the directory.
> > 
> > Hmm. open_deleted_file() will still need to get a directory... so it
> > will still need a path. Perhaps open("/foo/bar/mnt", O_DELETED) would
> > be acceptable interface?
> 
> ...and what's the big plan to make this work on anything other than ext4 and btrfs?

Deleted but open files are from original unix, so it should work on
anything unixy (minix, ext, ext2, ...).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
