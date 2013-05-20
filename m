Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3ETGXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:23:52 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36083 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3ETGXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:23:51 -0400
Message-ID: <5199C169.7060504@linux.vnet.ibm.com>
Date: Mon, 20 May 2013 14:23:37 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130509125040.GF27333@pd.tnic> <20130509125859.GG27333@pd.tnic> <20130515184528.GO4442@linux.vnet.ibm.com> <20130515224358.GF11783@pd.tnic> <20130515235512.GT4442@linux.vnet.ibm.com> <20130517135641.GF23035@pd.tnic> <51999591.8030401@linux.vnet.ibm.com> <20130520045023.GA12690@pd.tnic>
In-Reply-To: <20130520045023.GA12690@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052006-2674-0000-0000-00000908A762
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 12:50 PM, Borislav Petkov wrote:
> On Mon, May 20, 2013 at 11:16:33AM +0800, Michael Wang wrote:
>> I suppose the reason is that the cpu we passed to
>> mod_delayed_work_on() has a chance to become offline before we
>> disabled irq, what about check it before send resched ipi? like:
> 
> I think this is only addressing the symptoms - what we should be doing
> instead is asking ourselves why are we even scheduling work on a cpu if
> the machine goes offline?
> 
> I don't know though who should be responsible for killing all that
> work - the workqueue itself or the guy who created it, i.e. cpufreq
> governor...

So there are two questions here:
1. Is gov_queue_work() want to queue the work on offline cpu?
2. Is mod_delayed_work_on() allow offline cpu?

I guess both should be false?

Regards,
Michael Wang

> 
> Hmmm.
> 

