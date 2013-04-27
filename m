Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3D0CDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:03:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:20315 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3D0CDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:03:21 -0400
Message-ID: <517B31D4.9020909@huawei.com>
Date: Sat, 27 Apr 2013 10:03:00 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] PCI: Enable pci bridge when it is needed
References: <1367024974-6063-1-git-send-email-yinghai@kernel.org> <517B2F1B.6000704@huawei.com> <CAE9FiQWLfdgR8VoqeVOpCdHa3TpK26Bgs7mZ7Ed+Zq60S=g8Vg@mail.gmail.com>
In-Reply-To: <CAE9FiQWLfdgR8VoqeVOpCdHa3TpK26Bgs7mZ7Ed+Zq60S=g8Vg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/27 9:57, Yinghai Lu wrote:
> On Fri, Apr 26, 2013 at 6:51 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> I think it's cool! Now we enable bridge in various places, this is a headache.
>>
>> hi, yinghai, in this patch, enable bridges depend on the driver call pci_enable_device() explicitly.
>> I was a little worried If there has some devices don't have some drivers bound, but used by system.
>> like ioapic, these devices maybe implemented as pci device, but no pci drivers bind, also, maybe they
>> won't call pci_enable_device() explicity. So if they are under the pci bridge, no one will enable the bridge
>> for them.
> 
> If there is really that case, we could call pci_enable_device in
> pci_final quirk for
> them.

Hmm, ok, and I tested this patch in my hotplug machine, it looks good.


> 
> Yinghai
> 
> 


-- 
Thanks!
Yijing

