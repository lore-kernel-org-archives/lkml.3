Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3LMROj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:14:39 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:55599 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3LMROh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131213085713.GC4386@leaf>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
	<247d6936184150df6f885ad656dae7412aaf6260.1386915618.git.rashika.kheria@gmail.com>
	<20131213085713.GC4386@leaf>
Date: Fri, 13 Dec 2013 11:14:37 -0600
Message-ID: <CAPp3RGqpTs4WDgWu3tQbUKFsY2kmgX+u3=ouk47ZS-BQ1VNSPg@mail.gmail.com>
Subject: Re: [PATCH 3/5] drivers: misc: Mark functions as static in xpc_main.c
From: Robin Holt <robinmholt@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Cliff Whickman <cpw@sgi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 2:57 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Fri, Dec 13, 2013 at 12:24:05PM +0530, Rashika Kheria wrote:
>> This patch marks the function xpc_init() and xpc_exit() as static in
>> sgi-xp/xpc_main.c because they are not used outside this file.
>>
>> Thus, it also eliminates the following warnings in sgi-xp/xpc_main.c:
>> drivers/misc/sgi-xp/xpc_main.c:1231:1: warning: no previous prototype for ‘xpc_init’ [-Wmissing-prototypes]
>> drivers/misc/sgi-xp/xpc_main.c:1349:1: warning: no previous prototype for ‘xpc_exit’ [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Robin Holt <robinmholt@gmail.com>

>
>>  drivers/misc/sgi-xp/xpc_main.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
>> index 82dc574..5b1b10d 100644
>> --- a/drivers/misc/sgi-xp/xpc_main.c
>> +++ b/drivers/misc/sgi-xp/xpc_main.c
>> @@ -1227,7 +1227,7 @@ xpc_system_die(struct notifier_block *nb, unsigned long event, void *_die_args)
>>       return NOTIFY_DONE;
>>  }
>>
>> -int __init
>> +static int __init
>>  xpc_init(void)
>>  {
>>       int ret;
>> @@ -1345,7 +1345,7 @@ out_1:
>>
>>  module_init(xpc_init);
>>
>> -void __exit
>> +static void __exit
>>  xpc_exit(void)
>>  {
>>       xpc_do_exit(xpUnloading);
>> --
>> 1.7.9.5
>>
