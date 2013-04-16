Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749Ab3DPKYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:24:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54635 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab3DPKYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:24:08 -0400
Date: Tue, 16 Apr 2013 12:24:05 +0200
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
Message-ID: <20130416102405.GD5332@pd.tnic>
References: <5167C9FA.8050406@intel.com>
 <20130412162348.GE2368@pd.tnic>
 <516A0652.8040505@intel.com>
 <20130414155925.GC20547@pd.tnic>
 <516B9859.70004@intel.com>
 <516B9B57.3030902@intel.com>
 <20130415095203.GA26524@pd.tnic>
 <516C059E.20800@intel.com>
 <20130415231206.GE12144@pd.tnic>
 <516C99BB.30309@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <516C99BB.30309@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 08:22:19AM +0800, Alex Shi wrote:
> testing has a little variation, but the power data is quite accurate.
> I may change to packing tasks per cpu capacity than current cpu
> weight. that should has better power efficient value.

Yeah, this probably needs careful measuring - and by "this" I mean how
to place N tasks where N is less than number of cores in the system.

I can imagine trying to migrate them all together on a single physical
socket (maybe even overcommitting it) so that you can flush the caches
of the cores on the other sockets and so that you can power down the
other sockets and avoid coherent traffic from waking them up, to be one
strategy. My supposition here is that maybe putting the whole unused
sockets in a deep sleep state could save a lot of power.

Or not, who knows. Only empirical measurements should show us what
actually happens.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
