Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaIDU7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:59:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbaIDU7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:59:33 -0400
Message-ID: <5408D299.5000300@zytor.com>
Date: Thu, 04 Sep 2014 13:59:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Yinghai Lu <yinghai@kernel.org>
CC: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org> <20140904100137.GK3001@console-pimps.org>
In-Reply-To: <20140904100137.GK3001@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 03:01 AM, Matt Fleming wrote:
> On Wed, 03 Sep, at 09:50:07PM, Yinghai Lu wrote:
>> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
>> loaded above 4G"), the kernel freezes at the earliest possible moment
>> when trying to boot via UEFI on Asus laptop.
>>
>> Revert to old way to load initrd under 4G on first try,
>> second try will use above 4G buffer when initrd is too big
>> and does not fit under 4G.
>>
>> -v2: add print out for second try, and print out files buf address.
>> -v3: can not snprintf
>> -v4: drop address print out for files buf
>>
>> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
>> Tested-by: Anders Darander <anders@chargestorm.se>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/boot/compressed/eboot.c |   18 +++++++++++-------
>>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> Thanks, I've picked this up and expanded on the commit message because a
> lot of useful information was discussed on the mailing list that we
> should definitely include.
> 
>   http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=b524e05df6d466af2f7eea1f044369109e48e641
> 

I am fine with this patch, but at the same time I do want to note that
there is an alternative to double-buffer the patch and/or (if that
applies to the buggy BIOS) round up the size of the target buffer.

	-hpa

