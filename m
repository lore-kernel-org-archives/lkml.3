Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3HATGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3HATGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:06:34 -0400
Date: Thu, 1 Aug 2013 15:05:56 -0400
From: Dave Jones <davej@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130801190556.GA1495@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Kees Cook <keescook@chromium.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130801091322.GA5302@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801091322.GA5302@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 12:13:22PM +0300, Dan Carpenter wrote:
 > I was just reading http://faultlinux.lip6.fr/ which says that in
 > 2011 the static checker fault rate in arch/ and fs/ was worse than
 > in drivers/

I've been working on getting more regular builds in coverity, so we can
get more meaningful statistics on things like "what area is getting worse".

Of the current bugs I've categorised so far, here's the breakdown for 3.11-rc3
in terms of highest bug counts.

Drivers/net/wireless: 659 
Drivers/ [1] : 600
Drivers/staging: 449
Drivers/scsi: 409
Drivers/net: 350
Net/[2] : 297
Drivers/media: 286
Sound: 220
Drivers/GPU: 217

That's the top categories for the whole kernel.

That wireless was top of the list was the least shocking thing to me,
based on what we get reported to Fedora bugzilla.  That it found more
bugs there than in staging was amusing though. The good news is that
wireless also takes the top slot for 'resolved' issues.

The paper above talks about 'arch' but doesn't indicate if it's counting
all arches, or just the one they run the tests on. (Coverity only covers x86,
so arch/ shows up in 10th place there).
FS doesn't show up on the list until 14th place, where there's a another
catchall category like [1][2]. The first actual fs category with the most
bugs is btrfs at 16th place, with 68 outstanding reports.

There's a lot of work to do picking through their database, including writing
modelling functions to reduce false positives. But, I'm on it.
I'll write up something a bit more in-depth later.

	Dave

[1] This is everything that doesn't match one of the more specific drivers category, 
    of which there's those mentioned above, plus about a dozen others.
[2] This is everything in net/ except for ipv4/ipv6/sctp, so all the weirdo protocols basically.

