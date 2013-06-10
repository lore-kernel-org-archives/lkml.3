Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FJDwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:52:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34690 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3FJDwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:52:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51B54D51.2070505@jp.fujitsu.com>
Date: Mon, 10 Jun 2013 12:51:45 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: li guang <lig.fnst@cn.fujitsu.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH RFC v2 0/3] add cpu physically hotplug driver
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>  <5449620.11SBDUltzF@vostro.rjw.lan> <1370824567.21655.10.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1370824567.21655.10.camel@liguang.fnst.cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/06/10 9:36, li guang wrote:
> Hi, Rafael
>
> 在 2013-06-06四的 13:00 +0200，Rafael J. Wysocki写道：
>> On Thursday, June 06, 2013 09:40:32 AM liguang wrote:
>>> This patch-set try to support physically hot-plug/unplug
>>> a cpu automatically, that is:
>>> if you offline a cpu, it will automatically actually remove
>>> a cpu, and if you hot-plug a cpu, then it will online this
>>> cpu automatically.
>>
>> No and no.
>
> Hmm... are you saying cpu online/offline designed to distinguish
> with real cpu plug/unplug?
> but, what the actual usage of online/offline?
> forgive my foolish.
>
>>
>> Why do you need this?
>>
>
> e.g. for QEMU case, if hot-plug a cpu,

> we have to online a cpu manually if there's
> no user space support like udev to do it automatically.

I could not understand why you do not use udev.
Please explain in detail.

> and also, I think maybe online/offline should be naturally
> integrated with real plug/unplug process of CPU.

I could not understand this explanation too.
Why do we need it?

Thanks,
Yasuaki Ishimatsu

>
>>
>>
>>> so, offline is just like eject, but eject attribute seems not
>>> available since recent kernel(can't figure out when), with
>>> this driver, if allowed, it will trigger a eject cpu process.
>>> and for automatically online, it was said there are objections,
>>> don't know the reason, so, send this patch-set boldly.
>>>
>>> of course, this approach is for QEMU 's hotplug cpu emulation
>>> only, but not limited, if someone like to explore ec space to
>>> implment cpu hot-plug/unplug for real platform please
>>> feel free to continue.
>>>
>>> Li Guang (3)
>>> 	 drivers/platform/x86: add cpu physically hotplug driver
>>> 	 ec: add ec space notifier
>>> 	 cpu_physic_hotplug: register handler for ec space notifier
>>>
>>> drivers/acpi/ec.c                         | 32 ++++++++++++++++++++++++++++++++
>>> drivers/platform/x86/Kconfig              |  8 ++++
>>> drivers/platform/x86/Makefile             |  1 +
>>> drivers/platform/x86/cpu_physic_hotplug.c | 90 +++++++++++++++++++++++++++++
>>> include/linux/acpi.h                      |  2 ++
>>> 5 files changed, 130 insertions(+), 3 deletions(-)
>>>   create mode 100644 drivers/platform/x86/cpu_physic_hotplug.c
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


