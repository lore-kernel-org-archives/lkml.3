Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LJGDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:03:55 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:36965 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3LJGDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:03:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131209213057.GA11314@phenom.dumpdata.com>
References: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
	<20131209213057.GA11314@phenom.dumpdata.com>
Date: Tue, 10 Dec 2013 14:03:51 +0800
Message-ID: <CABawtvMGOJg5DPRwdWAOSTkxgurv5bx8n=3yJFOq=aagxzseZQ@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] iscsi_boot_sysfs: Fix a memory leak in iscsi_boot_destroy_kset()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: michaelc@cs.wisc.edu, pjones@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

 boot_kset was allocated when module loaded by
ibft_init()
  iscsi_boot_create_kset()
     kzalloc()

but wasn't freed when module unloaded by
ibft_exit()
   ibft_cleanup()
     iscsi_boot_destroy_kset()

Thanks,
Ethan

On Tue, Dec 10, 2013 at 5:30 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Dec 09, 2013 at 05:37:11PM +0800, Ethan Zhao wrote:
>> From: "Ethan Zhao" <ethan.kernel@gmail.com>
>>
>> Load and unload iscsi_ibft module will cause kernel memory leak, fix it
>> in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().
>>
>
> Is there a stack trace?
>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>> ---
>>  drivers/scsi/iscsi_boot_sysfs.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
>> index 14c1c8f..680bf6f 100644
>> --- a/drivers/scsi/iscsi_boot_sysfs.c
>> +++ b/drivers/scsi/iscsi_boot_sysfs.c
>> @@ -490,5 +490,6 @@ void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
>>               iscsi_boot_remove_kobj(boot_kobj);
>>
>>       kset_unregister(boot_kset->kset);
>> +     kfree(boot_kset);
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);
>> --
>> 1.8.3.4 (Apple Git-47)
>>
