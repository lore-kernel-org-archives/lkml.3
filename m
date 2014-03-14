Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaCNCGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:06:52 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:40593 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbaCNCGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:06:48 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehzbb2dI98dI9371I1432I1521Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275bh8275dh1de097h186068hz2dh839h93fhe5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h1889i1155h)
X-WSS-ID: 0N2ELV7-07-1LJ-02
X-M-MSG: 
Message-ID: <53226433.3090803@amd.com>
Date: Thu, 13 Mar 2014 21:06:43 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        <kim.naru@amd.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 0/3] amd/pci: Add AMD hostbridge supports for newer AMD
 systems
References: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com> <CAErSpo4MMJh9b0aivwGSbxCMVw24He1+Vo_LH0R0E+fYM5aThg@mail.gmail.com> <5317D9B0.1080502@amd.com> <5318160D.8070305@amd.com> <CAErSpo59=52bqgyvqk1x7kcgFmRtdZhT6faYTi3wy7KDtk5=Pw@mail.gmail.com> <5318D475.9040701@amd.com> <CAErSpo5Dq3M5ik=dgF5dLsZV87XJeT3nEiYptPBXPCyLZ9xhgA@mail.gmail.com> <CAErSpo6ZbKFMgcm4upR7gTnYwZ15UJpxzctOwWMsGyONipq8aw@mail.gmail.com>
In-Reply-To: <CAErSpo6ZbKFMgcm4upR7gTnYwZ15UJpxzctOwWMsGyONipq8aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2014 4:13 PM, Bjorn Helgaas wrote:
>> I assume the system is fully functional even without these patches,
>> >right?  The only effect of these changes should be a performance
>> >improvement.

[Suravee] Yes, the system is fully functional except the numa 
information for PCI ethernet adapters is returning -1.

>> >
>> >So the choices are:
>> >
>> >   1) Change the BIOS to provide _PXM
>> >   2) Change Linux with your patches
>> >
>> >Either way, the customer has to upgrade something.  Choice 1) gets you
>> >the performance improvement on all Linux and Windows releases, even
>> >the ones that are already in the field.

[Suravee] I agree with you on both cases and I am working with the BIOS 
team to see if they can look into this and provide fixes for the future. 
  My only concern is the device _PXM information might be specific to 
each platform vendors since they are the one deciding the number of 
northbridge to be put on the systems. Also, it's quite difficult to 
influence HW/BIOS vendor to provide fixes for older platforms unless 
some important customers are complaining to them.

>> >Choice 2) fixes future Linux
>> >distros and whatever old releases you can convince the distro to
>> >backport to, and doesn't help Windows at all.  It makes work for all
>> >the distros and we (i.e., I) have to worry about maintaining this in
>> >the future.

[Suravee] Actually, this was originally reported by Redhat (please see 
https://bugzilla.redhat.com/show_bug.cgi?id=1040440), and they are 
waiting for the fixes if we decide to fix it in the upstream Linux code 
base.

>> >I'm curious to see what your BIOS folks say.  It seems strange that
>> >after all these years, they wouldn't provide something relatively
>> >simple like _PXM, so I wonder if there's more to the story.

> I looked at this a bit more.  Your patches fill in the
> mp_bus_to_node[] table, and pci_acpi_scan_root() uses
> get_mp_bus_to_node() to get that information back out.  But
> pci_acpi_scan_root() only uses get_mp_bus_to_node() if acpi_get_pxm()
> fails, or if pxm_to_node() returns -1.

[Suravee] Correct

>
> If acpi_get_pxm() failed, that's pretty good indication that the _PXM
> method is missing or broken.  If pxm_to_node() failed, it looks like
> that could mean the SRAT table is missing or broken, and we didn't
> fill in the relevant pxm_to_node_map[] entry.  So it's possible that
> we do have a _PXM method, but there's something wrong with the SRAT.

[Suravee] I am not sure which table is the _PXM method supposed to be 
apart of.

>
> Can you collect an acpidump and complete dmesg log from a system with
> the problem?  They might be too big for the mailing list; if so, you
> can attach them to a kernel.org bugzilla and just include the URL
> here.

[Suravee] Please see https://bugzilla.kernel.org/show_bug.cgi?id=72051
I have included SRAT, SLIT and DSDT table as part of the bug. Please let 
me know if you are looking for more information.

Thank you,

Suravee


