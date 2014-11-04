Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaKDPzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:55:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbaKDPzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:55:49 -0500
Date: Tue, 4 Nov 2014 16:55:43 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] chardev: Increment cdev reference count when i_cdev
 references it
Message-ID: <20141104155543.GD21902@quack.suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
 <1414008853-13200-3-git-send-email-jack@suse.cz>
 <20141104144611.GE7996@ZenIV.linux.org.uk>
 <20141104153752.GB21902@quack.suse.cz>
 <20141104154030.GI7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104154030.GI7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 15:40:30, Al Viro wrote:
> On Tue, Nov 04, 2014 at 04:37:52PM +0100, Jan Kara wrote:
> > On Tue 04-11-14 14:46:11, Al Viro wrote:
> > > On Wed, Oct 22, 2014 at 10:14:11PM +0200, Jan Kara wrote:
> > > > Currently i_cdev reference to a character device isn't accounted in the
> > > > reference count of the character device. This then requires us to track
> > > > all references through a list of all inodes referencing a character
> > > > device which is somewhat clumsy and requires list_head in each inode in
> > > > the system.
> > > > 
> > > > So make i_cdev a reference like any other.
> > > 
> > > So no rmmod for you until an inode of character device node you had
> > > closed a while ago finally gets evicted from icache?  Or am I misreading
> > > you?
> >   Yes, this is a consequence of the change. I should have noted in the
> > changelog I guess.
> 
> That consequence looks broken, IMO.
  Hum, it already behaves for block devices that way (and noone complained
- but admittedly block devices tied to strange modules are less common than
character devices). Also rmmod isn't that common IMO, but I see your point
that it's unintuitive behavior.

Alternatively we could clear i_cdev when the inode isn't open anymore (and
thus doesn't hold any references to cdev). The downside is we have to
re-lookup the character device on the first inode open. Would such a
solution look acceptable to you?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
