Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3GLLBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab3GLLBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:01:39 -0400
Message-ID: <51DFA9CA.7010807@redhat.com>
Date: Fri, 12 Jul 2013 03:01:30 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, joro@8bytes.org,
        andihartmann@01019freenet.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] pci: ACS fixes & quirks
References: <20130627222159.16564.38166.stgit@bling.home> <1373300262.2602.22.camel@ul30vt.home>
In-Reply-To: <1373300262.2602.22.camel@ul30vt.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 12:17 PM, Alex Williamson wrote:
> Ping.  Comments?
>
As I read the PCIe & SRIOV specs wrt ACS, this patch set appears
to fix the nuances we have learned about whether a device (MFD or bridge)
implements (the equiv. of) ACS, or not, as required (for secure, device assignment).
Like the layering of which flag bits to check based on ACS control/enablement,
so it de-complicated the per-PCIe-type checking in pci_acs_enabled().

You can add my ack to the patch set...

Acked-by: Donald Dutile <ddutile@redhat.com>

ps -- I'll patch a kernel & test it out on a few knarly configs I have back in 
the lab
         when I back from vacation and report any issues I find, if any.

> On Thu, 2013-06-27 at 16:39 -0600, Alex Williamson wrote:
>> v2:
>>
>> Revised patch 1/ to match comments from Bjorn.  PCIe event collectors
>> and PCIe-to-PCI bridges now indicate that they do not support ACS.
>> I've reached out to try to get clarification on this, but I think it's
>> reasonable to proceed with a conservative approach until then.  I also
>> added PCI-to-PCIe bridges for the sake of being complete.  Also added
>> more comments about the purpose and behavior of pci_acs_enabled().  If
>> I've overlooked anything else that needs to be addressed, please let
>> me know.
>>
>> Patch 2/ had no comments, it's unchanged.
>>
>> Patch 3/ is added.  This was sent as an RFC nearly a year ago and
>> Joerg confirmed for us that these devices do not support p2p on AMD
>> systems with AMD IOMMU.  We can't simply use iommu_present() to test
>> for an IOMMU because it's setup just after we need this function.
>> Instead we test for the ACPI IVRS table that describes the IOMMU.  It
>> would probably suffice to skip an actual AMD IOMMU check, but I don't
>> want it to later come bite us if these ASICs get re-used, maybe with
>> a different IOMMU, and don't make the same guarantees.
>>
>> Joerg, I was also curious back when we investigated this patch if the
>> same rules hold true for these other southbridge devices:
>>
>> 1002:43a0 SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
>> 1002:43a1 SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
>> 1002:43a2 SB900 PCI to PCI bridge (PCIE port 2)
>> 1002:43a3 SB900 PCI to PCI bridge (PCIE port 3)
>>
>> If you remember or have contacts to poke, I'd be happy to follow-up
>> with another patch to add them.  Thanks,
>>
>> Alex
>>
>> ---
>>
>> Alex Williamson (3):
>>        pci: Fix flaw in pci_acs_enabled()
>>        pci: Differentiate ACS controllable from enabled
>>        pci: ACS quirk for AMD southbridge
>>
>>
>>   drivers/pci/pci.c    |   93 +++++++++++++++++++++++++++++++++++++++++---------
>>   drivers/pci/quirks.c |   50 +++++++++++++++++++++++++++
>>   2 files changed, 127 insertions(+), 16 deletions(-)
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

