Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaKZApJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:45:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaKZApG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:06 -0500
Message-ID: <1416962697.2509.60.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 26 Nov 2014 08:44:57 +0800
In-Reply-To: <1416959452.2509.52.camel@pluto.fritz.box>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	 <20141125010734.4974.85347.stgit@pluto.fritz.box>
	 <20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
	 <87y4qy7wci.fsf@x220.int.ebiederm.org>
	 <1416956845.2509.38.camel@pluto.fritz.box>
	 <871toq7tr6.fsf@x220.int.ebiederm.org>
	 <1416959452.2509.52.camel@pluto.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 07:50 +0800, Ian Kent wrote:
> > 
> > If we are going to set this stuff up in the kernel we need a reference
> > process that we can create children of because what is possible with
> > respect to containers keeps changing, and it is extremely error prone to
> > figure out what all othe crazy little bits are, and to update everything
> > every time someone tweaks the kernel's capabilities.  We have kthreadd
> > because it was too error prone to scrub a userspace thread of all of the
> > userspace bits and make it the equivalent of what kthreadd is today.
> > 
> > Of course it is also rather nice to have something to hang everything
> > else on.
> > 
> > In summary we need a reference struct task that is all setup properly
> > so that we can create an appropriate kernel thread.
> 
> I'm having trouble understanding what your getting at here but I'm not
> that sharp so bear with me.
> 
> When call_usermodehelper() is called it's called from a process that is
> within the context within which the execution is required.

Umm .. OK, that's probably not quite right either ....

For nfsd I think it's OK but for nfs clients the context is probably
that of the caller ....

Whereas the helper to get a key info maybe does need to be called in the
context of the caller .....

> 
> So what information do we not have available for setup?
> 
> Are you saying that the problem is that when the user mode helper run
> thread is invoked we don't have the information available that was
> present when call_usermodehelper() was called and that's where the
> challenge lies?
> 
> Ian
> 


