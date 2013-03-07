Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab3CGWDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:03:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab3CGWDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:03:49 -0500
Date: Thu, 7 Mar 2013 17:03:33 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: ipc/testmsg GPF.
Message-ID: <20130307220333.GA31039@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	David Miller <davem@davemloft.net>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:45:27PM -0800, Linus Torvalds wrote:
 > Adding Davem to the list, since this looks like networking.
 > 
 > That said, I'm also starting to wonder if you're just triggering odd
 > bugs because of some use-after-free corruption of random kernel data
 > structures?

Plausible. The sheer volume of crashes I've started seeing in the last 24 hours
since adding those small features to trinity are making me really suspicious.
If I had this volume of crashes reported to me by a Fedora user, I'd be
suspecting their hardware ;)

Tangentally related: We have a *ton* of weird bug reports against Fedora
that have been open for a while that look like random memory corruption
(linked list corruption, 'bad page table' scribbles etc).
I'd *love* to think that the bugs I'm now seeing are related, on the off-chance
we can finally get some resolution on those.

 > I seem to have a dim memory of you usually doing your
 > trinity runs with more debugging options, but based on just the oops
 > message you don't have DEBUG_PAGEALLOC enabled, for example. Maybe
 > that and SLUB debugging might turn up the culprit more quickly..

My kernel-hacker hive-mind implant is working. Just started a rebuild with that enabled.
Had slub debug already.

 > [ Just checked - yes, you often do have DEBUG_PAGEALLOC in your oops
 > reports, but not this time. list debugging too? ]

Yep.

	Dave

