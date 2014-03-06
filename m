Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaCFGbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:31:06 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:23318
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbaCFGbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:31:04 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N204RG-08-5WO-02
X-M-MSG: 
Message-ID: <5318160D.8070305@amd.com>
Date: Thu, 6 Mar 2014 00:30:37 -0600
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 0/3] amd/pci: Add AMD hostbridge supports for newer AMD
 systems
References: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com> <CAErSpo4MMJh9b0aivwGSbxCMVw24He1+Vo_LH0R0E+fYM5aThg@mail.gmail.com> <5317D9B0.1080502@amd.com>
In-Reply-To: <5317D9B0.1080502@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/2014 8:13 PM, Suravee Suthikulanit wrote:
> On 3/5/2014 3:24 PM, Bjorn Helgaas wrote:
>> [+cc linux-acpi]
>>
>> On Wed, Mar 5, 2014 at 2:06 PM,  <suravee.suthikulpanit@amd.com> wrote:
>>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>>
>>> The current code only supports upto AMD hostbridge for family11h.
>>> This causes PCI numa_node information to be reported incorrectly
>>> for newer family with multi sockets.
>>
>> Where is the incorrect reporting?  In ACPI tables?  Is this patch a
>> way to cover up firmware defects in the ACPI description?  Or is this
>> for machines without ACPI (it seems unlikely that machines with new
>> AMD processors would not have ACPI)?
>
> This is incorrectly reported in the sysfs for each PCI device (e.g.
> /devices/pci0000:50/0000:50:00.2/numa_node). Without the patch, they
> return -1.
>
> In file arch/x86/pci/acpi.c, in function pci_acpi_scan_root(), it is
> queries the node information as following:
>
> #ifdef CONFIG_ACPI_NUMA
>      pxm = acpi_get_pxm(device->handle);
>      if (pxm >= 0)
>          node = pxm_to_node(pxm);
>      if (node != -1)
>          set_mp_bus_to_node(busnum, node);
>      else
> #endif
>          node = get_mp_bus_to_node(busnum);
>
> In this case, I see that the acpi_get_pxm() returns -1.  Therefore, it
> falls back to using the node information in mp_bus_to_node[].  So,
> without this patch, it would also returning -1.
>
> Also, the spec mentioned that the _PXM is optional, so I am not sure if
> this is a firmware bug.
>
> Suravee

I am not quite familiar with the ACPI for this part.  However, after 
taking a look at the code (in driver/acpi/pci_root.c: 
acpi_pci_root_add()), I believe it's trying to locate _PXM method in the 
DSDT table, in which I don't see any _PXM methods.

I'm still trying to debug this issue, any suggestions would be appreciated.

Thank you,

Suravee


