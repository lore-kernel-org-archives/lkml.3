Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3GDJjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:39:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37430 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3GDJjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:39:03 -0400
Message-ID: <51D542C1.6060808@arm.com>
Date: Thu, 04 Jul 2013 10:39:13 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v5 5/6] staging: android: binder: replace types with portable
 ones
References: <1371661956-10894-1-git-send-email-serban.constantinescu@arm.com> <1371661956-10894-6-git-send-email-serban.constantinescu@arm.com> <CAMP5XgcgvSGezR5ZnoLik2r+ztFogxtPGNRzwHJtrK+zycCocw@mail.gmail.com>
In-Reply-To: <CAMP5XgcgvSGezR5ZnoLik2r+ztFogxtPGNRzwHJtrK+zycCocw@mail.gmail.com>
X-OriginalArrivalTime: 04 Jul 2013 09:38:57.0694 (UTC) FILETIME=[4E7573E0:01CE789A]
X-MC-Unique: 113070410390006101
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/13 23:30, Arve Hjønnevåg wrote:
> On Wed, Jun 19, 2013 at 10:12 AM, Serban Constantinescu
> <serban.constantinescu@arm.com> wrote:
>> Since this driver is meant to be used on different types of processors
>> and a portable driver should specify the size a variable expects to be
>> this patch changes the types used throughout the binder interface.
>>
>> We use "userspace" types since this header will be exported and used by
>> the Android filesystem.
>>
>> The patch does not change in any way the functionality of the binder driver.
>>
>> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
>> Acked-by: Arve Hjønnevåg <arve@android.com>
>> ---
>>   drivers/staging/android/binder.h |   26 +++++++++++++-------------
>>   1 file changed, 13 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
>> index b55bba9..dadfce0 100644
>> --- a/drivers/staging/android/binder.h
>> +++ b/drivers/staging/android/binder.h
>> @@ -123,10 +123,10 @@ struct binder_transaction_data {
>>                  void    *ptr;   /* target descriptor of return transaction */
>>          } target;
>>          void            *cookie;        /* target object cookie */
>> -       unsigned int    code;           /* transaction command */
>> +       __u32           code;           /* transaction command */
>>
>>          /* General information about the transaction. */
>> -       unsigned int    flags;
>> +       __u32           flags;
>>          pid_t           sender_pid;
>>          uid_t           sender_euid;
>>          size_t          data_size;      /* number of bytes of data */
>> @@ -143,7 +143,7 @@ struct binder_transaction_data {
>>                          /* offsets from buffer to flat_binder_object structs */
>>                          const void __user       *offsets;
>>                  } ptr;
>> -               uint8_t buf[8];
>> +               __u8    buf[8];
>>          } data;
>>   };
>>
>> @@ -153,18 +153,18 @@ struct binder_ptr_cookie {
>>   };
>>
>>   struct binder_pri_desc {
>> -       int priority;
>> -       int desc;
>> +       __s32 priority;
>> +       __s32 desc;
>
> desc should be __u32 to be consistent with the other changes you are
> making in this and the next patch.

I have added this change to v6 of this patch set which I will send out 
shortly.


Thanks again for your feedback,
Serban
>
>>   };
>>
>>   struct binder_pri_ptr_cookie {
>> -       int priority;
>> +       __s32 priority;
>>          void *ptr;
>>          void *cookie;
>>   };
>>
>>   enum binder_driver_return_protocol {
>> -       BR_ERROR = _IOR('r', 0, int),
>> +       BR_ERROR = _IOR('r', 0, __s32),
>>          /*
>>           * int: error code
>>           */
>> @@ -178,7 +178,7 @@ enum binder_driver_return_protocol {
>>           * binder_transaction_data: the received command.
>>           */
>>
>> -       BR_ACQUIRE_RESULT = _IOR('r', 4, int),
>> +       BR_ACQUIRE_RESULT = _IOR('r', 4, __s32),
>>          /*
>>           * not currently supported
>>           * int: 0 if the last bcATTEMPT_ACQUIRE was not successful.
>> @@ -258,7 +258,7 @@ enum binder_driver_command_protocol {
>>           * binder_transaction_data: the sent command.
>>           */
>>
>> -       BC_ACQUIRE_RESULT = _IOW('c', 2, int),
>> +       BC_ACQUIRE_RESULT = _IOW('c', 2, __s32),
>>          /*
>>           * not currently supported
>>           * int:  0 if the last BR_ATTEMPT_ACQUIRE was not successful.
>> @@ -270,10 +270,10 @@ enum binder_driver_command_protocol {
>>           * void *: ptr to transaction data received on a read
>>           */
>>
>> -       BC_INCREFS = _IOW('c', 4, int),
>> -       BC_ACQUIRE = _IOW('c', 5, int),
>> -       BC_RELEASE = _IOW('c', 6, int),
>> -       BC_DECREFS = _IOW('c', 7, int),
>> +       BC_INCREFS = _IOW('c', 4, __u32),
>> +       BC_ACQUIRE = _IOW('c', 5, __u32),
>> +       BC_RELEASE = _IOW('c', 6, __u32),
>> +       BC_DECREFS = _IOW('c', 7, __u32),
>>          /*
>>           * int: descriptor
>>           */
>> --
>> 1.7.9.5
>>
>
>
>
> --
> Arve Hjønnevåg
>

