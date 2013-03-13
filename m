Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab3CMMiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:38:07 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46107 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab3CMMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <36693.1363044515@turing-police.cc.vt.edu>
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
	<36693.1363044515@turing-police.cc.vt.edu>
Date: Wed, 13 Mar 2013 21:38:04 +0900
Message-ID: <CAC5umyhija4=87uQ_Aom7Ypj7DysFSLR21k3sZTVux+fvxMLJw@mail.gmail.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/12  <Valdis.Kletnieks@vt.edu>:
> On Sun, 10 Mar 2013 17:09:50 +0900, Akinobu Mita said:
>> This fixes the wrong position of the comment introduced by
>> scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
>> index 04bf7b8..e44d47e 100644
>> --- a/drivers/scsi/qla2xxx/qla_attr.c
>> +++ b/drivers/scsi/qla2xxx/qla_attr.c
>> @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>>       }
>>
>>       /* No pending activities shall be there on the vha now */
>> -     if (ql2xextended_error_logging & ql_dbg_user)
>> -             msleep(prandom_u32() % 10);
>> +     if (ql2xextended_error_logging & ql_dbg_user) {
>>               /*
>>                * Just to see if something falls on the net we have placed
>>                * below
>>                */
>> -
>> +             msleep(prandom_u32() % 10);
>> +     }
>>       BUG_ON(atomic_read(&vha->vref_count));
>
> As others have noted, the msleep is potentially a crock.  However,
> this particular patch is also incorrect - the *real* problem is
> that the 4 line comment connected to the BUG_ON is mis-indented.

In the original code (quoted below), the comment actually connected
to the msleep(), but the word "below" in the comment points to BUG_ON.
So the comment should also be updated in this patch...

        /* No pending activities shall be there on the vha now */
        if (ql2xextended_error_logging & ql_dbg_user)
                msleep(random32()%10);  /* Just to see if something falls on
                                        * the net we have placed below */

        BUG_ON(atomic_read(&vha->vref_count));
