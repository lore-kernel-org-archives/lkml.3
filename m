Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3FJROc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:14:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57508 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3FJROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:14:30 -0400
Message-ID: <51B60973.1080506@gmail.com>
Date: Mon, 10 Jun 2013 10:14:27 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sanjay Lal <sanjayl@kymasys.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <8D7771A4-B51E-4FA8-9342-621FE41792DE@kymasys.com>
In-Reply-To: <8D7771A4-B51E-4FA8-9342-621FE41792DE@kymasys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 09:43 AM, Sanjay Lal wrote:
>
> On Jun 7, 2013, at 4:03 PM, David Daney wrote:
>
>> From: David Daney <david.daney@cavium.com>
>>
>> These patches take a somewhat different approach to MIPS
>> virtualization via the MIPS-VZ extensions than the patches previously
>> sent by Sanjay Lal.
>>
>> Several facts about the code:
>>
>>
>> o Currently probably only usable on the OCTEON III CPU model, as some
>>   MIPS-VZ implementation-defined behaviors were assumed to have the
>>   OCTEON III behavior.
>>
>
>
> I've only briefly gone over the patches, but I was wondering if the Cavium implementation has support for GuestIDs, which are optional in the VZ-ASE?
>

No, OCTEON III does not support this optional behavior.  For the most 
part this only impacts TLB management.  I think in the context of KVM, 
you cannot leave foreign Guest's TLB entries present in the Guest TLB 
anyhow, so the feature is of little use.

Since MIPS TLBs are managed by software, it is valid for a guest to 
populate the TLB in any way it desires.  To have the hypervisor (KVM) 
come and randomly invalidate the TLB, via the GuestID mechanism, would 
both be detectable by the guest, and potentially make the guest operate 
incorrectly.

David Daney

> Regards
> Sanjay
>
>
>
>

