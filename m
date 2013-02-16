Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3BPHnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 02:43:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37630 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 02:43:51 -0500
Date: Sat, 16 Feb 2013 07:43:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Raymond Jennings <shentino@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
Message-ID: <20130216074348.GC4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk>
 <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk>
 <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
 <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
 <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
 <20130216015024.GA4503@ZenIV.linux.org.uk>
 <20130216022006.GB4503@ZenIV.linux.org.uk>
 <CAGDaZ_oSzQOLsoeWQFNQ8R5-NBKPAUygvjvzvef9q40WBu1sWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGDaZ_oSzQOLsoeWQFNQ8R5-NBKPAUygvjvzvef9q40WBu1sWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:20:18PM -0800, Raymond Jennings wrote:

> An even bigger question might be why an execve is allowed to get into
> an unrecoverable state to begin with.  Assuming that one builds the
> new mm_struct and whatnot BEFORE discarding old state, why would
> execve be in a position for a fatal error in the first place?

When would you kill the rest of thread group?  Take a look at de_thread() -
we are not just replacing ->mm during execve().  Signal delivery logics,
etc.
