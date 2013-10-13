Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3JMUsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 16:48:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46836 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab3JMUsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 16:48:31 -0400
Message-ID: <525B06CB.6090602@zytor.com>
Date: Sun, 13 Oct 2013 13:47:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@console-pimps.org>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org> <20131010172844.GA26430@gmail.com> <20131011140039.GF12321@console-pimps.org> <20131012174934.GA18849@gmail.com>
In-Reply-To: <20131012174934.GA18849@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 10:49 AM, Ingo Molnar wrote:
> 
>>>> +static void early_efi_write_char(void *dst, char c, int h)
>>>> +{
>>>> +	const u8 *src;
>>>> +	u32 fgcolor = 0xaaaaaa;
>>>
>>> That's RGB grey, right? Why not 0xffffff for a very visible white?
>>  
>> The VGA earlyprintk code uses the equivalent grey, AFAIK, which is why I 
>> picked this value.
> 
> The VGA code should be changed to white too I suspect ;-)
> 

For compatibility with the classical text console we use light grey as
the default color and a double-stroked font (which was necessary on the
CGA display since it didn't have enough bandwidth to handle
single-stroked fonts well).  The problem with changing that to white is
that you end up with a mismatch between the earlyprintk console and the
"real" console, *or* we change the behavior of everyone's consoles...

	-hpa


