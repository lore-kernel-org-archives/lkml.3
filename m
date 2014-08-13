Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaHMNSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:18:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMNSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:18:39 -0400
Date: Wed, 13 Aug 2014 14:18:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
Message-ID: <20140813131831.GY18016@ZenIV.linux.org.uk>
References: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
 <20140420054108.GQ18016@ZenIV.linux.org.uk>
 <20140511164530.GB18016@ZenIV.linux.org.uk>
 <20140809093412.GA23108@ZenIV.linux.org.uk>
 <87ha1ic8rd.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha1ic8rd.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 03:17:10AM -0700, Eric W. Biederman wrote:
> I have rebased my changes against vfs.git#for-eric and my changes work
> just fine on top of the base you have built.  The changes are avaiable
> in user-namespace.git#vfs-detach-mounts10 so you just be able to just
> pull the changes in.
> 
> Reading your pile #1 pull request to Linus it sounds like you are
> planning to suck all of this into the vfs tree.

I am.  Questions:
	* is there any reason why we need list instead of hlist for
per-mountpoint list of mounts?  Looks like hlist would do just as
well, and it's a bit less noise
	* __d_unalias() change looks rather odd.  What we do there
is _not_ "avoid leaking mounts", it's "don't get a bunch of existing
mounts suddenly relocate".  What's up with that one?
