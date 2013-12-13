Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3LMROQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:14:16 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:57187 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3LMROL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131213085651.GB4386@leaf>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
	<49ece621a2dbbdfad71e81c3185d7e8a32c52823.1386915618.git.rashika.kheria@gmail.com>
	<20131213085651.GB4386@leaf>
Date: Fri, 13 Dec 2013 11:14:10 -0600
Message-ID: <CAPp3RGqUG7qQrBj3OR0rQTnkgSa2eP_YXav9JQL7xUNygwiN3A@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivers: misc: Mark functions as static in xp_main.c
From: Robin Holt <robinmholt@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Cliff Whickman <cpw@sgi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 2:56 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Fri, Dec 13, 2013 at 12:21:20PM +0530, Rashika Kheria wrote:
>> This patch marks the function xp_init() and xp_exit() as static in
>> sgi-xp/xp_main.c because they are not used outside this file.
>>
>> Thus, it also eliminates the following warnings in sgi-xp/xp_main.c:
>> drivers/misc/sgi-xp/xp_main.c:249:1: warning: no previous prototype for ‘xp_init’ [-Wmissing-prototypes]
>> drivers/misc/sgi-xp/xp_main.c:274:1: warning: no previous prototype for ‘xp_exit’ [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Robin Holt <robinmholt@gmail.com>

>
>>  drivers/misc/sgi-xp/xp_main.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
>> index 01be66d..df14c70 100644
>> --- a/drivers/misc/sgi-xp/xp_main.c
>> +++ b/drivers/misc/sgi-xp/xp_main.c
>> @@ -245,7 +245,7 @@ xpc_disconnect(int ch_number)
>>  }
>>  EXPORT_SYMBOL_GPL(xpc_disconnect);
>>
>> -int __init
>> +static int __init
>>  xp_init(void)
>>  {
>>       enum xp_retval ret;
>> @@ -270,7 +270,7 @@ xp_init(void)
>>
>>  module_init(xp_init);
>>
>> -void __exit
>> +static void __exit
>>  xp_exit(void)
>>  {
>>       if (is_shub())
>> --
>> 1.7.9.5
>>
