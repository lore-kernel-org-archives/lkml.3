Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3HNVDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:03:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab3HNVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:03:40 -0400
Date: Wed, 14 Aug 2013 14:03:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] mm: make lru_add_drain_all() selective
Message-Id: <20130814140339.4489fd3efc7de3d0a5b21c4e@linux-foundation.org>
In-Reply-To: <20130814205029.GN28628@htj.dyndns.org>
References: <20130814200748.GI28628@htj.dyndns.org>
	<201308142029.r7EKTMRw023404@farm-0002.internal.tilera.com>
	<20130814134430.50cb8d609643620b00ab3705@linux-foundation.org>
	<20130814205029.GN28628@htj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 16:50:29 -0400 Tejun Heo <tj@kernel.org> wrote:

> > > +	for_each_cpu(cpu, &has_work)
> > 
> > for_each_online_cpu()?
> 
> That would lead to flushing work items which aren't used and may not
> have been initialized yet, no?

doh, I confused for_each_cpu with for_each_possible_cpu.  Dumb name.
