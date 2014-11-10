Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaKJXgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:36:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaKJXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:36:47 -0500
Date: Mon, 10 Nov 2014 15:36:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, jiri@resnulli.us,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Add --strict preference for #defines using
 BIT(foo)
Message-Id: <20141110153647.f98f7d60fa24bf3bf7cbc215@linux-foundation.org>
In-Reply-To: <1415394939.23530.20.camel@perches.com>
References: <1415265610-9338-1-git-send-email-jiri@resnulli.us>
	<1415265610-9338-10-git-send-email-jiri@resnulli.us>
	<20141107.151607.480474516800359791.davem@davemloft.net>
	<1415394939.23530.20.camel@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 13:15:39 -0800 Joe Perches <joe@perches.com> wrote:

> Using BIT(foo) and BIT_ULL(bar) is more common now.
> Suggest using these macros over #defines with 1<<value.

urgh.  I'm counting eightish implementations of BIT(), an unknown
number of which are actually being used.  Many use 1<<n, some use
1UL<<N, another uses 1ULL<<n.  I'm a bit reluctant to recommend that
anyone should use BIT() until it has has some vigorous scrubbing :(

Is it actually an improvement?  If I see

#define X	(1U << 7)

then I know exactly what it does.  Whereas when I see

#define X	BIT(7)

I know neither the size or the signedness of X so I have to go look it
up.


I have no strong feelings either way, but I'm wondering what might have
inspired this change?

