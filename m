Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaCLJV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:21:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaCLJV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:21:27 -0400
Date: Wed, 12 Mar 2014 10:21:25 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Bohac <jbohac@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312092125.GA30305@midget.suse.cz>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
 <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
 <531F8605.10003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531F8605.10003@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 02:54:13PM -0700, John Stultz wrote:
> Ok, so a generic solution is probably not going to be worth it then. My
> thought was that since we do a very limited amount of informational
> printks in the timekeeping code, we can be fairly safe delaying the
> print-out until we drop the locks.
> 
> For timekeeping, its really 4 call sites:
> * invalid inject_sleep_time deltas
> * > 11% clocksource freq adjustments
> * insert leap second
> * delete leap second

I believe these last two were made safe by 
commit ca4523cd (timekeeping: Shorten seq_count region). 

write_seqcount_begin(&timekeeper_seq) is now done after the
accumulate_nsecs_to_secs(tk) from where the printks are called.

Regards,

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

