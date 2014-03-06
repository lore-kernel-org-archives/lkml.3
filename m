Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaCFFWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:22:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:63942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaCFFWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:22:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,598,1389772800"; 
   d="scan'208";a="486958153"
Message-ID: <531805D4.6040806@linux.intel.com>
Date: Thu, 06 Mar 2014 13:21:24 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH] x86: new Intel Atom SoC power management controller driver
References: <5317EC0C.4010807@linux.intel.com> <5317F044.8080407@linux.intel.com>
In-Reply-To: <5317F044.8080407@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/6 11:49, H. Peter Anvin wrote:
> On 03/05/2014 07:31 PM, Li, Aubrey wrote:
>> The Power Management Controller (PMC) controls many of the power
>> management features present in the SoC. This driver provides
>> interface to configure the Power Management Controller (PMC).
>>
>> This driver exposes PMC device state and sleep state residency
>> via debugfs for observation:
>> 	/sys/kernel/debugfs/pmc_atom/dev_state
>> 	/sys/kernel/debugfs/pmc_atom/sleep_state
>>
>> This driver also provides a native power off function via PMC PCI
>> IO port.
>>
> 
> What is the reason for putting this in debugfs?

S0ix support on Atom SoC needs all of the devices under south complex to
be quiesced, as well as the devices under north complex. This interface
shows all of the devices states under platform control unit. If the
system is not able to enter S0ix, we have a way to diagnose. Or if the
system entered S0ix, we have counters to show S0ix entered and its
residency.

Thanks,
-Aubrey


> 
> 	-hpa
> 
> 
> 
> 

