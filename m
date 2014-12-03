Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaLCWx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:53:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaLCWx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:53:56 -0500
Message-ID: <1417647226.2581.17.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
From: Ian Kent <ikent@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Coddington <bcodding@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 04 Dec 2014 06:53:46 +0800
In-Reply-To: <87zjb4k7b6.fsf@x220.int.ebiederm.org>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	 <20141125010734.4974.85347.stgit@pluto.fritz.box>
	 <20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
	 <87y4qy7wci.fsf@x220.int.ebiederm.org>
	 <1416956845.2509.38.camel@pluto.fritz.box>
	 <871toq7tr6.fsf@x220.int.ebiederm.org>
	 <1416959452.2509.52.camel@pluto.fritz.box>
	 <87egsq3fna.fsf@x220.int.ebiederm.org>
	 <alpine.LRH.2.11.1412011607450.2583@sh-el6.eng.rdu2.redhat.com>
	 <1417563215.2531.25.camel@pluto.fritz.box>
	 <87zjb4k7b6.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 10:49 -0600, Eric W. Biederman wrote:
> 
> >> > Those are the general parameters.
> >> 
> >> It does seem very expensive to keep a thread around for every mount; I'm
> >> still trying to find a way around it..
> >
> > Yeah, that's not such a good idea.
> >
> > Several hundred mounts is going to create a big mess for system
> > administrators, not to mention the overhead. It's right up there with
> > symlinking /etc/mtab to /proc/self/mounts at sites with large direct
> > mount maps.
> 
> A thread will cost you maybe 40k.  In the grand scheme of things that
> really isn't a lot.  I agree that it would be nice to do better than
> one thread per mount.   But I start with a thread as a reference point
> as that is the trivial way to get things correct.

Sure it has merit because it's straight forward but my criticism isn't
about overhead. It's about system administrators annoyance and
frustration level when they're trying get things done.

For example, with the symlinking of the mount table and even just a few
hundred direct automounts, listing the mount table fills the screen with
tombs of stuff that really should be hidden (and only listed if
requested). That just gets in the way when you're trying desperately to
resolve some urgent problem.

There is a resource issue as well since so many site administration
applications will read the table and, as the number of entries gets
larger, so does the time these things take to run. Not having to deal
with this on a day to day basis tends to make us forget about these
little side issues but I think they are important. 

Point is, for process listings the issue is almost exactly the same.

Ian

