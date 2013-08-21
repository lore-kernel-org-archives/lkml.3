Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3HUOXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:23:48 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:18763 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUOXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:23:47 -0400
Date: Wed, 21 Aug 2013 16:24:00 +0200
From: David Jander <david.jander@protonic.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Message-ID: <20130821162400.66c5b52e@archvile>
In-Reply-To: <20130821140816.GC26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
	<20130821151423.70c38fb3@archvile>
	<20130821140816.GC26118@sirena.org.uk>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 15:08:16 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Wed, Aug 21, 2013 at 03:14:23PM +0200, David Jander wrote:
> 
> > Here's the explanation:
> 
> > 1. If a driver initializes a regmap with a RB-tree cache, and starts
> > writing to registers in some arbitrary order, you might get overlapping
> > rbnodes: Suppose I have this rb-tree (a real case I happen to have):
> 
> > # cat /sys/kernel/debug/regmap/1-000a/rbtree
> > 2-19 (24)
> > 4-1b (24)
> 
> Like I say this isn't supposed to be the case in the first place, those
> two nodes should be being merged - what we need to understand is where
> the overlapping nodes came from.

As I said in my last e-mail just a few seconds ago, it does happen when:

1. 4-1b is cached and 2-19 isn't yet.

2. A write access to register 2 occurs.

Hope this helps.

Best regards,

-- 
David Jander
Protonic Holland.
