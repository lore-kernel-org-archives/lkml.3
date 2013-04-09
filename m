Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936251Ab3DIPMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:12:25 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:38993
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935378Ab3DIPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:12:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(z551bizbb2dI98dI9371I1458K1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MKZU89-02-2NQ-02
X-M-MSG: 
Message-ID: <51642FCD.8080606@amd.com>
Date: Tue, 9 Apr 2013 10:12:13 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
References: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com> <20130409094132.GD6858@8bytes.org>
In-Reply-To: <20130409094132.GD6858@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2013 4:41 AM, Joerg Roedel wrote:
> On Tue, Apr 02, 2013 at 07:06:50PM -0500, Suthikulpanit, Suravee wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
>> This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.
>>
>> This is an example:
>> AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 domain=0x0000 address=0x0000000000000000 flags=0x0fff]
>> AMD-Vi: Flags details: Guest NX=1 User Intr Present Write No-Perm Rsrv-Bit Translation
>> AMD-Vi: Type of error: (0x7)
>> AMD-Vi: (Note: Please refer to AMD IOMMU specification for details.)
>> AMD-Vi: DTE[0]: 6000003fa75e2403
>> AMD-Vi: DTE[1]: 0000000000000014
>> AMD-Vi: DTE[2]: 2000003fa5e09011
>> AMD-Vi: DTE[3]: 0000000000000000
> This example should look like this instead:
>
> AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 domain=0x0000 address=0x0 flags: G NX US I P Wr Rsvd Tr]
>
> by default. When the user passes amd_iommu=verbose on the cmd-line then
> you can print additional information like "type of error" or the dump
> the DTE.
>
>
> 	Joerg
Joerg,

- I can fit DTE dump all in one line (to reduce the number of lines). 
But it is necessary for debugging certain events.
- The "type of error" is also part of the flag translation for certain 
event.  It will only print if it is necessary.
- I can remove the "Note: ... " per Boris's request.
- I can shorten the flag details even more.

Here are some new examples:
[  156.177883] AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 
domain=0x0000 address=0x0000000000000000]
[  156.177895] AMD-Vi: Flags: Gst NX Usr Int P W N-Perm Rsrv Trnslt
[  156.177898] AMD-Vi: Type of error: (0x7)
[  156.177899] AMD-Vi: DTE[0 .. 3]: 6000007fa764f403 0000000000000014 
2000003fabb41811 0000000000000000

[  197.353900] AMD-Vi: Event logged [PAGE_TAB_HARDWARE_ERROR 
device=51:00.0 domain=0x0000 address=0x0000000000000000]
[  197.353917] AMD-Vi: Flags: Gst NX Usr Int P W N-Perm Rsrv Trnslt

These messages are not "high volumn".  What I am trying to achieve is 
for users to be able to just send the errors to developers once they are 
encountered without having to tell them to go back and reboot with the 
"amd_iommu=verbose". In facts, they often difficult to reproduce from my 
experience.  This should reduce the amount of communications and efforts 
required to debug the issue.

If you are ok with this, I will send out V4 in the next email.

Thank you,

Suravee

