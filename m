Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaLQQij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:38:39 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42169 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaLQQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:38:38 -0500
Message-ID: <5491A16A.7050101@de.ibm.com>
Date: Wed, 17 Dec 2014 16:29:46 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] arm/rpc: avoid static keyword removal via define
References: <1418633287-5019-1-git-send-email-borntraeger@de.ibm.com> <1418633287-5019-2-git-send-email-borntraeger@de.ibm.com> <5490146A.3000408@de.ibm.com> <20141216114056.GP11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141216114056.GP11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121716-0013-0000-0000-0000023FF1EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.12.2014 um 12:40 schrieb Russell King - ARM Linux:
> On Tue, Dec 16, 2014 at 12:15:54PM +0100, Christian Borntraeger wrote:
>> Am 15.12.2014 um 09:48 schrieb Christian Borntraeger:
>>> commit 4486b86368d7 ("[ARM] riscpc: fix decompressor font file handling")
>>> introduced Makefile magic to avoid building a file two times. Using
>>> -Dstatic= does break some assumptions on compiler.h that were introduced
>>> for READ_ONCE.
>>>
>>> Lets just use sed on the copy instead of using a define.
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>
>> This fixed the linux-next build http://kisskb.ellerman.id.au/kisskb/target/1508/
>> Unless anybody complains, I will send the pull request for the access_once tree tomorrow and I have this patch applied on top.
> 
> Please give me some time to look at this.

>From all builds, the only problematic case was the rpc_defconfig.
So only CONFIG_ARCH_ACORN is affected.

As I said, I want to send this series this merge window, so if you
do not find the time to look into this before rc1, what about removing
this patch from my queue and we solve this later? 
Acorn Risc CPU is probably not the hottest platform right now, so if we 
fix this in rc2 or rc3 this might be ok - I guess.

Christian

