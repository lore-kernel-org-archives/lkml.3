Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3GOOJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:09:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56940 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3GOOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <1373895529.2062.15.camel@joe-AO722>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
 <1373893695-4094-7-git-send-email-bergwolf@gmail.com> <1373895529.2062.15.camel@joe-AO722>
From: Peng Tao <bergwolf@gmail.com>
Date: Mon, 15 Jul 2013 22:08:38 +0800
Message-ID: <CA+a=Yy5sE-xLvOJg66jMevxmBkwB9YMaV0akayxyexao5kWOqw@mail.gmail.com>
Subject: Re: [PATCH-v2 06/17] staging/lustre: remove HIPQUAD
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 9:38 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-07-15 at 21:08 +0800, Peng Tao wrote:
> []
>> We should just remove HIPQUAD and replace it with %pI4.
>
> HIPQUAD and NIPQUAD were host and network order variants.
> Perhaps you need %pI4h for the host uses?
>
Thanks for pointing it out. Yes, you are right. Without the additional
specifier, network order is used. I will update the patch to fix it.

Thanks,
Tao

>> diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> []
>> @@ -2574,8 +2574,8 @@ kiblnd_dev_need_failover(kib_dev_t *dev)
>>       rc = rdma_resolve_addr(cmid, (struct sockaddr *)&srcaddr,
>>                              (struct sockaddr *)&dstaddr, 1);
>>       if (rc != 0 || cmid->device == NULL) {
>> -             CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
>> -                    dev->ibd_ifname, HIPQUAD(dev->ibd_ifip),
>> +             CERROR("Failed to bind %s:%pI4 to device(%p): %d\n",
>> +                    dev->ibd_ifname, &dev->ibd_ifip,
>>                      cmid->device, rc);
>
> Like this one?
>
