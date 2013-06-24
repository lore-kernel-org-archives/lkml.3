Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3FXEeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:34:11 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58055 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3FXEeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <5632059.07cB6QdEcB@vostro.rjw.lan>
References: <2737587.I0nULev1kj@vostro.rjw.lan>
	<1528326.6SFofebmNT@vostro.rjw.lan>
	<CAE9FiQUJh-u-yimuGpFiOO_-L7=+V-57W0Tn+cgR3ru=PQ+xvw@mail.gmail.com>
	<5632059.07cB6QdEcB@vostro.rjw.lan>
Date: Sun, 23 Jun 2013 21:34:09 -0700
X-Google-Sender-Auth: 5RXf1HsxdKS6BMdi9f8mO2FJHXk
Message-ID: <CAE9FiQVATSK+apf0qmQPuf7SQuEuXx6Wm1GtdKuakMGsfZ8c9A@mail.gmail.com>
Subject: Re: [Update][PATCH 3/3] ACPI / dock / PCI: Synchronous handling of
 dock events for PCI devices
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <liuj97@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 5:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, June 23, 2013 04:04:52 PM Yinghai Lu wrote:
>> On Sun, Jun 23, 2013 at 2:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...
>> > Ah, I overlooked the fact that each dock station is on its own dependent_list
>> > and can also be on another dock station's dependent_list.  I'm not sure if that
>> > makes sense, but let's not break the backwards compatibility here.
>>
>> wonder if dock_release_hotplug with second dock_station and dd will
>> have problem.
>>
>> as first one dock_station/dd, could have hp_context release already,
>> then second one could all release(context) again....
>>
>> so looks like dock_release_hotplug should go over dock_station/dd list
>> to clear hp_context in other dock_station/... if they are the same?
>
> I'm not sure what you mean.  They are different dependent_device objects
> and each of them has its own context pointer, although they both will point to
> the same thing.
>
> Both "init" and "release" will be called for each of them individually which
> for for acpiphp (which is the only user of that ATM) actually means "get" and
> "put", so it should be OK.

yes, then hp_context can never be  the same, just the acpi handle is the same.

Acked-by: Yinghai Lu <yinghai@kernel.org>

BTW, thank you very much for the whole acpi scan rework.

Yinghai
