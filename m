Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3IMSRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:17:07 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42639 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3IMSRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:17:05 -0400
Message-ID: <5233569D.6020505@linaro.org>
Date: Fri, 13 Sep 2013 14:17:01 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
References: <20130913145033.GA8502@ohporter.com>  <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>  <52334506.9030802@linaro.org> <1379093858.2197.24.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1379093858.2197.24.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 01:37 PM, Davidlohr Bueso wrote:
> On Fri, 2013-09-13 at 13:01 -0400, Matt Porter wrote:
>> On 09/13/2013 12:28 PM, Davidlohr Bueso wrote:
> [...]
>>
>>>> I get that this is not compliant with UEFI. I bring this up because
>>>> before this commit the is_pmbr_valid() check was less pedantic. In 3.11
>>>> a PMBR formatted this way did not fail the check. For my particular
>>>> case, I simply dded out LBA 1 and whacked the SizeInLBA field to comply
>>>> with the spec and this patch and I'm back in business. We're updating
>>>> the tools that we inherited to prepopulate our boards with a GPT to be
>>>> compliant. However, I wondered if this would be a problem for all the
>>>> people with Windows-generated GPTs as noted in [1].
>>>
>>> I guess this comes down to choosing whether or not we want Linux to be
>>> more UEFI compliant or not. Should we care if Microsoft decides to go do
>>> things out of the official spec? I don't know the policy here. The fact
>>> is that *they* should update their partitioning tools and create valid
>>> pMBRs. Any way, I'm ok with reverting this commit if deemed necessary.
>>
>> I can't say first-hand that Windows 7/8 does what is claimed in this
>> description as I simply don't have access to any Windows machines here.
>> If it's true, I would have to agree with Linus that meeting reality if
>> more important than meeting the spec.
>
> Yep, me too.
>
>>
>> Hopefully somebody can confirm that Windows does indeed produce these
>> special PMBRs that need to be handled as an exception to the spec.
>
> I've got a partition with Windows 7 and I can take a look during the
> weekend. Do you know exactly what tool was used for creating the
> partition?

Just to be clear, we used an internal Broadcom tool that did this 
Windows-like behavior on our bcm281xx reference board.

In the Windows situation, I really have no idea what tool Windows 7/8 
use to partition disks. Based on that article, I'm assuming it's 
whatever today's version of "FDISK", as shipped on Windows 7/8, is.

Ok, Google claims it is "The Windows 7 Disk Management" tool. I might 
try to stop at somebody's house this weekend, boot Linux from USB and 
extract the PMBR from their drive just as another data point.

-Matt

