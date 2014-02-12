Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaBLBJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:09:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBLBJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:09:46 -0500
Date: Wed, 12 Feb 2014 01:09:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212010941.GM18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com>
 <20140211210841.GM13647@dastard>
 <52FA9ADA.9040803@sandeen.net>
 <20140212004403.GA17129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212004403.GA17129@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:44:03PM -0500, Dave Jones wrote:

> The 'good' news is I seem to be able to reproduce it fairly quickly.
> I've seen it 3-4 times this afternoon. (Always from the coredump path)
> 
> I was on vacation last week, but I wasn't hitting this before then, so it's a
> fairly recent change that's introduced this.

Slap the check in vfs_create(), see if interrupts had been disabled by it or
by something in ->create().  Since it's reproducible...
