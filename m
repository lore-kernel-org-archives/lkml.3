Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaIVOM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:12:26 -0400
Received: from tex.lwn.net ([70.33.254.29]:51759 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaIVOMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:12:24 -0400
Date: Mon, 22 Sep 2014 10:12:21 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
Message-ID: <20140922101221.4bf46809@lwn.net>
In-Reply-To: <CANP1eJEhHyA93kDUCz_=0vDjdPXz7g0x1SmW+q060fntQAbrYA@mail.gmail.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<20140919104204.3b0bb762@lwn.net>
	<CANP1eJEhHyA93kDUCz_=0vDjdPXz7g0x1SmW+q060fntQAbrYA@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 13:33:14 -0400
Milosz Tanski <milosz@adfin.com> wrote:

> >  - Non-blocking I/O has long been supported with a well-understood set
> >    of operations - O_NONBLOCK and fcntl().  Why do we need a different
> >    mechanism here - one that's only understood in the context of
> >    buffered file I/O?  I assume you didn't want to implement support
> >    for poll() and all that, but is that a good enough reason to add a
> >    new Linux-specific non-blocking I/O technique?  
> 
> I realized that I didn't answer this question well in my other long
> email. O_NONBLOCK doesn't work on files under any commonly used OS,
> and people have gotten use to this behavior so I doubt we could change
> that without breaking a lot of folks applications.

So I'm not contesting this, but I am genuinely curious: do you think
there are applications out there requesting non-blocking behavior on
regular files that will then break if they actually get non-blocking
behavior?  I don't suppose you have an example?

Thanks,

jon
