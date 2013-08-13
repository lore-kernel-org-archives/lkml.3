Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3HMTHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:07:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab3HMTHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:07:02 -0400
Message-ID: <520A83B2.4010003@zytor.com>
Date: Tue, 13 Aug 2013 12:06:26 -0700
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
References: <52050985.9070107@zytor.com>   <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>   <52050D03.4030805@zytor.com> <520A7B48.3020304@zytor.com>  <1376419410.3467.67.camel@dabdike.int.hansenpartnership.com>  <520A8054.1030108@zytor.com> <1376420525.3467.70.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1376420525.3467.70.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 12:02 PM, James Bottomley wrote:
> On Tue, 2013-08-13 at 11:52 -0700, H. Peter Anvin wrote:
>> On 08/13/2013 11:43 AM, James Bottomley wrote:
>>> Can we actually boot a 32 bit kernel on an EFI64 system?  The last time
>>> I tried on my Secure Boot SDV it wouldn't work; the problem is getting
>>> someting in the transfer of control path to boot the processor back to
>>> 32 bit mode.
>>
>> We can boot with a bootloader in "skip stub" mode; no runtime services
>> yet.
> 
> So the bootloader has to do the 64->32 transition?
> 
Currently, yes.

>>   We are working on making it possible to boot via a EFI stub in
>> assisted mode (still needing a bootloader, but with the boot stub in the
>> kernel.)
>>
>> Runtime services will be the last piece, obviously, but even that looks
>> reasonably doable.
> 
> So why not start with the working case (default to EFI on 64 bit) and
> add in the mostly non-working case (default to EFI on 32 bit) when it
> actually mostly works?

We can do that, but I really hate making gratuitous differences between
32 and 64 bits... we have too many of those already.

	-hpa


