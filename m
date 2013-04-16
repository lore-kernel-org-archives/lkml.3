Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3DPGoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:44:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4559 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3DPGoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:44:20 -0400
Message-ID: <516CF325.40604@huawei.com>
Date: Tue, 16 Apr 2013 14:43:49 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH 1/3] PCI,acpiphp: use generic pci_hp_add_bridge()
References: <1364808128-12792-1-git-send-email-wangyijing@huawei.com> <516CAE35.7090204@huawei.com> <CAE9FiQUACgSPffKQrKvb3zbrm-pg3gxkWxahNFFHofkW33sHwA@mail.gmail.com>
In-Reply-To: <CAE9FiQUACgSPffKQrKvb3zbrm-pg3gxkWxahNFFHofkW33sHwA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 15, 2013 at 6:49 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Hi Yinghai,
>>    Any comments about this patch? I searched the code history and found
>> you introduced pci_hp_add_bridge() function at commit a8e4b9c10. In your
>> patchset use pci_hp_add_bridge() for all pci hotplug drivers except acpiphp.
>> So I use pci_hp_add_bridge() in acpiphp instead of using pci_scan_bridge()
>> directly. I would appreciate if you can give some suggestions.

Hi Yinghai,
   Thanks for your review and comments very much!

> 
> There is one problem in your patch.
> max start value get change. before your patch max is the maximum value
> of bus all children...
>    now it is change bus  start value.

Thank you for reminding. Now I noticed this detail.(:
I will drop these pathes.

Thanks!
Yijing.

> 
> looks like old code try to handle the case that we already some
> children on that bus.
> 
> Last time i did not change it, because i think it only is ready after
> busn_res alloc patchset
> is merged.
> 
> in pci-mini summit of last year, Bjorn asked Linus about that
> patchset, and Linus said it is
> risky and it is not worthy to merge it .
> 
> so assume we should hold your patch as it could cause some regression.
> 
> Thanks
> 
> Yinghai
> 
> .
> 


-- 
Thanks!
Yijing

