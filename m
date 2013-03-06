Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3CFKVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:21:06 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39468 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3CFKVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:21:02 -0500
Date: Wed, 6 Mar 2013 11:20:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: access percpu variable too early
Message-ID: <20130306102057.GB6587@gmail.com>
References: <CACVXFVNzN721wGm96SroK6cm4E08gs+tJtELsHvxVTCXZtX95g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNzN721wGm96SroK6cm4E08gs+tJtELsHvxVTCXZtX95g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ming Lei <ming.lei@canonical.com> wrote:

> Hi,
> 
> The percpu variables of 'lockdep_stats' and 'cpu_lock_stat' may be accessed before 
> percpu area is brought up in case of CONFIG_DEBUG_LOCKDEP/CONFIG_LOCK_STAT, so 
> these variables in non-boot CPUs will be initialized incorrectly.

What's the practical effect of it? Do we copy the value from the boot CPU and thus 
the secondary CPUs start with slightly increased stats?

Thanks,

	Ingo
