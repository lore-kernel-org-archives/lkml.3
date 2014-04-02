Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaDBSG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:06:59 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:7423 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbaDBSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:06:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMNANxQPFNbtAq4/2dsb2JhbABZDoJ4xHUCAoEgF3SCJQEBAQMBJxMcIwULCAMYLjkeBhOHcQwBzy8XjnAHhDgBA4x6i1sBh0yDEodbgnBCOw
Date: Wed, 2 Apr 2014 20:08:44 +0200
From: Fabian Frederick <fabf@skynet.be>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, jfs-discussion@lists.sourceforge.net,
        "Dave.Kleikamp" <dave.kleikamp@oracle.com>
Subject: Re: [PATCH 1/1] fs/jfs/jfs_inode.c: atomically set inode->i_flags
Message-Id: <20140402200844.bf9c94540921b7647c75e580@skynet.be>
In-Reply-To: <20140402174707.GK6901@thunk.org>
References: <20140402192950.82812a331cb154bbc0a4183c@skynet.be>
	<20140402174707.GK6901@thunk.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 13:47:07 -0400
Theodore Ts'o <tytso@mit.edu> wrote:

> On Wed, Apr 02, 2014 at 07:29:50PM +0200, Fabian Frederick wrote:
> > +	set_mask_bits(&inode->i_flags, S_IMMUTABLE | S_APPEND | S_NOATIME |
> > +				       S_DIRSYNC | S_SYNC, new_fl);
> 
> Warning --- per discussion with Linus over the weekend, he decided he
> really didn't like the set_mask_bits() interface, because it was too
> prone to abuse.  Unfortuantely, Linus had already included an earlier
> version of my patch that used set_mask_bits() in 3.14 without letting
> me know.  This is what I have in my ext4 tree for the merge window,
> which is undergoing final testing at the moment.  This will cause a
> patch conflict, and it's likely (given Linus's dislike of the
> set_mask_bits interface) that set_mask_bits() will end up getting
> removed from the tree, if not when he fixes up the merge conflict, but
> subsequent to -rc1.
> 
> 							- Ted
> 
> 

Thanks a lot Ted, I'll wait your inode patch to got mainline before updating this one.
Of course I don't wanna step on your toes if you prefer releasing patches for all FS :)

Fabian
