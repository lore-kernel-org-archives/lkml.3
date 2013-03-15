Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3COUac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:30:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44983 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab3COUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:30:30 -0400
Date: Fri, 15 Mar 2013 20:30:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-ID: <20130315203018.GZ21522@ZenIV.linux.org.uk>
References: <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
 <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
 <20130315012541.GU21522@ZenIV.linux.org.uk>
 <19058.1363320936@jrobl>
 <20130315044411.GW21522@ZenIV.linux.org.uk>
 <20079.1363324154@jrobl>
 <20130315051322.GX21522@ZenIV.linux.org.uk>
 <1363335318.2459.4.camel@dabdike>
 <20130315121220.GY21522@ZenIV.linux.org.uk>
 <29608.1363373838@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29608.1363373838@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 03:57:18AM +0900, J. R. Okajima wrote:
> 
> Al Viro:
> > The trouble with such mechanisms is that they tend to end up depending on
> > fairly non-trivial properties of underlying fs.  Try aufs one on btrfs,
> > see how soon you spot the problem.  It's nice when a method turns out
> > to be really redundant and implementable in uniform way via other methods
> > present; see fh_to_dentry history for example of situation where it hadn't...
> 
> Hmm, I could not see problem around aufs using btrfs as the upper RW
> branch, tested on linux-3.9-rc2.
> Would you describe more specifically?

Sure - btrfs happens to have an interesting limit on the number of
links to the same object located in one directory.

The thing is, you are trying to retrofit a new primitive into many
filesystems and do it in the same way.  Doesn't work well...

And yes, it is an independent primitive.  What I really don't understand
is WTF is so attractive about not having to touch individual filesystems;
it's not particulary hard to do for any fs we might care about...
