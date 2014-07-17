Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbaGQRBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:01:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:41371 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713AbaGQRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:01:31 -0400
Date: Thu, 17 Jul 2014 13:01:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717170115.GO1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-abi@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717161215.GA14951@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 09:12:15AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:
> > The getrandom(2) system call was requested by the LibreSSL Portable
> > developers.  It is analoguous to the getentropy(2) system call in
> > OpenBSD.
> 
> What's the reason to not implement exactly the same system call OpenBSD
> does?  Having slightly different names and semantics for the same
> functionality is highly annoying.

The getrandom(2) system call is a superset of getentropy(2).  When we
add the support for this into glibc, it won't be terribly difficult
nor annoying to drop the following in alongside the standard support
needed for any new system call:

int getentropy(void *buf, size_t buflen)
{
	int	ret;

	ret = getentropy(buf, buflen, 0);
	return (ret > 0) ? 0 : ret;
}

The reason for the additional flags is that I'm trying to solve more
problems than just getentropy()'s raison d'etre.  The discussion of
this is in the commit description; let me know if there bits that I
could make clearer.

Cheers,

					- Ted
