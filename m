Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3FPReH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:34:07 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36154 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3FPReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:34:05 -0400
Message-ID: <51BDF705.5090904@gmail.com>
Date: Mon, 17 Jun 2013 01:33:57 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
In-Reply-To: <CAN_LGv1itN=ADE-3LNCoBJFXmpWZffhQb6NQuoBzvONkX3brug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 02:42 PM, Alexander E. Patrakov wrote:
> 2013/6/15 Jiang Liu <jiang.liu@huawei.com>:
>> Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
>> dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
>> four bugs related to Sony VAIO VPCZ23A4R dock support.
>> 1) can't correctly detect hotplug slot for dock state
>> 2) resource leak on undocking
>> 3) resource allocation failure for dock devices
>> 4) one bug in intel_snd_hda driver
> 5) one or two bugs in radeon driver
> 
> As for the subject - only a hotplug-related part of bug 59581 is fixed.
> 
>> Hi Alexander, could you please help to test the whole patchset?
>> Really get sleepy, it's already 3 oclock now, so please forgive me
>> if there any stupid mistakes.
> 
> I have tested this patchset on top of 3.10-rc5 using the following two
> testcases.
> 
> 1. Boot docked with radeon blacklisted. Switch to text-based virtual
> console, undock, dock, modprobe radeon, rmmod radeon, undock, dock,
> modprobe radeon again. Tested in this sequence because Alex Deucher
> told me in bug 59681 to rmmod radeon before undocking.
> 
> 2. Boot undocked, with radeon not blacklisted. Stay in X. Dock,
> undock, dock, undock, dock.
> 
> Both cases work, and exhibit similar backtraces in dmesg. So I am
> attaching a dmesg only from the first testcase. Please look for "INFO:
> trying to register non-static key" and for "*ERROR* Memory manager not
> clean. Delaying takedown". I understand that the second trace is
> unrelated to this patchset, but would like you to fix the first.
Hi Alexander,
	Great thanks for your testing!
	I have investigated the first issue but still have no idea about it.
According to source code, everything should be OK.
The r8169 driver has invoked INIT_WORK(&tp->wk.work, rtl_task) to
initialize the work item, so it shouldn't trigger the warning.
Have you found this issue in other test cases?
Regards!
Gerry

> 
> Note that the snd_hda_intel bug somehow didn't manifest itself today,
> probably because the TV that is connected to the HDMI output of the
> radeon card was off and because Xorg never really tried to use the
> card.
> 
> --
> Alexander E. Patrakov
> 

