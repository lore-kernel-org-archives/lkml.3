Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3A2CnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:43:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab3A2CnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:43:16 -0500
Message-ID: <51073429.10503@redhat.com>
Date: Tue, 29 Jan 2013 10:30:01 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [RFC] efivars write(2) races
References: <20130125002552.GC4503@ZenIV.linux.org.uk>   <51020120.5000500@redhat.com>  <1359119883.2496.156.camel@mfleming-mobl1.ger.corp.intel.com>  <5105E4A3.9040102@redhat.com> <1359376730.8282.20.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1359376730.8282.20.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 08:38 PM, Matt Fleming wrote:
> On Mon, 2013-01-28 at 10:38 +0800, Lingzhu Xiang wrote:
>> On 01/25/2013 09:18 PM, Matt Fleming wrote:
>>>> 4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
>>>>      can still read its content.
>>>
>>> I'm not sure what you mean by this. Could you please explain?
>>
>> Oops, this one is incorrect. I was testing EFI_VARIABLE_APPEND_WRITE
>> using this:
>>
>> printf "\x47\x00\x00\x00\x00" >test-1-$guid
>>
>> So it truncates the file before writing, but efivarfs figures out the right
>> size afterwards. The size remains zero if the write fails.
>>
>> I should be using this for appending:
>>
>> printf "\x47\x00\x00\x00\x00" >>test-1-$guid
> 
> Does this mean that these two test cases work as expected?

Mostly yes.

printf "\x47\x00\x00\x00\x00" >test-1-$guid

still shows unexpected truncate behavior. But this is the same one
already noted previously (truncate doesn't actually work). 
