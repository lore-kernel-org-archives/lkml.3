Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab3DQHij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:38:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43976 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab3DQHih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:38:37 -0400
Date: Wed, 17 Apr 2013 09:38:31 +0200
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
Message-ID: <20130417073830.GA11807@pd.tnic>
References: <516A0652.8040505@intel.com>
 <20130414155925.GC20547@pd.tnic>
 <516B9859.70004@intel.com>
 <516B9B57.3030902@intel.com>
 <20130415095203.GA26524@pd.tnic>
 <516C059E.20800@intel.com>
 <20130415231206.GE12144@pd.tnic>
 <516C99BB.30309@intel.com>
 <20130416102405.GD5332@pd.tnic>
 <516DF864.7070005@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516DF864.7070005@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 09:18:28AM +0800, Alex Shi wrote:
> Sure. Currently if the whole socket get into sleep, but the memory on
> the node is still accessed. the cpu socket still spend some power on
> 'uncore' part. So the further step is reduce the remote memory access
> to save more power, and that is also numa balance want to do.

Yeah, if you also mean, you need to further migrate the memory of the
threads away from the node so that it doesn't need to serve memory
accesses from other sockets, then that should probably help save even
more power. You probably would still need to serve probes from the L3
but your DRAM links will be powered down and such.

> And then the next step is to detect if this socket is cache intensive,
> if there is much cache thresh on the node.

Yeah, that would be probably harder to determine - is cache thrashing
(and I think you mean L3 here) worse than migrating tasks to other nodes
and having them powered on just because my current node is not supposed
to thrash L3. Hmm.

> In theory, there is still has lots of tuning space. :)

Yep. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
