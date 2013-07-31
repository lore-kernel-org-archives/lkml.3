Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab3GaECY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:02:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48220 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3GaECW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:02:22 -0400
Message-ID: <51F88BA7.7090404@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 09:29:35 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Wang Dongsheng-B40534 <B40534@freescale.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle backend
 driver to sysdev.
References: <20130731025840.19448.24468.stgit@deepthi> <20130731025924.19448.46538.stgit@deepthi> <ABB05CD9C9F68C46A5CEDC7F15439259FF2953@039-SN2MPN1-021.039d.mgd.msft.net>
In-Reply-To: <ABB05CD9C9F68C46A5CEDC7F15439259FF2953@039-SN2MPN1-021.039d.mgd.msft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073103-5490-0000-0000-000003E99021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dongsheng,

On 07/31/2013 08:52 AM, Wang Dongsheng-B40534 wrote:
> 
> 
>> -----Original Message-----
>> From: Deepthi Dharwar [mailto:deepthi@linux.vnet.ibm.com]
>> Sent: Wednesday, July 31, 2013 10:59 AM
>> To: benh@kernel.crashing.org; daniel.lezcano@linaro.org; linux-
>> kernel@vger.kernel.org; michael@ellerman.id.au;
>> srivatsa.bhat@linux.vnet.ibm.com; preeti@linux.vnet.ibm.com;
>> svaidy@linux.vnet.ibm.com; linuxppc-dev@lists.ozlabs.org
>> Cc: rjw@sisk.pl; Wang Dongsheng-B40534; linux-pm@vger.kernel.org
>> Subject: [PATCH V2 4/6] cpuidle/pseries: Move the pseries_idle backend
>> driver to sysdev.
>>
>> Move pseries_idle backend driver code to arch/powerpc/sysdev
>> so that the code can be used for a common driver for powernv
>> and pseries. This removes a lot of code duplicacy.
>>
> Why not drivers/cpuidle/?
> 
> I think it should be move to drivers/cpuidle.

Please take a look at what the cpuidle under drivers has to provide.
cpuidle has two parts to it. The front end and the back end. The front
end constitutes the cpuidle governors, registering of arch specific
cpuidle drivers, disabling and enabling of cpuidle feature. It is this
front end code which is present under drivers/cpuidle.

The arch specific cpuidle drivers which decide what needs to be done to
enter a specific idle state chosen by the cpuidle governor is what
constitutes the back end of cpuidle. This will not be in drivers/cpuidle
but in an arch/ specific code.

The cpuidle under drivers/cpuidle drives the idle power management, but
the low level handling of the entry into idle states should be taken
care of by the architecture.

Your recent patch :
cpuidle: add freescale e500 family porcessors idle support IMO should
hook onto the backend cpuidle driver that this patchset provides.

Regards
Preeti U Murthy

