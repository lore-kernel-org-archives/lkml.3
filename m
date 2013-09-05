Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3IETIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:08:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:55218 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab3IETIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:08:38 -0400
Date: Thu, 5 Sep 2013 15:08:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext4: cache all of an extent tree's leaf block upon reading
Message-ID: <20130905190837.GD23661@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130905013848.42DD7660EE1@gitolite.kernel.org>
 <20130905143749.GA15894@redhat.com>
 <20130905145334.GB23661@thunk.org>
 <20130905151457.GA24177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905151457.GA24177@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 11:14:57AM -0400, Dave Jones wrote:
>  > So the only reason to add a line explicitly setting es_pblk to zero
>  > would be to suppress a warning from some insufficiently smart static
>  > code analysis tool.  I didn't see a warning from gcc, but it's
>  > possible that this is something which is causing Coverity or some
>  > other code scanner heartburn.
> 
> Yep, that's what picked it up.  I'll add a 'not a bug' annotation to stop
> it getting flagged again.  This was the only ext* issue that Coverity
> picked up from yesterdays merge btw, which I guess is good news ;)

Indeed.

Hmm...  I could add a new inline function
"ext4_es_store_pblock_status()" which sets both parts of the es_pblk
word at once, and which doesn't depend looking at its original value
at all.  I doubt we would never measure a difference in performance,
but in theory it would be more efficient.  And if it eliminates a
potential static code analysis complaint, maybe the two justifications
is good enough to add the new function.

Thanks for checking the coverity results!!

						- Ted
