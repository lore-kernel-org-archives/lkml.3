Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3LTRwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:52:40 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:45569
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab3LTRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:52:38 -0500
Date: Fri, 20 Dec 2013 11:52:36 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Chinner <david@fromorbit.com>
cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [fs] inode_lru_isolate(): Move counter increment into spinlock
 section
In-Reply-To: <20131220033502.GF31386@dastard>
Message-ID: <alpine.DEB.2.10.1312201149410.13718@nuc>
References: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com> <20131219042322.GX31386@dastard> <alpine.DEB.2.10.1312190921450.4238@nuc> <20131220033502.GF31386@dastard>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Dave Chinner wrote:

> > Moving the code is IMHO the simplest solution. count_vm_events
> > will have to disable interrupts on platforms that do not support fast RMV
> > operations otherwise.
>
> If count_vm_events requires irqs to be disabled to behave correctly,
> then putting __count_vm_events under a spin lock is still not irq
> safe. Either way, this isn't in a performance critical path, so I'd
> much prefer the simpler, safer option be used rather than leave a
> landmine for other unsuspecting developers.

What we need is just preempt safeness. But there are no operations that
are just preempt safe and not interrupt safe (operations were removed
since seen as too excessive). So we fall back to interrupt
safe.

