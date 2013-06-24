Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3FXG7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:59:20 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1156 "EHLO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3FXG7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:59:16 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6388
Message-ID: <51C7EE57.4020005@metafoo.de>
Date: Mon, 24 Jun 2013 08:59:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Otavio Salvador <otavio@ossystems.com.br>,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: mxs-lradc oops when unloading module
References: <CAP9ODKof+yv27-zHSO9MTLC9Wv6F6Ya-Ot-vW7OK7kwadYK8Xg@mail.gmail.com> <CAP9ODKq92LW-xQyiHkVe6AkwaaYV11nt92DxCEzUioEVARTZXw@mail.gmail.com> <51C5847C.7030100@kernel.org>
In-Reply-To: <51C5847C.7030100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2013 01:03 PM, Jonathan Cameron wrote:
> On 06/16/2013 10:09 PM, Otavio Salvador wrote:
>> [ I am resending as it didn't make iio mailing list as the message
>> wasn't plain text ]
>>
>> Hello,
>>
>> When using mxs-lradc, as module, in a MX23 and unloading the driver,
>> it sometimes oops as:
>>
>> [   46.340000] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000005
>> [   46.340000] pgd = c7744000
>> [   46.350000] [00000005] *pgd=46f4d831, *pte=00000000, *ppte=00000000
>> [   46.360000] Internal error: Oops: 1 [#1] ARM
>> [   46.360000] Modules linked in: mxs_lradc(C-) industrialio_triggered_buffer
>> [   46.360000] CPU: 0 PID: 359 Comm: rmmod Tainted: G         C
>> 3.10.0-rc5+ #24
>> [   46.360000] task: c6f6a200 ti: c680e000 task.ti: c680e000
>> [   46.360000] PC is at module_put+0x18/0x80
>> [   46.360000] LR is at iio_device_unregister_trigger_consumer+0x1c/0x28
>> [   46.360000] pc : [<c0063334>]    lr : [<c0373808>]    psr: a0000013
>> [   46.360000] sp : c680feb0  ip : 60000013  fp : 01324008
>> [   46.360000] r10: 00000013  r9 : c680e000  r8 : 00000000
>> [   46.360000] r7 : c6ee9418  r6 : c0373808  r5 : c6ee8800  r4 : c6ee9810
>> [   46.360000] r3 : 00000001  r2 : c067a428  r1 : 000002e0  r0 : c6ee8800
>> [   46.360000] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> [   46.360000] Control: 0005317f  Table: 47744000  DAC: 00000015
>> [   46.360000] Process rmmod (pid: 359, stack limit = 0xc680e1b8)
>> [   46.360000] Stack: (0xc680feb0 to 0xc6810000)
>> [   46.360000] fea0:                                     c6ee9810
>> c6ee9400 c76cff80 c0373808
>> [   46.360000] fec0: c6ee9410 c036f9bc c036f990 c6ee9418 c6ee9410
>> c02a9610 c6ee9434 c065fbe0
>> [   46.360000] fee0: c77ccbe0 c024bc40 00000000 c6ee9400 00000000
>> c74c0644 c680e000 bf0049c4
>> [   46.360000] ff00: bf004940 c74c0610 bf00589c c02ae058 c02ae044
>> c02ac8f0 bf00589c c74c0610
>> [   46.360000] ff20: bf00589c c02ad0dc bf0058dc bf00589c c065fe60
>> c02ac730 bf0058dc 00000000
>> [   46.360000] ff40: 00000800 c0064010 ffffffff 5f73786d 6461726c
>> 00000063 c6f6a200 c680e000
>> [   46.360000] ff60: c6f6a200 c000edcc 00000001 00000000 c680e000
>> bec16e48 01324008 c005c754
>> [   46.360000] ff80: 01324088 00000800 01324088 01324088 00000800
>> 01324088 00000081 c000ef08
>> [   46.360000] ffa0: 00000000 c000ed40 01324088 00000800 013240b8
>> 00000800 bec16c08 ffffeffc
>> [   46.360000] ffc0: 01324088 00000800 01324088 00000081 00000001
>> bec16c38 bec16e48 01324008
>> [   46.360000] ffe0: 4d819ef0 bec16bf4 4d808768 4d721e6c 20000010
>> 013240b8 15401540 51110540
>> [   46.360000] [<c0063334>] (module_put+0x18/0x80) from [<c0373808>]
>> (iio_device_unregister_trigger_consumer+0x1c/0x28)
>> [   46.360000] [<c0373808>]
>> (iio_device_unregister_trigger_consumer+0x1c/0x28) from [<c036f9bc>]
>> (iio_dev_release+0x2c/0x6c)
>> [   46.360000] [<c036f9bc>] (iio_dev_release+0x2c/0x6c) from
>> [<c02a9610>] (device_release+0x2c/0x90)
>> [   46.360000] [<c02a9610>] (device_release+0x2c/0x90) from
>> [<c024bc40>] (kobject_release+0x48/0x7c)
>> [   46.360000] [<c024bc40>] (kobject_release+0x48/0x7c) from
>> [<bf0049c4>] (mxs_lradc_remove+0x84/0x90 [mxs_lradc])
>> [   46.360000] [<bf0049c4>] (mxs_lradc_remove+0x84/0x90 [mxs_lradc])
>> from [<c02ae058>] (platform_drv_remove+0x14/0x18)
>> [   46.360000] [<c02ae058>] (platform_drv_remove+0x14/0x18) from
>> [<c02ac8f0>] (__device_release_driver+0x58/0xb4)
>> [   46.360000] [<c02ac8f0>] (__device_release_driver+0x58/0xb4) from
>> [<c02ad0dc>] (driver_detach+0xb4/0xb8)
>> [   46.360000] [<c02ad0dc>] (driver_detach+0xb4/0xb8) from
>> [<c02ac730>] (bus_remove_driver+0x7c/0xc0)
>> [   46.360000] [<c02ac730>] (bus_remove_driver+0x7c/0xc0) from
>> [<c0064010>] (SyS_delete_module+0x150/0x26c)
>> [   46.360000] [<c0064010>] (SyS_delete_module+0x150/0x26c) from
>> [<c000ed40>] (ret_fast_syscall+0x0/0x44)
>> [   46.360000] Code: e1a0600e 08bd8070 e5953174 e59f2060 (e5931004)
>> [   46.650000] ---[ end trace 7379015df3468e61 ]---
>>
>> From what I could grasp, it might be related to the IIO subsystem but
>> I couldn't find the culprit.
>>
>> It seems "iio_device_unregister_trigger_consumer", as:
>>
>> void iio_device_unregister_trigger_consumer(struct iio_dev *indio_dev)
>> {
>> /* Clean up an associated but not attached trigger reference */
>> if (indio_dev->trig)
>> iio_trigger_put(indio_dev->trig);
>> }
>>
>> and , as:
>>
>> static inline void iio_trigger_put(struct iio_trigger *trig)
>> {
>> module_put(trig->ops->owner);
>> put_device(&trig->dev);
>> }
>>
>> so, somehow the trig->ops is NULL here.
>>
>> Do someone has a clue?
>>
> I think the issue is more core to iio trigger handling than that, you
> have just been unlucky enough to hit a bug that has been there a while.
> 
> In iio_trigger_unregister we call
> iio_device_unregister which in turn calls device_del (as intended) and
> device_put (as not!).  Then we get an additional device_put from
> iio_trigger_free giving us one more than we should have an resulting
> in a double attempt to free the device.
> 
> Could you try the following change and see if it solves the problem?
> (the comment abov is 'interesting' and stupid given I've long ago
> forgotten what it refers to, but it could be related to this issue...)

Regardless of whether it fixes the problem or not the patch should be
applied, since it is definitely correct.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

> 
> From 238faf76acaa9214b0eb607742dd14b134469328 Mon Sep 17 00:00:00 2001
> From: Jonathan Cameron <jic23@kernel.org>
> Date: Sat, 22 Jun 2013 12:00:04 +0100
> Subject: [PATCH] iio:trigger: device_unregister->device_del to avoid double
>  free
> 
> iio_trigger unregistration and freeing has been separated in this
> code for some time, but it looks like the calls to the device
> handling were not appropriately updated.
> 
> Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/iio/industrialio-trigger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
> index 4d6c7d8..ea8a414 100644
> --- a/drivers/iio/industrialio-trigger.c
> +++ b/drivers/iio/industrialio-trigger.c
> @@ -104,7 +104,7 @@ void iio_trigger_unregister(struct iio_trigger *trig_info)
> 
>  	ida_simple_remove(&iio_trigger_ida, trig_info->id);
>  	/* Possible issue in here */
> -	device_unregister(&trig_info->dev);
> +	device_del(&trig_info->dev);
>  }
>  EXPORT_SYMBOL(iio_trigger_unregister);
> 

