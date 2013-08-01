Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3HAE7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 00:59:25 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38440 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3HAE7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 00:59:22 -0400
Message-ID: <51F9EA96.7030407@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 10:26:54 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Wang Dongsheng-B40534 <B40534@freescale.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Li Yang-R58472 <r58472@freescale.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle backend
 driver to sysdev.
References: <20130731025840.19448.24468.stgit@deepthi> <20130731025924.19448.46538.stgit@deepthi> <ABB05CD9C9F68C46A5CEDC7F15439259FF2953@039-SN2MPN1-021.039d.mgd.msft.net> <51F88BA7.7090404@linux.vnet.ibm.com> <ABB05CD9C9F68C46A5CEDC7F15439259FF2A3A@039-SN2MPN1-021.039d.mgd.msft.net>
In-Reply-To: <ABB05CD9C9F68C46A5CEDC7F15439259FF2A3A@039-SN2MPN1-021.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080104-4790-0000-0000-0000099366BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongsheng,

On 07/31/2013 11:16 AM, Wang Dongsheng-B40534 wrote:
> Hi Preeti,
> 
>> -----Original Message-----
>> From: Preeti U Murthy [mailto:preeti@linux.vnet.ibm.com]
>> Sent: Wednesday, July 31, 2013 12:00 PM
>> To: Wang Dongsheng-B40534
>> Cc: Deepthi Dharwar; benh@kernel.crashing.org; daniel.lezcano@linaro.org;
>> linux-kernel@vger.kernel.org; michael@ellerman.id.au;
>> srivatsa.bhat@linux.vnet.ibm.com; svaidy@linux.vnet.ibm.com; linuxppc-
>> dev@lists.ozlabs.org; rjw@sisk.pl; linux-pm@vger.kernel.org
>> Subject: Re: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle
>> backend driver to sysdev.
>>
>> Hi Dongsheng,
>>
>> On 07/31/2013 08:52 AM, Wang Dongsheng-B40534 wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Deepthi Dharwar [mailto:deepthi@linux.vnet.ibm.com]
>>>> Sent: Wednesday, July 31, 2013 10:59 AM
>>>> To: benh@kernel.crashing.org; daniel.lezcano@linaro.org; linux-
>>>> kernel@vger.kernel.org; michael@ellerman.id.au;
>>>> srivatsa.bhat@linux.vnet.ibm.com; preeti@linux.vnet.ibm.com;
>>>> svaidy@linux.vnet.ibm.com; linuxppc-dev@lists.ozlabs.org
>>>> Cc: rjw@sisk.pl; Wang Dongsheng-B40534; linux-pm@vger.kernel.org
>>>> Subject: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle
>>>> backend driver to sysdev.
>>>>
>>>> Move pseries_idle backend driver code to arch/powerpc/sysdev so that
>>>> the code can be used for a common driver for powernv and pseries.
>>>> This removes a lot of code duplicacy.
>>>>
>>> Why not drivers/cpuidle/?
>>>
>>> I think it should be move to drivers/cpuidle.
>>
>> Please take a look at what the cpuidle under drivers has to provide.
>> cpuidle has two parts to it. The front end and the back end. The front
>> end constitutes the cpuidle governors, registering of arch specific
>> cpuidle drivers, disabling and enabling of cpuidle feature. It is this
>> front end code which is present under drivers/cpuidle.
>>
>> The arch specific cpuidle drivers which decide what needs to be done to
>> enter a specific idle state chosen by the cpuidle governor is what
>> constitutes the back end of cpuidle. This will not be in drivers/cpuidle
>> but in an arch/ specific code.
>>
>> The cpuidle under drivers/cpuidle drives the idle power management, but
>> the low level handling of the entry into idle states should be taken care
>> of by the architecture.
>>
>> Your recent patch :
>> cpuidle: add freescale e500 family porcessors idle support IMO should
>> hook onto the backend cpuidle driver that this patchset provides.
>>
> Sorry, I don't think so, cpuidle framework has been already very common.
> Here we just need to do state definition and handling. I wonder whether
> we need this layer.
> 
> If your handle is platform dependent, it should be in arch/platform.
> 
> If it is only for some platforms and the operation of these platforms can be
> multiplexed, Why cannot as a driver to put into driver/cpuidle?
> 
> If it a general driver, I think we can put some common operating to driver/cpuidle
> and make the platform specific code to arch/powerpc/platform.
> 
> This patch include front end and back end, not just back end.
> 
> This patch include too many state of different platforms and handle function. This state
> and handle that should belong to itself platforms. Not a general way. If Deepthi will do
> a general powerpc cpuidle, I think, it's cannot just using the macro to distinguish
> platform. the front end code maybe move to driver/cpuidle(drvier register) should be better,
> make the Low Power State and what should be handle to arch/powerpc/platform/**, because different
> platforms have different state of low power consumption, and the processing method.
> The front end can provide some general methods to register into general powerpc cpuidle driver.


As Daniel pointed out, with a call to cpuidle_register(), we can get the
cpuidle_driver and cpuidle_device registered through the generic cpuidle
framework. Hence we can get rid of the powerpc_idle_devices_init() routine.

We can have the hotplug notifier in the generic cpuidle framework as
well. The rest of the patchset however should be arch specific IMO.

Regards
Preeti U Murthy

> 
> -dongsheng
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

