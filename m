Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab3DAX1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:27:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40262 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3DAX1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:27:21 -0400
Date: Tue, 2 Apr 2013 00:27:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yet another pipe related oops.
Message-ID: <20130401232718.GE21522@ZenIV.linux.org.uk>
References: <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com>
 <20130327152030.GY21522@ZenIV.linux.org.uk>
 <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
 <20130327174506.GZ21522@ZenIV.linux.org.uk>
 <20130401203445.GA20862@ZenIV.linux.org.uk>
 <20130401210029.GA3245@kroah.com>
 <20130401212142.GD21522@ZenIV.linux.org.uk>
 <20130401214436.GA5786@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401214436.GA5786@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:44:36PM -0700, Greg Kroah-Hartman wrote:
> > > I guess you are right, it will not.  I guess we need to do what
> > > character devices do and have an "intermediate" fops in order to protect
> > > this.  Would that work?
> > 
> > You mean, with reassigning ->f_op in ->open()?  That'll work, as long as
> > we have exclusion between removal and fetching the sucker in primary
> > ->open()...  Where would you prefer to stash fops?
> 
> Ick, that's not going to work as the current api just uses a fops and
> debugfs doesn't keep anything else hanging around that referes to
> something "before" that, like 'struct cdev' does.

Er?  How about just sticking it into dentry->d_fsdata and letting
debugfs_remove() zero that out?  What am I missing here?
