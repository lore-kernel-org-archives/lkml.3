Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab3HMVQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:16:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124Ab3HMVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:16:23 -0400
Date: Tue, 13 Aug 2013 14:16:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] mm: make lru_add_drain_all() selective
Message-Id: <20130813141621.3f1c3415901d4236942ee736@linux-foundation.org>
In-Reply-To: <20130813210719.GB28996@mtj.dyndns.org>
References: <5202CEAA.9040204@linux.vnet.ibm.com>
	<201308072335.r77NZZwl022494@farm-0012.internal.tilera.com>
	<20130812140520.c6a2255d2176a690fadf9ba7@linux-foundation.org>
	<52099187.80301@tilera.com>
	<20130813123512.3d6865d8bf4689c05d44738c@linux-foundation.org>
	<20130813201958.GA28996@mtj.dyndns.org>
	<20130813133135.3b580af557d1457e4ee8331a@linux-foundation.org>
	<20130813210719.GB28996@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 17:07:19 -0400 Tejun Heo <tj@kernel.org> wrote:

> > I don't recall seeing such abuse.  It's a very common and powerful
> > tool, and not implementing it because some dummy may abuse it weakens
> > the API for all non-dummies.  That allocation is simply unneeded.
> 
> More powerful and flexible doesn't always equal better and I think
> being simple and less prone to abuses are important characteristics
> that APIs should have.

I've yet to see any evidence that callback APIs have been abused and
I've yet to see any reasoning which makes me believe that this one will
be abused.

>  It feels a bit silly to me to push the API
> that way when doing so doesn't even solve the allocation problem.

It removes the need to perform a cpumask allocation in
lru_add_drain_all().

>  It doesn't really buy us much while making the interface more complex.

It's a superior interface.
