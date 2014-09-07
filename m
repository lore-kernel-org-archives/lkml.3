Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaIGCKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 22:10:12 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43559 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaIGCKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 22:10:10 -0400
Message-ID: <540BBE7E.2060108@converseincode.com>
Date: Sat, 06 Sep 2014 19:10:06 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Milan Broz <gmazyland@gmail.com>, agk@redhat.com, dm-devel@redhat.com,
        snitzer@redhat.com
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org,
        =?UTF-8?B?SmFuLVNpbW9uIE3Dtg==?= =?UTF-8?B?bGxlcg==?= 
	<dl9pf@gmx.de>,
        pageexec@freemail.hu
Subject: Re: [PATCH v2] crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
References: <1409958138-2727-1-git-send-email-behanw@converseincode.com> <540AC9F7.9000202@gmail.com>
In-Reply-To: <540AC9F7.9000202@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 01:46, Milan Broz wrote:
> On 09/06/2014 01:02 AM, behanw@converseincode.com wrote:
>> From: Jan-Simon Möller <dl9pf@gmx.de>
>>
>> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
>> precludes the use of compilers which don't implement VLAIS (for instance the
>> Clang compiler). This patch instead allocates the appropriate amount of memory
>> using an char array.
> Well, if clang (or C99 code) is now preferred for kernel, why not.
>
> Just please commit the patch series en bloc (together with the patches
> removing VLAIS from crypto code you posted to cryptoapi list).
They seemed more separate than that. However, happy to post them as a 
patch set.

>> -	struct {
>> -		struct shash_desc desc;
>> -		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
>> -	} sdesc;
>> +	char sdesc[sizeof(struct shash_desc) +
>> +		crypto_shash_descsize(lmk->hash_tfm)] CRYPTO_MINALIGN_ATTR;
>> +	struct shash_desc *desc = (struct shash_desc *)sdesc;
> TBH, this looks even more uglier that the previous code :-)
I'm not claiming it's prettier. Merely C99. :)

> (But tglx already complained on different patch and I fully agree that crypto code
> should not use this kind of construction in the first place...
> It would be very nice to introduce at least some macro hiding these crazy
> stack allocations later.)
I actually agree with you and tglx. Will fix.

As I said to tglx, we were asked not to hide things with macro magic in 
some of our non-crypto VLAIS removal patches. Happy to use macros in 
this case.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

