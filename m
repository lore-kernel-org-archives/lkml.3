Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3CFKeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:34:13 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53301 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3CFKeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:34:10 -0500
Date: Wed, 6 Mar 2013 11:34:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: access percpu variable too early
Message-ID: <20130306103406.GB16827@gmail.com>
References: <CACVXFVNzN721wGm96SroK6cm4E08gs+tJtELsHvxVTCXZtX95g@mail.gmail.com>
 <20130306102057.GB6587@gmail.com>
 <CACVXFVMN8=6aLf2NGaLCiLjH+yy7wSmWyRG0w09--0au1vGnLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMN8=6aLf2NGaLCiLjH+yy7wSmWyRG0w09--0au1vGnLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ming Lei <ming.lei@canonical.com> wrote:

> On Wed, Mar 6, 2013 at 6:20 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > What's the practical effect of it? Do we copy the value from the boot CPU and 
> > thus the secondary CPUs start with slightly increased stats?
> 
> Yes, it is the major effect.
> 
> Also the arch dependent __my_cpu_offset might be initialized a bit late.

I suspect we could try to fix it - post-initializing it after percpu setup sounds 
like a viable option, if it does not get too ugly.

Thanks,

	Ingo
