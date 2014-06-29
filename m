Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaF2VFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 17:05:32 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:58248 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaF2VFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 17:05:31 -0400
Message-ID: <53B07F99.40600@linicks.net>
Date: Sun, 29 Jun 2014 22:05:29 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
References: <53AE9058.50902@linicks.net> <20140628101240.GA6357@pd.tnic> <53AE9863.6050102@linicks.net> <53AE9F0B.1080207@linicks.net> <20140628122322.GC4373@pd.tnic> <53AEBE75.9070301@linicks.net> <53B063BC.4040200@linicks.net> <20140629194403.GB12943@pd.tnic>
In-Reply-To: <20140629194403.GB12943@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/14 20:44, Borislav Petkov wrote:
>> This then is an old(er) version of GCC issue (but I dunno what).
>
> Right, so the error points at
>
> __spin_lock_mb_cache_entry(struct mb_cache_entry *ce)
> {
>   spin_lock(bgl_lock_ptr(mb_cache_bg_lock,			<---
>    (hash_64((unsigned long)ce, __builtin_log2(8)))));
> }
>
> somewhere here and I'd guess that old gcc is issuing some lib function
> which uses SSE. And after we disabled all FPU stuff in the kernel with
> b399fe355b30 ("x86: Disable generation of traditional x87 instructions")
> that would issue such an error.
>
> And I was about to point at that __builtin_log2 thing which looked
> suspicious and found this by chance:
>
> http://lkml.kernel.org/r/1401471304-37479-1-git-send-email-tmac@hp.com
>
> You could test this patch with that old gcc 4.2.x as it looks like a
> good candidate for a fix for your issue.

Thanks Boris, but unfortunately I had to trash GCC 4.2.4 to build the 
new 4.7.4 version - so I can't test the patch :(

At least this issue is now on record so others will not need to go to 
penalties.

Many thanks,

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/
