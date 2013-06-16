Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3FPRMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:12:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32805 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3FPRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:12:08 -0400
Message-ID: <51BDF1E0.5070201@gmail.com>
Date: Mon, 17 Jun 2013 01:12:00 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <8974656.5GmDyxHW7F@vostro.rjw.lan> <18797091.iPZsNWFGi1@vostro.rjw.lan> <2139297.LeMhgEjsya@vostro.rjw.lan>
In-Reply-To: <2139297.LeMhgEjsya@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 06:54 AM, Rafael J. Wysocki wrote:
> On Saturday, June 15, 2013 11:20:40 PM Rafael J. Wysocki wrote:
>> On Saturday, June 15, 2013 10:17:42 PM Rafael J. Wysocki wrote:
> 
> [...]
> 
>>
>> Which sysfs interfaces do you mean, by the way?
>>
>> If you mean "eject", then it takes acpi_scan_lock and hotplug_dock_devices()
>> should always be run under acpi_scan_lock too.  It isn't at the moment,
>> because write_undock() doesn't take acpi_scan_lock(), but this is an obvious
>> bug (so I'm going to send a patch to fix it in a while).
>>
>> With that bug fixed, the possible race between acpi_eject_store() and
>> hotplug_dock_devices() should be prevented from happening, so perhaps we're
>> worrying about something that cannot happen?
> 
> So here's a question: What particular races are possible if we remove
> ds->hp_lock entirely without doing anything else just yet?  I mean, how to
> *trigger* them from the start to the end and not how they can possibly happen
> but never do, because there's no way they can be actually triggered?
Hi Rafael,
    I have no really platform which triggers this bug, but I may imagine
a possible platform if it's valid for explanation.
    Let's think about a laptop dock station with a thunderbolt
controller built-in. The dock station is managed by dock driver and
acpiphp driver. And the PCIe hierarchy managed by the thunderbolt
controller may be managed by dock driver and ACPIPHP driver too.
So it may trigger the issue by pressing the dock button and unplugging
thunderbolt cable concurrently.
    But after all, this is all by imagination:). We may need to find a
simple and quick solution for 3.10 and the stable trees and enhance the
solution later to avoid introducing new bugs while fixing a bug.
Regards!
Gerry
> 
> Rafael
> 
> 

