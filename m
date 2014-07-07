Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaGGXGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:06:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGGXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:06:29 -0400
Date: Mon, 7 Jul 2014 16:06:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: David Rientjes <rientjes@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [stable] please do not merge 058504edd026 (was Re: fs: use
 after free in /proc/pid/mountinfo)
Message-Id: <20140707160627.dd260c98d20ce68f4668797a@linux-foundation.org>
In-Reply-To: <20140707230542.GJ11171@kroah.com>
References: <53B3F331.7090204@oracle.com>
	<53B4CAB8.5070407@oracle.com>
	<alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>
	<53B6C051.2060704@oracle.com>
	<alpine.DEB.2.02.1407041530420.25275@chino.kir.corp.google.com>
	<20140707230542.GJ11171@kroah.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014 16:05:42 -0700 Greg KH <greg@kroah.com> wrote:

> On Fri, Jul 04, 2014 at 03:35:54PM -0700, David Rientjes wrote:
> > On Fri, 4 Jul 2014, Sasha Levin wrote:
> > 
> > > > Does this now reproduce on Linus's tree?  If so, does reverting commit
> > > > 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") prevent this 
> > > > issue?
> > > > 
> > > > This is a use-after-free since the poison value is 0x6b and I'm presuming 
> > > > that your /proc/self/mountinfo may be larger than PAGE_SIZE in your 
> > > > testing environment.
> > > > 
> > > 
> > > Good call, reverting that patch made both issues go away.
> > > 
> > 
> > Thanks for checking, Sasha.
> > 
> > Stable maintainers, please do not merge commit 058504edd026 ("fs/seq_file: 
> > fallback to vmalloc allocation") that is annotated with a cc for 
> > stable@vger.kernel.org in Linus's tree into stable kernels.
> > 
> > Although we're at 3.16-rc3, I'm hoping that we can get a fix for the 
> > use-after-free in the next couple days before asking for a revert.  Sasha 
> > confirms[*] this commit causes the bug.
> 
> I should also drop "Subject: /proc/stat: convert to single_open_size()"
> from the -stable tree, right?
> 

That would be best.

I can't see how "fs: use after free in /proc/pid/mountinfo" can cause a
use-after-free so perhaps the bug lies elsewhere and was hidden by luck
(slab buffering or slab rcu-freeing or something).  In which case
"fs/seq_file: fallback to vmalloc allocation" might be the patch which
added the bug.
