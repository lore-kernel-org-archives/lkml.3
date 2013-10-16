Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab3JPIgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:36:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964Ab3JPIgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:36:07 -0400
Message-ID: <525E4FF0.5050101@canonical.com>
Date: Wed, 16 Oct 2013 10:36:00 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86 efi: efi reverve boot service fix
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com> <20131016071122.GB18241@dhcp-16-126.nay.redhat.com> <20131016080711.GC10834@console-pimps.org>
In-Reply-To: <20131016080711.GC10834@console-pimps.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 16-10-13 10:07, Matt Fleming schreef:
> Also better include Maarten on Cc as the author of the code.
>
> On Wed, 16 Oct, at 03:11:22PM, Dave Young wrote:
>> typo, fix hpa's mail address..
>>
>> On 10/16/13 at 03:03pm, Dave Young wrote:
>>> Current code check boot service region with kernel text region by: 
>>> start+size >= __pa_symbol(_text)
>>> The end of the above region should be start + size - 1 instead.

Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

>>> I see this problem in ovmf + Fedora 19 grub boot:
>>> text start: 1000000 md start: 800000 md size: 800000
>>>
>>> Signed-off-by: Dave Young <dyoung@redhat.com>
>>> ---
>>>  arch/x86/platform/efi/efi.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
>>> +++ linux-2.6/arch/x86/platform/efi/efi.c
>>> @@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
>>>  		 * - Not within any part of the kernel
>>>  		 * - Not the bios reserved area
>>>  		*/
>>> -		if ((start+size >= __pa_symbol(_text)
>>> +		if ((start + size - 1 >= __pa_symbol(_text)
>>>  				&& start <= __pa_symbol(_end)) ||
>>>  			!e820_all_mapped(start, start+size, E820_RAM) ||
>>>  			memblock_is_region_reserved(start, size)) {

