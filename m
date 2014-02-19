Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaBSAyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:54:22 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64466 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaBSAyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:54:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140218141934.902737c24a0b46ef42e6ea9a@linux-foundation.org>
References: <1392624815-20759-1-git-send-email-21cnbao@gmail.com> <20140218141934.902737c24a0b46ef42e6ea9a@linux-foundation.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 19 Feb 2014 08:54:00 +0800
Message-ID: <CAGsJ_4zyfCWhTKsspXC9DV3hR7jYvv1k=MMBSLJsd0aeTs+svQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/rpmsg/virtio_rpmsg_bus.c: fix the return value of rpmsg_init
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Wei Chen <Wei.Chen@csr.com>, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-19 6:19 GMT+08:00 Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 17 Feb 2014 16:13:34 +0800 Barry Song <21cnbao@gmail.com> wrote:
>
>> From: Wei Chen <Wei.Chen@csr.com>
>>
>> rpmsg_init() always return ERROR code or random integer now, this patch fixes
>> it.
>>
>> ...
>>
>> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
>> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
>> @@ -1096,9 +1096,10 @@ static int __init rpmsg_init(void)
>>       if (ret) {
>>               pr_err("failed to register virtio driver: %d\n", ret);
>>               bus_unregister(&rpmsg_bus);
>> +             return ret;
>>       }
>>
>> -     return ret;
>> +     return 0;
>>  }
>
> Look more closely.  This patch has no effect...

yes, when i look again i find it does have no effect as successful
bus_register() has made ret 0. but the codes are much unreadable
then....

static int __init rpmsg_init(void)
{
        int ret;

        ret = bus_register(&rpmsg_bus);
        if (ret) {
                pr_err("failed to register rpmsg bus: %d\n", ret);
                return ret;
        }

        ret = register_virtio_driver(&virtio_ipc_driver);
        if (ret) {
                pr_err("failed to register virtio driver: %d\n", ret);
                bus_unregister(&rpmsg_bus);
        }

        return ret;
}
subsys_initcall(rpmsg_init);

-barry
