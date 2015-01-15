Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbbAOOhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:37:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:54946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbbAOOhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,404,1418112000"; 
   d="scan'208";a="512733240"
Message-ID: <54B7D08E.7060904@linux.intel.com>
Date: Thu, 15 Jan 2015 22:37:02 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix v4 0/2] Fix xen IRQ allocation failure caused by commit
 b81975eade8c
References: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com> <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com> <1681737545.20150115152237@eikelenboom.it>
In-Reply-To: <1681737545.20150115152237@eikelenboom.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/15 22:22, Sander Eikelenboom wrote:
> 
> Thursday, January 15, 2015, 2:04:34 PM, you wrote:
> 
>> With more knowledge of Xen interrupt manangement subsytem, I realized
>> previous three versions to fix https://lkml.org/lkml/2014/12/19/178 are
>> just plainly wrong. Those patches try to fix the issue by creating
>> irqdomain for IOAPICs for PV domains, which effectively let native
>> IOAPIC driver and Xen PV interrupt management subsystem to manage
>> IOAPIC irqs concurrently, sounds unpredictable.
> 
>> Sorry for those wrong fixes. The good news is that the new fix does
>> make code simpler and easier to maintain.
> 
>> I have tested the patchset on Intel platform with bare metal and Dom0
>> kernels.
> 
>> Hi Sander,
>>         Could you please help to test it again?
> 
>> Regards!
>> Gerry
> 
> Hi Gerry,
> 
> These patches fix the first symptom of the powerbutton not working.
> 
> Unfortunately it doesn't fix the second symptoms with pci-passthrough,
> the device still doesn't receive irq's on intel and the video device still haas
> issues on AMD.
> 
> What i have tested extensively and works stable for me is:
> david's patch + revert of cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC pin reference count" 
> 
> Hope that helps in finding the solution.
Hi Sander,
	Yes, this is only a fix for power button(ACPI SCI allocation).
I'm still reading xen-pciback code to figure out the possible cause
and fix for the second issue.
Thanks!
Gerry.

> 
> --
> Sander
> 
> 
>> Jiang Liu (2):
>>   xen/pci: Kill function xen_setup_acpi_sci()
>>   xen/pci: Simplify x86/pci/xen.c by killing gsi_override related code
> 
>>  arch/x86/kernel/acpi/boot.c |   26 ++++++++---------
>>  arch/x86/pci/xen.c          |   68 ++++---------------------------------------
>>  2 files changed, 19 insertions(+), 75 deletions(-)
> 
> 
