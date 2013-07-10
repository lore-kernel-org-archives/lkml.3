Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3GJGFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:05:05 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35696 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3GJGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:05:03 -0400
Message-ID: <51DCF982.4070707@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 14:04:50 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
References: <1443144.WnBWEpaopK@amdc1032> <51DB724F.9050708@linux.vnet.ibm.com>	<1754044.EVIH1UZj6p@amdc1032> <51DC0B0D.9070201@linux.vnet.ibm.com>	<51DCDF1C.1000208@linux.vnet.ibm.com> <CAKohpokbo+X5bEYweBuSqr5bkdRsb-XHT7SrMWybwAvkfDsGBQ@mail.gmail.com>
In-Reply-To: <CAKohpokbo+X5bEYweBuSqr5bkdRsb-XHT7SrMWybwAvkfDsGBQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071005-3864-0000-0000-00000901CC76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 01:39 PM, Viresh Kumar wrote:
> On 10 July 2013 09:42, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
>> I'm not sure what is supposed after notify CPUFREQ_GOV_STOP event, if it
>> is in order to stop queued work and prevent follow work happen again,
>> then it failed to, and we need some method to stop queue work again when
>> CPUFREQ_GOV_STOP notified, like some flag in policy which will be
>> checked before re-queue work in work.
>>
>> But if the event is just to sync the queued work but not prevent follow
>> work happen, then things will become tough...we need confirm.
> 
> After GOV_STOP, until the time GOV_START is called, we shouldn't be
> queuing any work.

Thanks for the confirm :) seems like the root cause is very likely
related with the problem Srivatsa discovered.

I think the fix in his mail worth a try, but I need more investigations
to confirm that's the right way...

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

