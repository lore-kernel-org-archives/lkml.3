Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaEOSMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:12:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60434 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaEOSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:12:12 -0400
Date: Thu, 15 May 2014 13:12:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140515181206.GA1946@ubuntu-hedt>
Mail-Followup-To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	James Bottomley <James.Bottomley@HansenPartnership.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515174254.GM21073@ubuntumail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 05:42:54PM +0000, Serge Hallyn wrote:
> > > Serge mentioned something to me about a loopdevfs (?) thing that someone
> > > else is working on.  That would seem to be a better solution in this
> > > particular case but I don't know much about it or where it's at.
> > 
> > Ok, let's see those patches then.
> 
> I think Seth has a git tree ready, but not sure which branch he'd want
> us to look at.

I think the most recent code I've got is the devloop branch of
http://kernel.ubuntu.com/git/sforshee/ubuntu-trusty.git, which is still
a bit messy but gets the idea across. I switched from that to the
devtmpfs approach though for several reasons: the psuedo-fs approach
required some (in my opinion) undesirable collateral changes, it would
require changes to userspace tools (though likely small), and it solves
the problem only for loop devices. Plus if you don't push namespace
awareness down to at least the generic block layer you still can't do
partitions or encrypted loop, and then there are still other problems
which need to be solved to get partition blkdevs inside the mount.
