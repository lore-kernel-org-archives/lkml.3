Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaIJIH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:07:26 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46084 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaIJIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <540F749B.6080607@nod.at>
References: <1410265519-25111-1-git-send-email-richard.genoud@gmail.com> <540F749B.6080607@nod.at>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 10 Sep 2014 10:06:58 +0200
Message-ID: <CACQ1gAgtwANFzkxBrJ4OoYRvk1RLe4_W=VEK5=t3dYbSd_gZRA@mail.gmail.com>
Subject: Re: [PATCH] UBI: add missing kmem_cache_free() in process_pool_aeb
 error path
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-09 23:43 GMT+02:00 Richard Weinberger <richard@nod.at>:
> Am 09.09.2014 14:25, schrieb Richard Genoud:
>> I ran into this error after a ubiupdatevol, because I forgot to backport
>> e9110361a9a4 UBI: fix the volumes tree sorting criteria.
>>
>> UBI error: process_pool_aeb: orphaned volume in fastmap pool
>> UBI error: ubi_scan_fastmap: Attach by fastmap failed, doing a full scan!
>> kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still has objects
>> CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.18-00053-gf05cac8dbf85 #1
>> [<c000d298>] (unwind_backtrace) from [<c000baa8>] (show_stack+0x10/0x14)
>> [<c000baa8>] (show_stack) from [<c01b7a68>] (destroy_ai+0x230/0x244)
>> [<c01b7a68>] (destroy_ai) from [<c01b8fd4>] (ubi_attach+0x98/0x1ec)
>> [<c01b8fd4>] (ubi_attach) from [<c01ade90>] (ubi_attach_mtd_dev+0x2b8/0x868)
>> [<c01ade90>] (ubi_attach_mtd_dev) from [<c038b510>] (ubi_init+0x1dc/0x2ac)
>> [<c038b510>] (ubi_init) from [<c0008860>] (do_one_initcall+0x94/0x140)
>> [<c0008860>] (do_one_initcall) from [<c037aadc>] (kernel_init_freeable+0xe8/0x1b0)
>> [<c037aadc>] (kernel_init_freeable) from [<c02730ac>] (kernel_init+0x8/0xe4)
>> [<c02730ac>] (kernel_init) from [<c00093f0>] (ret_from_fork+0x14/0x24)
>> UBI: scanning is finished
>>
>> Freeing the cache in the error path fixes the Slab error.
>>
>> Tested on at91sam9g35 (3.14.18+fastmap backports)
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> Cc: stable <stable@vger.kernel.org> # >= 3.10
>
> I guess you wrote 3.10 because there is no stable kernel between >= 3.7 and < 3.10?
Yes, that's right.
I checked that
git am 0001-UBI-add-missing-kmem_cache_free-in-process_pool_aeb-.patch
Applied correctly on 3.10.54, 3.12.28, 3.14.18, 3.16.2 and 3.17-rc4



> Patch looks good otherwise.
>
> Acked-by: Richard Weinberger <richard@nod.at>
>
> Thanks,
> //richard
