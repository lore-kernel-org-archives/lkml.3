Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaDAIS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:18:26 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:58543 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaDAISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <533A85A70200007800003F59@nat28.tlf.novell.com>
References: <2186395.ZOncrV6nFS@daeseok-laptop.cloud.net>
	<533A85A70200007800003F59@nat28.tlf.novell.com>
Date: Tue, 1 Apr 2014 17:17:55 +0900
Message-ID: <CAHb8M2AXChNkeXqHfThO8=JBQ8QCN7rLTs-Rbdgz3XWzwY_EQA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen: fix memory leak in __xen_pcibk_add_pci_dev()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        Joe Perches <joe@perches.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-01 16:23 GMT+09:00 Jan Beulich <JBeulich@suse.com>:
>>>> On 31.03.14 at 12:08, <daeseok.youn@gmail.com> wrote:
>
>> It need to free dev_entry when it failed to assign to a new
>> slot on the virtual PCI bus.
>>
>> smatch says:
>>  drivers/xen/xen-pciback/vpci.c:142 __xen_pcibk_add_pci_dev() warn:
>> possible memory leak of 'dev_entry'
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>
> albeit the solution is not ideal:
>
>> --- a/drivers/xen/xen-pciback/vpci.c
>> +++ b/drivers/xen/xen-pciback/vpci.c
>> @@ -130,6 +130,7 @@ static int __xen_pcibk_add_pci_dev(struct
>> xen_pcibk_device *pdev,
>>       err = -ENOMEM;
>>       xenbus_dev_fatal(pdev->xdev, err,
>>                        "No more space on root virtual PCI bus");
>> +     kfree(dev_entry);
>>
>>  unlock:
>>       mutex_unlock(&vpci_dev->lock);
>
> The kfree() invocation would better be placed outside the locked
> region (e.g. in an else to the "if (!err)" a little further down).

You're right.
I will change my patch as your comment and send it again.

Thanks for review.
Daeseok Youn

>
> Jan
>
