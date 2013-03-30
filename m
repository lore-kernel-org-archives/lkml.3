Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3C3VpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 17:45:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57517 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3C3VpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 17:45:10 -0400
Date: Sat, 30 Mar 2013 22:45:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Dilger <adilger@dilger.ca>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130330214509.GB4322@amd.pavel.ucw.cz>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <512BD44C.40907@amacapital.net>
 <20130226210232.GA19510@logfs.org>
 <20130330194933.GB1005@amd.pavel.ucw.cz>
 <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-03-30 13:08:39, Andreas Dilger wrote:
> On 2013-03-30, at 12:49 PM, Pavel Machek wrote:
> > Hmm, really? AFAICT it would be simple to provide an
> > open_deleted_file("directory") syscall. You'd open_deleted_file(),
> > copy source file into it, then fsync(), then link it into filesystem.
> > 
> > That should have atomicity properties reflected.
> 
> Actually, the open_deleted_file() syscall is quite useful for many
> different things all by itself.  Lots of applications need to create
> temporary files that are unlinked at application failure (without a
> race if app crashes after creating the file, but before unlinking).
> It also avoids exposing temporary files into the namespace if other
> applications are accessing the directory.

Hmm. open_deleted_file() will still need to get a directory... so it
will still need a path. Perhaps open("/foo/bar/mnt", O_DELETED) would
be acceptable interface?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
