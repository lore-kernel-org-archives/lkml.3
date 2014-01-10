Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbaAJPYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:24:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaAJPYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:24:15 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 0/6] Page I/O
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 10 Jan 2014 10:24:07 -0500
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
	(Matthew Wilcox's message of "Thu, 9 Jan 2014 21:39:45 -0500")
Message-ID: <x49ha9bhnc8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew.r.wilcox@intel.com> writes:

> This patch set implements pageio as I described in my talk at
> Linux.Conf.AU.  It's for review more than application, I think
> benchmarking is going to be required to see if it's a win.  We've done
> some benchmarking with an earlier version of the patch and a Chatham card,
> and it's a win for us.
>
> The fundamental point of these patches is that we *can* do I/O without
> allocating a BIO (or request, or ...) and so we can end up doing fun
> things like swapping out a page without allocating any memory.
>
> Possibly it would be interesting to do sub-page I/Os (ie change the
> rw_page prototype to take a 'start' and 'length' instead of requiring the
> I/O to be the entire page), but the problem then arises about what the
> 'done' callback should be.

For those of us who were not fortunate enough to attend your talk, would
mind providing some background, like why you went down this path in the
first place, and maybe what benchmarks you ran where you found it "a
win?"

Another code path making an end-run around the block layer is
interesting, but may keep cgroup I/O throttling from working properly,
for example.

Cheers,
Jeff
