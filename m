Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaDOUFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:05:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:54748 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaDOUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:05:00 -0400
Date: Tue, 15 Apr 2014 16:04:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][1/11][MANUX] Kernel compatibility : ext2
Message-ID: <20140415200457.GH4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
References: <534D3753.6080601@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D3753.6080601@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:42:43PM +0200, Emmanuel Colbus wrote:
> The issue is that I also needed it in other
> partitions, including linux-created ext2 ones. Thus, I have used the
> osd1 field for this, including in cases where I'm *not* the creator OS.
> 
> Well, at this point, you're likely to say : "Hey, you can't do that,
> this isn't allowed!"......

It seems really strange to you are asking for permission here.  You're
doing your own operating system, so you don't need to ask permission.
You can do whatever you want.  The flip side is that even if it's "ok"
for now, we could make changes in the future that might break
assumptions that you are making today.  And if that happens, you
shouldn't expect that we will do anything for your convenience, just
because someone in the past said, "I give you my permission".  

> 1) Except for the Hurd, no OS has ever made use of this field in 20
> years or so;

In this specific case, the osd1 field is in fact used by ext4, as the
i_version field, which is required for NFSv4 support.  The ext4 file
system is a superset of ext2, and in fact some distributions have
started shipping with a configuration which allows the ext4 file
system code to mount ext2 and ext3 file systems. 

> (By the way, if you have issues with it, I can propose a solution.
> Initially, I simply thought I could take a new bit in the read-write
> compatible functions, and then mark all the filesystems I would use this
> way with this bit. However, I noticed this wouldn't work, because if
> Linux suddenly decided to make use of this field, it would need a way to
> tell my kernel about this, so we would also need to choose a second bit
> to mean "This filesystem actually uses the osd1 field, don't touch it".
> However, once this is done, since I don't care that my own data in this
> field be preserved, the first bit would become useless... Thus, the
> solution would simply be that you choose an unused bit in the read-write
> compatible functions to mean "leave the osd1 field alone!", so that you
> can set it if you ever decide to make use of this field; and that I
> simply test it and refuse to mount these partitions.)

Um, no.  The Linux implementation gets to use any unclaimed fields in
the inode or the superblock, and we're not necessarily going to go out
of the way and extra complexity into the ext4 kernel, just to
accomodate every single random OS developer who decides they want to
go off and do their own thing.  This is a strategy which simply
doesn't scale.  Can you imagine what might happen if people start
coming out of the woodwork demanding special accomodation for Tomix,
Dikux, and Harrix?

If you want to start off by cloning our code or our design, you're
completely free to do that.  That's what an open source license is all
about.  But you don't get to dictate to the upstream that they make
changes to accomodate MANUX extensions.  If you want to try to
negotiate with us --- maybe, although there is some fields such as
inode fields which are extremely precious where it would have to be a
really, really good reason.  So you'll need to tell us what it is that
you want the extra field for, and why it would be to the benefit of
the greater ext4 community that we accomodate you.

Best regards,

						- Ted
