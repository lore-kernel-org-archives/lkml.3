Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaKDPiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:38:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaKDPh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:37:56 -0500
Date: Tue, 4 Nov 2014 16:37:52 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] chardev: Increment cdev reference count when i_cdev
 references it
Message-ID: <20141104153752.GB21902@quack.suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
 <1414008853-13200-3-git-send-email-jack@suse.cz>
 <20141104144611.GE7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104144611.GE7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 14:46:11, Al Viro wrote:
> On Wed, Oct 22, 2014 at 10:14:11PM +0200, Jan Kara wrote:
> > Currently i_cdev reference to a character device isn't accounted in the
> > reference count of the character device. This then requires us to track
> > all references through a list of all inodes referencing a character
> > device which is somewhat clumsy and requires list_head in each inode in
> > the system.
> > 
> > So make i_cdev a reference like any other.
> 
> So no rmmod for you until an inode of character device node you had
> closed a while ago finally gets evicted from icache?  Or am I misreading
> you?
  Yes, this is a consequence of the change. I should have noted in the
changelog I guess.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
