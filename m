Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3A2BkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:40:10 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:45943 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3A2BkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:40:08 -0500
Date: Mon, 28 Jan 2013 20:40:00 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: David Lang <david@lang.hm>,
        Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Initial fsck has landed
Message-ID: <20130129014000.GA7003@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	David Lang <david@lang.hm>,
	Daniel Phillips <daniel.raymond.phillips@gmail.com>,
	linux-kernel@vger.kernel.org, tux3@tux3.org,
	linux-fsdevel@vger.kernel.org
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
 <alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz>
 <CAEsagEjAoVNUUSotBXd0am5zZb5VMLWT2Dz9k5fj+C9-LKABnQ@mail.gmail.com>
 <20130128141209.GA22711@thunk.org>
 <alpine.DEB.2.02.1301281526410.21503@nftneq.ynat.uz>
 <20130129002011.GA4757@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129002011.GA4757@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
> > On Mon, 28 Jan 2013, Theodore Ts'o wrote:
> > 
> > >On Sun, Jan 27, 2013 at 10:13:37PM -0800, Daniel Phillips wrote:
> > >>>The thing that jumps out at me with this is the question of how you will
> > >>>avoid the 'filesystem image in a file' disaster that reiserfs had (where
> > >>>it's fsck could mix up metadata chunks from the main filesystem with
> > >>>metadata chunks from any filesystem images that it happened to stumble
> > >>>across when scanning the disk)
> 
> Did that ever get fixed in reiserfs?

Not in resierfs, but this was something that Hans did change for
reiserfs4.

> > The situation I'm thinking of is when dealing with VMs, you make a
> > filesystem image once and clone it multiple times. Won't that end up
> > with the same UUID in the superblock?
> 
> Yes, but one ought to be able to change the UUID a la tune2fs -U.  Even
> still... so long as the VM images have a different UUID than the fs that they
> live on, it ought to be fine.

... and this is something most system administrators should be
familiar with.  For example, it's one of those things that Norton
Ghost when makes file system image copes (the equivalent of "tune2fs
-U random /dev/XXX")

					- Ted
