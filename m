Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3CKUht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:37:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52631 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab3CKUhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:37:48 -0400
Date: Mon, 11 Mar 2013 16:37:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130311203738.GB15478@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311201334.GA444@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:13:34PM +0100, Markus Trippelsdorf wrote:
> On 2013.03.11 at 15:41 -0400, Dave Jones wrote:
> > Worked fine for me on two separate machines.  Could it be a network problem
> > perhaps ? If something is mangling the packet before it hits the disk,
> > that would explain it.  What NIC do you use ?

I'm not a torrent expert, but I thought it did enough checksumming
such that if the packet got mangled, it would get noticd by the
torrent client before it writes the chunks to disk?

> > Or maybe you could isolate it to a filesystem problem using something
> > like fsx ?
> 
> I've found fsx on your homepage, but I've no idea on how to use this
> tool. Any pointers?

We actually run fsx in a number of different configruations as part of
our regression testing before we send Linus a pull request, and
haven't found any issues.  So unless it's a hardware problem, it seems
unlikely to me that your running fsx would turn up anything.

Can you send a dumpefs -h of the file system in question, and what
mount options (if any) you are using?  Thanks!!

BTW, I'm currently running 3.9-rc2 with some additional fixes from the
ext4 dev branch, and I'm not able to reproduce the problem using
rtorrent on my laptop.  How reliably is it reproducing for you?  Are
you seeing the problem every time you try this?

						- Ted



