Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3C3Ttg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 15:49:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45408 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab3C3Ttf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 15:49:35 -0400
Date: Sat, 30 Mar 2013 20:49:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130330194933.GB1005@amd.pavel.ucw.cz>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <512BD44C.40907@amacapital.net>
 <20130226210232.GA19510@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226210232.GA19510@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I thought the first thing people would ask for is to atomically create a
> > new file and copy the old file into it (at least on local file systems).
> >  The idea is that nothing should see an empty destination file, either
> > by race or by crash.  (This feature would perhaps be described as a
> > pony, but it should be implementable.)
> 
> Having already wasted many week trying to implement your pony, I would
> consider it about as possible as winning the lottery three times in a
> row.  It clearly is in theory and yet,...

Hmm, really? AFAICT it would be simple to provide open_deleted_file("directory")
syscall. You'd open_deleted_file(), copy source file into it, then
fsync(), then link it into filesystem.

That should have atomicity properties reflected.
									Pavel
								(who has too many (*)
									ponies around)
(*) 1 is sometimes too many when we talk about big mammals.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
