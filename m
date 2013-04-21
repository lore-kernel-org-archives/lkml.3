Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3DUTHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 15:07:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60768 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3DUTHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 15:07:01 -0400
Date: Sun, 21 Apr 2013 21:06:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421190655.GA5807@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130421185609.GD3509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 11:56:09AM -0700, Paul E. McKenney wrote:
> CONFIG_RCU_FAST_NO_HZ will definitely change the timing, for example,
> increasing grace-period durations by up to a factor of four.
>
> One way to figure out if this is the problem would be to either (1)
> apply the following patch (assuming you have no more than a few tens
> of CPUs)

Only 8 - I'm modest that way :)

> or (2) setting the sysfs rcutree.rcu_expedited variable to 1 just before
> suspending the system.
> 
> Either approach will force RCU to always use the faster expedited
> grace periods for synchronize_rcu() and friends.  They will -not- help
> if someone has open-coded synchronize_rcu() in terms of call_rcu(),
> though.

Right,

# echo 1 > /sys/kernel/rcu_expedited

helped.

No warning, no delay, 2 suspend/resume cycles back-to-back. So, a
probable fix could be to force-enable the expedited grace periods during
suspend...?

Hmmm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
