Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaBMSBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:01:11 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:51912 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaBMSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:01:09 -0500
MIME-Version: 1.0
In-Reply-To: <52FD07AF.1030604@panasas.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
	<008a7e048e6eee2d773e092660183f21d52e4874.1391949868.git.rashika.kheria@gmail.com>
	<52FD07AF.1030604@panasas.com>
Date: Thu, 13 Feb 2014 23:31:08 +0530
Message-ID: <CAMpEsFHiGFaA2t6yMT7VCyRq93wYv8uOqhg6W=xAYvGtztjr=w@mail.gmail.com>
Subject: Re: [PATCH 05/21] fs: Mark function as static in exofs/super.c
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:28 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 02/09/2014 03:01 PM, Rashika Kheria wrote:
>> Mark function as static in exofs/super.c because it is not used outside
>> this file.
>>
>> This also eliminates the following warning in exofs/super.c:
>> fs/exofs/super.c:546:5: warning: no previous prototype for '__alloc_dev_table' [-Wmissing-prototypes]
>>
>> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> Hi Rashika
>
> Thanks for the fixes.
>
> Do you need me to push it to Linus through my tree or do you need an:
> ACK-by: Boaz Harrosh <bharrosh@panasas.com>
>
> [Same for [PATCH 06/21] fs: Mark functions as static in exofs/ore_raid.c ]
>
> Thanks again
> Boaz
>

Hi Boaz,

It would be nice if you could push it to Linus through you tree.

Thanks,
Rashika Kheria

>> ---
>>  fs/exofs/super.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
>> index 9d97633..57f59a2 100644
>> --- a/fs/exofs/super.c
>> +++ b/fs/exofs/super.c
>> @@ -543,8 +543,8 @@ static int exofs_devs_2_odi(struct exofs_dt_device_info *dt_dev,
>>       return !(odi->systemid_len || odi->osdname_len);
>>  }
>>
>> -int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
>> -                   struct exofs_dev **peds)
>> +static int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
>> +                          struct exofs_dev **peds)
>>  {
>>       struct __alloc_ore_devs_and_exofs_devs {
>>               /* Twice bigger table: See exofs_init_comps() and comment at
>>
>



-- 
Rashika Kheria
B.Tech CSE
IIIT Hyderabad
