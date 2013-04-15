Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218Ab3DOXMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:12:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48206 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440Ab3DOXMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:12:10 -0400
Date: Tue, 16 Apr 2013 01:12:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
Message-ID: <20130415231206.GE12144@pd.tnic>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
 <516724F5.20504@kernel.org>
 <5167C9FA.8050406@intel.com>
 <20130412162348.GE2368@pd.tnic>
 <516A0652.8040505@intel.com>
 <20130414155925.GC20547@pd.tnic>
 <516B9859.70004@intel.com>
 <516B9B57.3030902@intel.com>
 <20130415095203.GA26524@pd.tnic>
 <516C059E.20800@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516C059E.20800@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 09:50:22PM +0800, Alex Shi wrote:
> For fairness and total threads consideration, powersaving cost quit
> similar energy on kbuild benchmark, and even better.
> 
> 	    17348.850		    27400.458		   15973.776
> 	    13737.493		    18487.248		   12167.816

Yeah, but those lines don't look good - powersaving needs more energy
than performance.

And what is even crazier is that fixed 1.2 GHz case. I'd guess in
the normal case those cores are at triple the freq. - i.e. somewhere
around 3-4 GHz. And yet, 1.2 GHz eats almost *double* the power than
performance and powersaving.

So for the x=8 and maybe even the x=16 case we're basically better off
with performance.

Or could it be that the power measurements are not really that accurate
and those numbers above are not really correct?

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
