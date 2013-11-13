Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3KMEXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:23:16 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:50157 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755444Ab3KMEXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:23:08 -0500
X-AuditID: 12074424-b7fa56d000000be4-ff-5282feabfc0f
Date: Tue, 12 Nov 2013 23:23:03 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131113042303.GY8043@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
 <20131112042444.GC30281@thunk.org>
 <20131112224009.GX8043@ringworld.MIT.EDU>
 <20131113033205.GA9214@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113033205.GA9214@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsUixG6norv6X1OQwYdzIhbTNopb7J6zmMXi
	8q45bA7MHmcWHGH3+LxJzuNEyxfWAOYoLpuU1JzMstQifbsErox/P/4wFrxkq7j8xbGBcSdr
	FyMnh4SAicSeVV3MELaYxIV769m6GLk4hARmM0kc+LOLHSQhJLCRUeLnzmCIxC9Gif/3WlhA
	EiwCqhJrNm5hBLHZBBQkfsxfxwxSJCLQzSjRdGQ/WLewgIHErp1dYA28AqYSHdP+Q61YyijR
	t20dO0RCUOLkzCdgRcwCWhI3/r1k6mLkALKlJZb/4wAJcwroSSx81QJWLiqgIjHl5Da2CYwC
	s5B0z0LSPQuhewEj8ypG2ZTcKt3cxMyc4tRk3eLkxLy81CJdc73czBK91JTSTYzgsHVR2cHY
	fEjpEKMAB6MSD69FTFOQEGtiWXFl7iFGSQ4mJVHelr9AIb6k/JTKjMTijPii0pzU4kOMEhzM
	SiK80u+AcrwpiZVVqUX5MClpDhYlcd5bHPZBQgLpiSWp2ampBalFMFkZDg4lCd4zIEMFi1LT
	UyvSMnNKENJMHJwgw3mAhj8FqeEtLkjMLc5Mh8ifYlSUEudNAkkIgCQySvPgemFp5RWjONAr
	wryvQKp4gCkJrvsV0GAmoMEWxWCDSxIRUlINjEFnPpnMtFIT7WRY5VUzt3jnoimZIaVMJzzy
	dgXqHtt17Lf3pgd/NJVeOBcsrZp42dZJM/rJ2cNmD5fKR09hi9UU9izgn2egO4lF5s6zDnv+
	9ikf7USFsvWkGZS+yUxXeH6zxvWhttCmOcwNDHI7bt9pkrr5fJ7/wRWGhZ76Yf5HT72yalrw
	V4mlOCPRUIu5qDgRAI3BH50GAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:32:05PM -0500, Theodore Ts'o wrote:
> One of the things I've been thinking about with respect to making
> /dev/urandom block is being able to configure (via a module parameter
> which could be specified on the boot command line) which allows us to
> set a limit for how long /dev/urandom will block after which we log a
> high priority message that there was an attempt to read from
> /dev/urandom which couldn't be satisified, and then allowing the
> /dev/urandom read to succed.
> 
> The basic idea is that we don't want to break systems, but we do want
> to gently coerce people to do the right thing.  Otherwise, I'm worried
> that distros, or embedded/mobile/consume electronics engineers would
> just patch out the check.

That's a good idea.  I've worried about the same thing, but hadn't
thought of that solution.

Greg
