Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaBHBxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 20:53:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55665 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaBHBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 20:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140207174315.GA11384@kroah.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
 <1390397779-30975-7-git-send-email-bergwolf@gmail.com> <20140207174315.GA11384@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Sat, 8 Feb 2014 09:52:44 +0800
Message-ID: <CA+a=Yy56eT1wa48DXCkS3KM4pzRFtzvq1GKAttZD6uRkuJ9_9A@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND 6/8] staging/lustre/obdclass: remove extra break
 in class_process_config
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Artem Blagodarenko <artem_blagodarenko@xyratex.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 8, 2014 at 1:43 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 22, 2014 at 09:36:17PM +0800, Peng Tao wrote:
>> From: Artem Blagodarenko <artem_blagodarenko@xyratex.com>
>>
>> This is only part of the original Lustre commit, splitted to do the
>> cleanup work.
>>
>> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3155
>> Lustre-change: http://review.whamcloud.com/6025
>> Signed-off-by: Artem Blagodarenko <artem_blagodarenko@xyratex.com>
>> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
>> Reviewed-by: Emoly Liu <emoly.liu@intel.com>
>> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>> ---
>>  .../staging/lustre/lustre/obdclass/obd_config.c    |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
>> index 27f56c0..fd08f1d 100644
>> --- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
>> +++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
>> @@ -1226,24 +1226,20 @@ int class_process_config(struct lustre_cfg *lcfg)
>>       case LCFG_POOL_NEW: {
>>               err = obd_pool_new(obd, lustre_cfg_string(lcfg, 2));
>>               GOTO(out, err = 0);
>> -             break;
>
> This confuses the static checkers.  Just fix up the GOTO logic (hint,
> remove it!) and then it will be "obvious" that the break can go away.
> But for now, please leave it, unless you want to have someone just put
> it back...
Got it.

Thanks,
Tao
