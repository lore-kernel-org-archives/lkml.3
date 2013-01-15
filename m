Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3AOHFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:05:51 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55015 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3AOHFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:05:48 -0500
MIME-Version: 1.0
In-Reply-To: <50F4FB24.80200@huawei.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1357944049-29620-2-git-send-email-yinghai@kernel.org>
	<50F4FB24.80200@huawei.com>
Date: Mon, 14 Jan 2013 23:05:47 -0800
X-Google-Sender-Auth: xCxOmkTlda55HFN84DrvWxW9UeY
Message-ID: <CAE9FiQUsLCDBV6nNW+YhCkW+d9cY-+kRFB3yRocDZRnBT=BtUw@mail.gmail.com>
Subject: Re: [PATCH v8 01/22] PCI, acpiphp: Add is_hotplug_bridge detection
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:45 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> +     list_for_each_entry(func, &slot->funcs, sibling) {
>> +             if (PCI_FUNC(dev->devfn) == func->function) {
>> +                     /* check if this bridge has ejectable slots */
>> +                     if ((detect_ejectable_slots(func->handle) > 0))
>> +                             dev->is_hotplug_bridge = 1;
>> +                     break;
>
> Hi Yinghai,
>    Need to put the "break" in parentheses of "if"? If the first func which device number == dev->devfn has't ejectable slot,
> don't check the rest funcs whether have ejectable slots?

no, we should break when PCI_FUNC(dev->devfn) == func->function

that iteration is for find the func for dev.

Thanks

Yinghai
