Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbaDJRvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:51:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:48193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaDJRvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:51:53 -0400
Message-ID: <1397152289.4757.28.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] coccinelle: add pycocci wrapper for multithreaded
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
        backports@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 19:51:29 +0200
In-Reply-To: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140410_194829_100293_32EF0060)
References: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140410_194829_100293_32EF0060)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 10:48 -0700, Luis R. Rodriguez wrote:

> You just pass it a cocci file, a target dir, and in git environments
> you always want --in-place enabled. Experiments and profiling random
> cocci files with the Linux kernel show that using just using number of
> CPUs doesn't scale well given that lots of buckets of files don't require
> work, as such this uses 10 * number of CPUs for its number of threads.
> For work that define more general ruler 3 * number of CPUs works better,
> but for smaller cocci files 3 * number of CPUs performs best right now.
> To experiment more with what's going on with the multithreading one can enable
> htop while kicking off a cocci task on the kernel, we want to keep
> these CPUs busy as much as possible. 

That's not really a good benchmark, you want to actually check how
quickly it finishes ... If you have some IO issues then just keeping the
CPUs busy trying to do IO won't help at all.


> Since its just a helper I toss it into the python directory but don't
> install it. Hope is that we can evolve it there instead of carrying this
> helper within backports.

If there's a plan to make coccinelle itself multi-threaded, what's the
point?

johannes

