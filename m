Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaJZDGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 23:06:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41813 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaJZDGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 23:06:12 -0400
Date: Sun, 26 Oct 2014 03:06:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
Message-ID: <20141026030608.GN7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
 <87siibttyi.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siibttyi.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 08:01:41PM -0700, Eric W. Biederman wrote:
> Sasha Levin <sasha.levin@oracle.com> writes:
> 
> > Hi all,
> >
> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > kernel, I've stumbled on the following spew:
> 
> Weird.  I took a quick look and I don't see any changes in d_walk that
> in Al's tree or in Linus's kernel for years.
> 
> Has read_seqbegin_or_lock changed somewhere?
> 
> >From a quick reading of the code it simply isn't possible for d_walk to
> take the lock twice short of memory corruption.  And the fact that the
> code has not changed in years seems to suggest it isn't the obvious
> cause of d_walk talking the rename_lock twice.

It is a fairly obvious case of d_walk() forgetting to drop rename_lock.
See upthread for analysis and (hopefully) a fix.
