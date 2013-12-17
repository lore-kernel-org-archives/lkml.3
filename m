Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3LQNvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:51:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab3LQNv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:51:29 -0500
Date: Tue, 17 Dec 2013 08:50:55 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 6/6] locks: add new "private" lock type that is owned
 by the filp
Message-ID: <20131217085055.1e89965c@tlielax.poochiereds.net>
In-Reply-To: <20131217133721.GA16724@infradead.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
	<1386703055-22308-7-git-send-email-jlayton@redhat.com>
	<20131217083125.4ce0382b@tlielax.poochiereds.net>
	<20131217133721.GA16724@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013 05:37:21 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Dec 17, 2013 at 08:31:25AM -0500, Jeff Layton wrote:
> > So, I think the above semantics are pretty clear, but now that I've had
> > a go at sitting down to document this stuff for the POSIX spec and
> > manpages, it's clear how convoluted the text in there is becoming.
> > 
> > That makes me wonder...would we be better off with a new set of cmd
> > values here instead of new l_type values? IOW, we could add new:
> > 
> > F_GETLKP
> > F_SETLKP
> > F_SETLKPW
> 
> That seems a tad cleaner to me indeed.
> 
> > ...and then just reuse the same F_RDLCK/F_WRLCK/F_UNLCK values? With
> > that too, we could create a new equivalent to struct flock that has
> > fixed length types instead of dealing with the off_t mess.
> 
> For the Posix interface you'd need an off_t as that's what the whole
> API uses for file offsets.  We could make sure to always use a off64_t
> for the kernel interface though.
> 

Ok.

> What is the API you propose to posix?  An new posix_lockf?
> 

I haven't proposed anything concrete to POSIX just yet. I'm trying to
get the Linux patches done and then I'll do that. I don't think we want
a new syscall when fcntl() will work.

If we use new cmd values however, then we don't necessarily need to use
struct flock/flock64. I think the question is -- should we stick with
struct flock/flock64, or would we be better served with something new
for this?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
