Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaK0QXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:23:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:53108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaK0QXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:23:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="490977254"
Message-ID: <54774FE2.6010807@linux.intel.com>
Date: Fri, 28 Nov 2014 00:22:58 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Daniel J Blueman <daniel@numascale.com>
Subject: Re: [Patch Part3 v4 37/38] x86, irq: Introduce mechanism to support
 different vector allocation policies
References: <1416901802-24211-1-git-send-email-jiang.liu@linux.intel.com> <1416901802-24211-38-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411271142340.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411271142340.3961@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/27 18:44, Thomas Gleixner wrote:
> On Tue, 25 Nov 2014, Jiang Liu wrote:
>> Introduce mechanism to support different vector allocation policies,
>> so platform or user may choose the best suitable CPU vector allocation
> 
> I've postponed this and the next patch for 3.20.
Hi Thomas,
	That's fine, thanks for merging all other patches for 3.19:)

> 
>> policy. Currently two policies are supported:
>> 1) allocate CPU vector from cpumask_of_node(dev_to_node(dev))
>> 2) allocate from apic->target_cpus(), this is the default policy
>>
>> Platform driver may call set_vector_alloc_policy() to choose the
>> preferred policies.
>>
>> This mechanism may be used to support NumaConnect systems to allocate
>> CPU vectors from device local node.
> 
> So these policies are system wide and need to be selected at boot time?
Yes, the polices are system wide.
It may be change at runtime, but seems no strong requirement yet so
haven't implemented the interface to change it at runtime.

Basically this idea is inspired by a patch set to allocate  CPU vector
from device local node for NumaConnect systems. I found it may also help
2-socket or 4-socket systems, so reimplemented in this way.
Thanks!
Gerry

> 
> Thanks,
> 
> 	tglx
> 
