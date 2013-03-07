Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3CGEAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:00:17 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60438 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3CGEAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:00:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130307034454.GE25137@mudshark.cambridge.arm.com>
References: <1362624468-5451-1-git-send-email-tom.leiming@gmail.com>
	<20130307034454.GE25137@mudshark.cambridge.arm.com>
Date: Thu, 7 Mar 2013 12:00:14 +0800
Message-ID: <CACVXFVOcacLS82Mw1uMmC=VhYPkzqzdHnXa93QqZjAOz2gfM3w@mail.gmail.com>
Subject: Re: [RFC PATCH] ARM: keep __my_cpu_offset consistent with generic one
From: Ming Lei <tom.leiming@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 7, 2013 at 11:44 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> For the record, can you include a backtrace or something please? The

lock_release_holdtime() will access percpu variable, so every lock
release may trigger the hang if CONFIG_LOCK_STAT is enabled,
and there are many lock acquire/release before setup_arch.

No detailed backtrace since only early_printk can work at that time.

> description makes it sounds like a caller bug, so it would be good to
> document a valid user of per-cpu before cpu_init().

OK, I will add the document: lockdep will use percpu variable
before cpu_init() called inside setup_arch().

Thanks,
-- 
Ming Lei
