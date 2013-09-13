Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3IMSKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:10:02 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:40515 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3IMSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:09:59 -0400
Message-ID: <523354F3.70001@linaro.org>
Date: Fri, 13 Sep 2013 14:09:55 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: GPT detection regression in efi.c from commit 27a7c64
References: <20130913145033.GA8502@ohporter.com>  <1379089736.2197.14.camel@buesod1.americas.hpqcorp.net>  <52334506.9030802@linaro.org> <1379095648.2197.27.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1379095648.2197.27.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 02:07 PM, Davidlohr Bueso wrote:
> On Fri, 2013-09-13 at 13:01 -0400, Matt Porter wrote:
>> On 09/13/2013 12:28 PM, Davidlohr Bueso wrote:
>>> Cc'ing Linus.
>>>
>>> On Fri, 2013-09-13 at 10:50 -0400, Matt Porter wrote:
>>>> The commit, "27a7c64 partitions/efi: account for pmbr size in lba", that
>>>> was just merged in 3.12-rc caused a regression on my system with a GPT
>>>> formatted eMMC device. In 3.11, the GPT partition table was detected
>>>> fine but now a partition table is not detected.
>>>>
>>>> Not being a GPT expert, I did some research and found that the tool used
>>>> to create the PMBR on my system shares characteristics with what is
>>>> mentioned in an explanation of Microsoft created PMBRs [1]. In short,
>>>> the size_in_lba field incorrectly has 0xffffffff even though I have a
>>>> <2TiB drive (16GiB eMMC).
>>>
>>> *sigh*. So Microsoft decided to do its own version of the GPT specs.
>>
>> Don't sound so surprised. :)
>>
>>> Up until now, Linux was incorrectly enforcing pMBR checks: not
>>> recognizing valid labels and vice versa, as with the case you are
>>> mentioning now. The changes that went in the 3.12 merge window attempt
>>> to address those concerns, enforcing the correct checks - which is also
>>> how Linux partitioning tools do it (fdisk, parted).
>>
>> Understood, and we are fixing our own manufacturing tool that was used
>> to prepopulate the eMMC. I definitely prefer to have this correct for my
>> case.
>
> Come to think of it, we do have a long existing workaround: the
> force_gpt option. Setting it will bypass any MBR checking
> (is_pmbr_valid(), specifically).

Yes, that's what I used at first after seeing what the problem was. But 
then I opted to fix my PMBR.

I felt like it was a regression since it required a new option passed on 
the cmdline.

-Matt

