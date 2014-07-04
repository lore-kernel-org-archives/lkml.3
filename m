Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031657AbaGDWgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:36:02 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34393 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030886AbaGDWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:35:57 -0400
Date: Fri, 4 Jul 2014 15:35:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>, stable@vger.kernel.org
cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [stable] please do not merge 058504edd026 (was Re: fs: use after
 free in /proc/pid/mountinfo)
In-Reply-To: <53B6C051.2060704@oracle.com>
Message-ID: <alpine.DEB.2.02.1407041530420.25275@chino.kir.corp.google.com>
References: <53B3F331.7090204@oracle.com> <53B4CAB8.5070407@oracle.com> <alpine.DEB.2.02.1407031434470.10658@chino.kir.corp.google.com> <53B6C051.2060704@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014, Sasha Levin wrote:

> > Does this now reproduce on Linus's tree?  If so, does reverting commit
> > 058504edd026 ("fs/seq_file: fallback to vmalloc allocation") prevent this 
> > issue?
> > 
> > This is a use-after-free since the poison value is 0x6b and I'm presuming 
> > that your /proc/self/mountinfo may be larger than PAGE_SIZE in your 
> > testing environment.
> > 
> 
> Good call, reverting that patch made both issues go away.
> 

Thanks for checking, Sasha.

Stable maintainers, please do not merge commit 058504edd026 ("fs/seq_file: 
fallback to vmalloc allocation") that is annotated with a cc for 
stable@vger.kernel.org in Linus's tree into stable kernels.

Although we're at 3.16-rc3, I'm hoping that we can get a fix for the 
use-after-free in the next couple days before asking for a revert.  Sasha 
confirms[*] this commit causes the bug.

Thanks.

 [*] http://marc.info/?l=linux-kernel&m=140448573612154
