Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3JPHbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:31:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab3JPHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:31:04 -0400
Message-ID: <525E4076.2070107@zytor.com>
Date: Wed, 16 Oct 2013 00:29:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, matt@console-pimps.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86 efi: efi reverve boot service fix
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com> <20131016071122.GB18241@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131016071122.GB18241@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 12:11 AM, Dave Young wrote:
>>
>> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
>> +++ linux-2.6/arch/x86/platform/efi/efi.c
>> @@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
>>  		 * - Not within any part of the kernel
>>  		 * - Not the bios reserved area
>>  		*/
>> -		if ((start+size >= __pa_symbol(_text)
>> +		if ((start + size - 1 >= __pa_symbol(_text)
>>  				&& start <= __pa_symbol(_end)) ||
>>  			!e820_all_mapped(start, start+size, E820_RAM) ||
>>  			memblock_is_region_reserved(start, size)) {

It would be better to change >= to >.

	-hpa

