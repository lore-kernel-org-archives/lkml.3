Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab3B1VMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:12:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41519 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760519Ab3B1VMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:12:22 -0500
Message-ID: <512FC82B.40909@zytor.com>
Date: Thu, 28 Feb 2013 13:12:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: hpa@sgi.com, Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
References: <20130228205206.GC3438@sgi.com> <512FC697.3090608@zytor.com> <20130228210910.GD3438@sgi.com>
In-Reply-To: <20130228210910.GD3438@sgi.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 01:09 PM, Robin Holt wrote:
>>
>> Sounds like ELILO needs to be fixed to pass the boot_params correctly.
>>
>> To support existing ELILO, it would be good to know exactly *which*
>> fields ELILO pass in as garbage (because it does, that is why ->sentinel
>> is nonzero) and use its bootloader ID to apply the proper brainwhack for
>> the legacy versions.
> 
> Any idea how I can dump that information?
> 

Look at the source code and look at what fields it actually initializes.
 Give us that list, and then we can work around elilo braindamage in the
kernel.

Then make it follow the boot spec:

> In 32-bit boot protocol, the first step in loading a Linux kernel
> should be to setup the boot parameters (struct boot_params,
> traditionally known as "zero page"). The memory for struct boot_params
> should be allocated and initialized to all zero. Then the setup header
> from offset 0x01f1 of kernel image on should be loaded into struct
> boot_params and examined. The end of setup header can be calculated as
> follow:
> 
>         0x0202 + byte value at offset 0x0201

... so we don't have to.

	-hpa

