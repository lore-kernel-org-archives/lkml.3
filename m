Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3LQNhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:37:23 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3LQNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:37:22 -0500
Date: Tue, 17 Dec 2013 05:37:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 6/6] locks: add new "private" lock type that is owned
 by the filp
Message-ID: <20131217133721.GA16724@infradead.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
 <1386703055-22308-7-git-send-email-jlayton@redhat.com>
 <20131217083125.4ce0382b@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217083125.4ce0382b@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 08:31:25AM -0500, Jeff Layton wrote:
> So, I think the above semantics are pretty clear, but now that I've had
> a go at sitting down to document this stuff for the POSIX spec and
> manpages, it's clear how convoluted the text in there is becoming.
> 
> That makes me wonder...would we be better off with a new set of cmd
> values here instead of new l_type values? IOW, we could add new:
> 
> F_GETLKP
> F_SETLKP
> F_SETLKPW

That seems a tad cleaner to me indeed.

> ...and then just reuse the same F_RDLCK/F_WRLCK/F_UNLCK values? With
> that too, we could create a new equivalent to struct flock that has
> fixed length types instead of dealing with the off_t mess.

For the Posix interface you'd need an off_t as that's what the whole
API uses for file offsets.  We could make sure to always use a off64_t
for the kernel interface though.

What is the API you propose to posix?  An new posix_lockf?

