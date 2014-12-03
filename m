Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaLCDkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:40:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42968 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLCDkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:40:22 -0500
Date: Wed, 3 Dec 2014 03:40:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
Message-ID: <20141203034020.GI29748@ZenIV.linux.org.uk>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
 <20141202170037.GG29748@ZenIV.linux.org.uk>
 <CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 01:22:33PM +1100, Alex Dubov wrote:

> On a less related note, I hope you will agree that the simpler
> mechanism for this very in-demand feature is long overdue on Linux
> (every man and his dog are passing fds around these days).

... and I'm less than sure that it's a good thing.  If nothing else,
once the pieces of your program are passing descriptors around freely,
you have created a barfball that will be impossible to split between
several boxen if you run into scalability issues.  Descriptor-passing
is limited to a single system; you *can't* do that between e.g. components
of a cluster.  So it's not an unmixed blessing, just as overuse of
shared memory segments, etc.  They do have their uses, but that needs
to be carefully considered every time, or you'll create a major headache
a few years down the road.
