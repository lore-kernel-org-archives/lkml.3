Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLQMTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:19:14 -0500
Received: from chicago.guarana.org ([198.144.183.183]:49786 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaLQMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:19:13 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2014 07:19:13 EST
Date: Thu, 18 Dec 2014 00:11:30 +1100
From: Kevin Easton <kevin@guarana.org>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Minimal effort/low overhead file descriptor duplication over
 Posix.1b s
Message-ID: <20141217131130.GA15533@chicago.guarana.org>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 03:35:17PM +1100, Alex Dubov wrote:
> Unfortunately, using facilities like Unix domain sockets to merely pass file
> descriptors between "worker" processes is unnecessarily difficult, due to
> the following common consideration:
> 
> 1. Domain sockets and named pipes are persistent objects. Applications must
> manage their lifetime and devise unambiguous access schemes in case multiple
> application instances are to be run within the same OS instance. Usually, they
> would also require a writable file system to be mounted.

I believe this particular issue has long been addressed in Linux, with
the "abstract namespace" domain sockets.

These aren't persistent - they go away when the bound socket is closed -
and they don't need a writable filesystem.

If you derived the name in the abstract namespace from your PID (or better,
application identifier and PID) then you would have exactly the same
"ambiguous access" scheme as your proposal.

>     int sendfd(pid_t pid, int sig, int fd)

PIDs tend to be regarded as a bit of an iffy way to refer to another
process, because they tend to be racy.  If the process you think you're
talking to dies, and has its PID reused by another unrelated sendfd()-aware
process, you've just sent your open file to somewhere unexpected.

You can avoid that if the process is a child of yours, but in that case
you could have set up a no-fuss domain socket connection with socketpair()
too.

    - Kevin

