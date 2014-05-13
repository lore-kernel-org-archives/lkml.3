Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaEMHMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:12:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35384 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaEMHMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:12:45 -0400
Message-ID: <5371C5E5.6070701@linux.vnet.ibm.com>
Date: Tue, 13 May 2014 00:12:37 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Paul Bolle <pebolle@tiscali.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/pseries: relocate "config DTL" so KConfig nests
 properly
References: <1399950599-24826-1-git-send-email-cody@linux.vnet.ibm.com> <1399962216.7554.63.camel@ale.ozlabs.ibm.com>
In-Reply-To: <1399962216.7554.63.camel@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051307-0320-0000-0000-0000034000CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 11:23 PM, Michael Neuling wrote:
>> powerpc/pseries: relocate "config DTL" so KConfig nests properly
>
> I don't know what that means.  Can you describe it in more detail?
>

So the "config DTL" refers to the configuration entry.

The "nests properly" refers to the indent that 'make menuconfig' shows 
when a config-option that depends on the config-option proceeding it.

In this case, moving config DTL up so it is below config PPC_SPLPAR 
means that menuconfig will show config DTL nicely indented right below 
config PPC_SPLPAR when PPC_SPLPAR is enabled.

To contrast that, right now if I enable PPC_SPLPAR in menuconfig, all I 
can immediately tell is that "something showed up further down the list 
where I wasn't looking", and I end up having to toggle the option a few 
times to figure out what showed up, or look at the KConfig to find out 
that config DTL depends on config PPC_SPLPAR.

Essentially, this enables menuconfig to provide a visual hint about the 
dependencies between options.

> Mikey
>
>
> On Mon, 2014-05-12 at 20:09 -0700, Cody P Schafer wrote:
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/platforms/pseries/Kconfig | 20 ++++++++++----------
>>   1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
>> index 2cb8b77..e00dd4d 100644
>> --- a/arch/powerpc/platforms/pseries/Kconfig
>> +++ b/arch/powerpc/platforms/pseries/Kconfig
>> @@ -33,6 +33,16 @@ config PPC_SPLPAR
>>   	  processors, that is, which share physical processors between
>>   	  two or more partitions.
>>
>> +config DTL
>> +	bool "Dispatch Trace Log"
>> +	depends on PPC_SPLPAR && DEBUG_FS
>> +	help
>> +	  SPLPAR machines can log hypervisor preempt & dispatch events to a
>> +	  kernel buffer. Saying Y here will enable logging these events,
>> +	  which are accessible through a debugfs file.
>> +
>> +	  Say N if you are unsure.
>> +
>>   config PSERIES_MSI
>>          bool
>>          depends on PCI_MSI && PPC_PSERIES && EEH
>> @@ -122,13 +132,3 @@ config HV_PERF_CTRS
>>   	  systems. 24x7 is available on Power 8 systems.
>>
>>             If unsure, select Y.
>> -
>> -config DTL
>> -	bool "Dispatch Trace Log"
>> -	depends on PPC_SPLPAR && DEBUG_FS
>> -	help
>> -	  SPLPAR machines can log hypervisor preempt & dispatch events to a
>> -	  kernel buffer. Saying Y here will enable logging these events,
>> -	  which are accessible through a debugfs file.
>> -
>> -	  Say N if you are unsure.
>

