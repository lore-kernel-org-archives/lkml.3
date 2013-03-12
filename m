Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab3CLXLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:11:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:62010 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933487Ab3CLXLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="301259356"
Date: Wed, 13 Mar 2013 07:09:50 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v4 4/4] timekeeping: utilize the suspend-nonstop
 clocksource to count suspended time
Message-ID: <20130312230950.GA10222@feng-snb>
References: <1363060608-22657-1-git-send-email-feng.tang@intel.com>
 <1363060608-22657-5-git-send-email-feng.tang@intel.com>
 <513F9974.8010909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513F9974.8010909@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:09:08PM -0700, John Stultz wrote:
> On 03/11/2013 08:56 PM, Feng Tang wrote:
 >  	}
> >-	/* re-base the last cycle value */
> >-	tk->clock->cycle_last = tk->clock->read(tk->clock);
> >+
> >+	if (suspendtime_found)
> >+		__timekeeping_inject_sleeptime(tk, &ts_delta);
> >+
> >+	/* Re-base the last cycle value */
> >+	clock->cycle_last = clock->read(clock);
> It seems like since we unconditionally read the clock above, this
> last line could be reworked to be:
>     clock->cycle_last = cycle_now;
> 
> Which would save re-reading the clocksource.
> 
> If you don't have any objections I'll fold that small change into
> your patch.

No objection at all. Thanks!

- Feng
