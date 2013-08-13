Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3HMSbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:31:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35437 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab3HMSa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:30:58 -0400
Message-ID: <520A7B48.3020304@zytor.com>
Date: Tue, 13 Aug 2013 11:30:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
References: <52050985.9070107@zytor.com> <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com> <52050D03.4030805@zytor.com>
In-Reply-To: <52050D03.4030805@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 08:38 AM, H. Peter Anvin wrote:
> On 08/09/2013 08:32 AM, James Bottomley wrote:
>> On Fri, 2013-08-09 at 08:23 -0700, H. Peter Anvin wrote:
>>> I would like to change the defaults for CONFIG_EFI and CONFIG_EFI_STUB
>>> to y.  There is little reason to omit this since EFI now is a
>>> significant percentage of all systems.
>>
>> You didn't actually attach the patch, but I presume this is for 64 bit
>> compiles on x86 only?  We still have significant problems getting 64 bit
>> EFI to interact with 32 bit kernels, so I don't believe we should enable
>> CONFIG_EFI globally for all of x86.
>>
> 
> Well, it doesn't *solve* the problem with cross-mode, but it should work
> as-is for EFI32->32-bit kernel and EFI64->64-bit kernel.  For the
> cross-mode kernels they will simply not do anything.
> 
> Either way, nothing bad should come from it.  The worst thing that will
> happen is that the kernel says "I don't have any EFI that I recognize."
> 
> Cross-mode support will always require a secondary bootloader (since as
> far as I know there is no concept of "fat binaries" for EFI), but Matt
> Fleming is working on genuine cross-mode support for both the boot stub
> and (eventually) run time support.
> 

James, does this address your concerns?

	-hpa


