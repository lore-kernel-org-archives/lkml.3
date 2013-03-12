Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab3CLWX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:23:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3CLWX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:23:57 -0400
Date: Tue, 12 Mar 2013 22:23:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Message-ID: <20130312222350.GK21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
 <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:50:02PM -0700, Linus Torvalds wrote:
> On Tue, Mar 12, 2013 at 8:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > Al and Linus,
> >
> > Please consider overlayfs for inclusion into 3.10.
> 
> Yes, I think we should just do it. It's in use, it's pretty small, and
> the other alternatives are worse. Let's just plan on getting this
> thing done with.
> 
> Al, I realize you may not love this, but can you please give this a
> look? People clearly want to use it. In particular the new interfaces,
> like the inode ops open function with dentry passed in or whatever?
> The changes outside of overlayfs looked fine to me.

I'll post a review tonight or tomorrow.  FWIW, I was not too happy with
it the last time I looked, but I'll obviously need to reread the whole
thing.

I *have* looked at unionmount lately, and the recent modifications dhowells
is doing there are closing most of my problems with that; on the other hand,
there's no fundamental reason why both can't get merged.  Hell, might as
well resurrect aufs, while we are at it...

union-like things are actually on top of my "things to deal with this cycle"
list, closely folowed by rework of ->readdir().

Miklos, two points:
	* I would very much prefer to deal with that (as well as unionmount and
aufs) as git branches _expected_ to be reordered/rebased/folded/mutilated/etc.
while we are sorting all that stuff out.  For now, let's base them on -rc1.
I expect that vfs.git will grow common stem, with bits and pieces of those
guys getting gradually pulled into it, at which point(s) the rest will be
rebased.
	* what Linus just said about bisectablity
Oh, and the third one - I still owe you a bottle of your choice for sorting
the atomic_open shite out.  Is there any chance you'll be able to attend
LSFS this year?

