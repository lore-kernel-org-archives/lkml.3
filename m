Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaGGXBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:01:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50738 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbaGGXBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:01:20 -0400
X-Sasl-enc: +aZwzVc57EXNm4rN12iIlOLznC7tzAQ+BK/FZ603jtIf 1404774079
Date: Mon, 7 Jul 2014 16:05:42 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [stable] please do not merge 058504edd026 (was Re: fs: use after
 free in /proc/pid/mountinfo)
Message-ID: <20140707230542.GJ11171@kroah.com>
References: <53B3F331.7090204@oracle.com>
 <53B4CAB8.5070407@oracle.com>
 <alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com>
 <53B6C051.2060704@oracle.com>
 <alpine.DEB.2.02.1407041530420.25275@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407041530420.25275@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 03:35:54PM -0700, David Rientjes wrote:
> On Fri, 4 Jul 2014, Sasha Levin wrote:
> 
> > > Does this now reproduce on Linus's tree?  If so, does reverting commit
> > > 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") prevent this 
> > > issue?
> > > 
> > > This is a use-after-free since the poison value is 0x6b and I'm presuming 
> > > that your /proc/self/mountinfo may be larger than PAGE_SIZE in your 
> > > testing environment.
> > > 
> > 
> > Good call, reverting that patch made both issues go away.
> > 
> 
> Thanks for checking, Sasha.
> 
> Stable maintainers, please do not merge commit 058504edd026 ("fs/seq_file: 
> fallback to vmalloc allocation") that is annotated with a cc for 
> stable@vger.kernel.org in Linus's tree into stable kernels.
> 
> Although we're at 3.16-rc3, I'm hoping that we can get a fix for the 
> use-after-free in the next couple days before asking for a revert.  Sasha 
> confirms[*] this commit causes the bug.

I should also drop "Subject: /proc/stat: convert to single_open_size()"
from the -stable tree, right?

thanks,

greg k-h
