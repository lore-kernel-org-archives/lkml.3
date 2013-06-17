Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3FQD15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:27:57 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:65341 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab3FQD14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <51BDF705.5090904@gmail.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
	<CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
	<51BDF705.5090904@gmail.com>
Date: Mon, 17 Jun 2013 09:27:55 +0600
Message-ID: <CAN_LGv0yXhQi82ck3mvTbwuZv2dhnYB7Xnk9P4=5XVoAaAAeZQ@mail.gmail.com>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/16 Jiang Liu <liuj97@gmail.com>:
> On 06/15/2013 02:42 PM, Alexander E. Patrakov wrote:

>> Both cases work, and exhibit similar backtraces in dmesg. So I am
>> attaching a dmesg only from the first testcase. Please look for "INFO:
>> trying to register non-static key" and for "*ERROR* Memory manager not
>> clean. Delaying takedown". I understand that the second trace is
>> unrelated to this patchset, but would like you to fix the first.
> Hi Alexander,
>         Great thanks for your testing!
>         I have investigated the first issue but still have no idea about it.
> According to source code, everything should be OK.
> The r8169 driver has invoked INIT_WORK(&tp->wk.work, rtl_task) to
> initialize the work item, so it shouldn't trigger the warning.
> Have you found this issue in other test cases?

I am not 100% sure that the static key backtrace is the same in all
cases. However, I do remember that it does appear both in the
non-hotplug and hotplug cases.

I will retest this after work, i.e. in ~12 hours.

-- 
Alexander E. Patrakov
