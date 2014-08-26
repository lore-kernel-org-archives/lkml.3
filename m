Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaHZWr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:47:58 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:38418 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaHZWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1408261323510.1434-100000@iolanthe.rowland.org>
References: <CA+eFSM0N_DQrfxiAjBdXy=cirONv03K+bRYCAcgAwtzZ=OxybQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1408261323510.1434-100000@iolanthe.rowland.org>
Date: Wed, 27 Aug 2014 06:47:55 +0800
Message-ID: <CA+eFSM25V2_kKT7EBfPmahTknQu3jMS3+4PC_Af6C+1eHrFhWg@mail.gmail.com>
Subject: Re: About the reboot hang issue with EHCI driver on the Baytrail platform
From: Gavin Guo <gavin.guo@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>, YK <yk@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Aug 27, 2014 at 1:26 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 27 Aug 2014, Gavin Guo wrote:
>
>> >>  And IIRC, there is only one host controller within
>> >> EHCI and XHCI can be enabled in the Baytrail platform. I'm also trying
>> >> to find out the kernel parameters to disable the EHCI driver, but
>> >> currently there is no available one.
>> >
>> > It's not a kernel parameter.  You can blacklist the ehci-pci and
>> > ehci-hcd modules in /etc/modprobe.d/local.conf.
>> >
>> > Or you can turn off CONFIG_USB_EHCI_HCD in your .config and build a
>> > kernel with no EHCI support at all.
>>
>> Thanks for your response, I'm sorry that I didn't describe the
>> question clearly. Because the EHCI support is built-in with Ubuntu
>> kernel. I tried to find a way to disable that. Unfortunately, I only
>> found "nousb" can disable it. But it will disable all the USB
>> subsystem. Don't know if there is any chance to disable EHCI only.
>
> I see.  No, there isn't any way to disable EHCI support at boot time if
> it is built into the kernel.  The best you can do is use the sysfs
> "unbind" attribute, and that may not always be good enough for what you
> want.
>
> Still, why not use the BIOS setting to disable EHCI?

It's hardware enablement policy. By default, we can't change the BIOS
setting to make the bug disappear until we find out the bug is due to
BIOS's bug. Add kernel parameters is the temporary solution for the
platform can ship. And if the bug is from kernel, we need to send
patches to upstream and pull back to Ubuntu kernel or send to Ubuntu
Kernel directly if it's a trivial solution like adding device id.
However, as you said, in this case about the bug the root may be from
BIOS code. So, we can coordinate with the OEM BIOS team to modify the
default BIOS setting.

>
> Alan Stern
>

Gavin Guo
