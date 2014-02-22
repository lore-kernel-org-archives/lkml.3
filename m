Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaBVPda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:33:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:62977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaBVPd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:33:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,523,1389772800"; 
   d="scan'208";a="486178937"
Message-ID: <5308C343.5040102@linux.intel.com>
Date: Sat, 22 Feb 2014 23:33:23 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 10/33] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>	<1388707565-16535-11-git-send-email-yinghai@kernel.org>	<53070393.5020005@linux.intel.com>	<CAE9FiQV8B271XCJQV=80S6pZDOVxG9LG0gaj9G98dCRetjkMUg@mail.gmail.com>	<53081614.4020503@linux.intel.com> <CAE9FiQXnMgG=mOmcSK9ZwKR6tFAkJX2dVnGTj9Mmg3daDhPmEA@mail.gmail.com>
In-Reply-To: <CAE9FiQXnMgG=mOmcSK9ZwKR6tFAkJX2dVnGTj9Mmg3daDhPmEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
	I have a plan to test this patch set once I have reviewed
all patches in coming weeks. Do you have a plan to update to latest
kernel or is it ok to test this version?
Thanks!
Gerry

On 2014/2/22 15:44, Yinghai Lu wrote:
> On Fri, Feb 21, 2014 at 7:14 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> 
>>         Seems there is no such protection on IA64 side. I feel create_irq_nr()
>> returns 0 for error is a little risky, 0 may be
>> a valid IRQ number on other platforms(no sure about this).
>> Thanks!
> 
> in [PATCH] ia64, irq: Add dummy create_irq_nr()
> 
> +unsigned int create_irq_nr(unsigned int from, int node)
> +{
> +       int irq = create_irq();
> +
> +       if (irq < 0)
> +               irq = 0;
> +
> +       return irq;
> +}
> +
> 
> so that from is ignored.
> 
> create_irq_nr() is only with x86 and ia64.
> 
> Thanks
> 
> Yinghai
> 
