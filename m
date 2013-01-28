Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3A1LVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:21:52 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37908 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1LVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:21:50 -0500
Date: Mon, 28 Jan 2013 12:21:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched: minimalist select_idle_sibling() bouncing cow
 syndrome fix
Message-ID: <20130128112145.GA23495@gmail.com>
References: <1359273021.5803.80.camel@marge.simpson.net>
 <20130128105304.GC20263@gmail.com>
 <1359371965.5783.127.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359371965.5783.127.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> On Mon, 2013-01-28 at 11:53 +0100, Ingo Molnar wrote: 
> > * Mike Galbraith <bitbucket@online.de> wrote:
> > 
> > > If the previous CPU is cache affine and idle, select it.
> > 
> > No objections in principle - but would be nice to have a 
> > changelog with numbers, % of improvement included and so?
> 
> Well, that like was my changelog, guess it needs improvement.
> 
> Take 2.
> 
> sched: minimalist select_idle_sibling() bouncing cow syndrome fix
> 
> If the previous CPU is cache affine and idle, select it.
> 
> The current implementation simply traverses the sd_llc domain,
> taking the first idle CPU encountered, which walks buddy pairs
> hand in hand over the package, inflicting excruciating pain.
> 
> 1 tbench pair (worst case) in a 10 core + SMT package:
> 
> pre   15.22 MB/sec 1 procs
> post 252.01 MB/sec 1 procs

Drool ... :-)

What would be a 'contrarian' test - i.e. a test where this could 
hurt most?

Thanks,

	Ingo
