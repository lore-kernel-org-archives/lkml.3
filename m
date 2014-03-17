Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaCQTvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:51:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42130 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCQTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:51:31 -0400
Date: Mon, 17 Mar 2014 15:51:28 -0400 (EDT)
Message-Id: <20140317.155128.1576479712298453623.davem@davemloft.net>
To: sam@ravnborg.org
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: use %s for unaligned panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140315080709.GA14405@ravnborg.org>
References: <20140311202446.GA24531@www.outflux.net>
	<20140315080709.GA14405@ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Mar 2014 12:51:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 15 Mar 2014 09:07:09 +0100

> On Tue, Mar 11, 2014 at 01:24:46PM -0700, Kees Cook wrote:
>> Since unaligned_panic() takes a literal string, make sure it can never
>> accidentally be used as a format string.
>> 
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/sparc/kernel/unaligned_32.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
>> index c0ec89786193..892e399414e0 100644
>> --- a/arch/sparc/kernel/unaligned_32.c
>> +++ b/arch/sparc/kernel/unaligned_32.c
>> @@ -162,7 +162,7 @@ unsigned long safe_compute_effective_address(struct pt_regs *regs,
>>  /* This is just to make gcc think panic does return... */
>>  static void unaligned_panic(char *str)
>>  {
>> -	panic(str);
>> +	panic("%s", str);
>>  }
>>  
>>  /* una_asm.S */
> 
> Another "fix" would be to align with sparc64 and call die_if_kernel()

Furthermore, this is a silly change because there are only two call sites, they
are both in this file, and they clearly do not pass format strings embedded
in the string.
