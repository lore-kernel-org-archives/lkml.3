Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3DWPbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:31:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:31285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab3DWPbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:31:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,533,1363158000"; 
   d="scan'208";a="323622996"
Message-ID: <5176A932.5050506@linux.intel.com>
Date: Tue, 23 Apr 2013 08:30:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org> <1364302359.5053.21.camel@laptop> <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com> <1364308932.5053.46.camel@laptop> <CAKfTPtArtgkH5MU_xFAKjLDS-i32g2qQMdvyW=LLkG84tH8Hhg@mail.gmail.com> <5174CE96.3060805@linux.vnet.ibm.com> <CAKfTPtCCCifC=c+xjjnAH_HSqkR80PiQoddQKXPHuZwZawbvcA@mail.gmail.com> <5175F09E.1000304@intel.com>
In-Reply-To: <5175F09E.1000304@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2013 7:23 PM, Alex Shi wrote:
> Thanks you, Preeti and Vincent to talk the power aware scheduler for
> details! believe this open discussion is helpful to conduct a a more
> comprehensive solution. :)
>
>> Hi Preeti,
>>
>> I have had a look at Alex patches but i have some concerns with his patches
>> -There no notion of power domain which is quite important when we speak
>> about power saving IMHO. Packing tasks has got an interest if the idle
>> CPUs can reach a useful low power state independently from busy CPUs.
>> Architectures have different low power state capabilities which must be
>> taken into account. In addition, you can have system which have CPUs
>> with better power efficiency and this kind of system are not taken into
>> account.
>
> I agree with you on this point. and like what's you done to add new flag
> in sched domain.

For x86 we should not be setting such flag then; we don't have a way for some cpu packages to
go to an extra deep power state if they're completely idle.
(this afaik is true for both Intel and AMD)



