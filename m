Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3DOCfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:35:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:60296 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3DOCfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:35:21 -0400
Message-ID: <516B673D.5020201@huawei.com>
Date: Mon, 15 Apr 2013 10:34:37 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Tony Luck <tony.luck@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 2/2] PCI/IA64: fix pci_dev->enable_cnt balance when doing
 pci hotplug
References: <1364805775-12396-1-git-send-email-wangyijing@huawei.com> <1364805775-12396-2-git-send-email-wangyijing@huawei.com> <CAErSpo7g7dG=FB69-w1UniO_fpBVO39P82rqgdQstdfG=p-bkQ@mail.gmail.com>
In-Reply-To: <CAErSpo7g7dG=FB69-w1UniO_fpBVO39P82rqgdQstdfG=p-bkQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -383,6 +383,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>>         }
>>
>>         pci_scan_child_bus(pbus);
>> +       pci_enable_bridges(pbus);
>>         return pbus;
>>
>>  out3:
> 
> I think that with this patch, if you hot-add a PCI host bridge, you
> will call pci_enable_bridges() twice (once in pci_acpi_scan_root() and
> again in acpi_pci_root_add()), so there will be an enable_cnt error in
> the opposite direction.
> 
> I'd like to see the pci_enable_bridges() calls pushed up into the
> generic code because I don't think there's anything arch-specific
> about it.

Hi Bjorn,
   Thanks for your review and comments! This is my fault, I forgot we will enable pci
bridges when we hot add host bridge. Push pci_enable_bridges() into the generic code is
a good idea, so we don't need to consider enabling bridge in pci arch-specific code.
In IA64 we don't assign the unassigned resources like other arch. This is also a weak point.
I will update this patch and resend soon.

Thanks!
Yijing.
> 
> .
> 


-- 
Thanks!
Yijing

