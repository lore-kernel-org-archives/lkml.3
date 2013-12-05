Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3LEOWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:22:30 -0500
Received: from smtp.dezem.de ([46.4.88.120]:43623 "EHLO smtp.dezem.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3LEOW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:22:29 -0500
Message-ID: <52A08C22.2050900@dezem.de>
Date: Thu, 05 Dec 2013 15:22:26 +0100
From: Holger Adams <holger.adams@dezem.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 3.12.3, panic: crashes using kexec in combination with usb on
 the ARM ST SPEAr320 platform
References: <52A07A74.6050303@dezem.de>
In-Reply-To: <52A07A74.6050303@dezem.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 02:07 PM, Holger Adams wrote:
> Hey All,
>
> I hit some interesting crash with our ARM ST SPEAr320 evaluation board
> using the latest (3.12.3) vanilla kernel.

Ok, just compiled 3.13-rc2. The usb/kexec issue seems to be fixed.

Following error stays:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/irq/irqdomain.c:276 
irq_domain_associate+0x58/0x1bc()
error: hwirq 0x15 is too large for (null)
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc2 #1
[<c000ef7c>] (unwind_backtrace+0x0/0x138) from [<c000c2cc>] 
(show_stack+0x20/0x24)
[<c000c2cc>] (show_stack+0x20/0x24) from [<c03c4300>] (dump_stack+0x20/0x28)
[<c03c4300>] (dump_stack+0x20/0x28) from [<c0016bb0>] 
(warn_slowpath_common+0x78/0x98)
[<c0016bb0>] (warn_slowpath_common+0x78/0x98) from [<c0016c8c>] 
(warn_slowpath_fmt+0x40/0x48)
[<c0016c8c>] (warn_slowpath_fmt+0x40/0x48) from [<c004f044>] 
(irq_domain_associate+0x58/0x1bc)
[<c004f044>] (irq_domain_associate+0x58/0x1bc) from [<c004f2f4>] 
(irq_create_mapping+0x14c/0x1ec)
[<c004f2f4>] (irq_create_mapping+0x14c/0x1ec) from [<c004f458>] 
(irq_create_of_mapping+0xc4/0x118)
[<c004f458>] (irq_create_of_mapping+0xc4/0x118) from [<c0318668>] 
(irq_of_parse_and_map+0x34/0x3c)
[<c0318668>] (irq_of_parse_and_map+0x34/0x3c) from [<c0318698>] 
(of_irq_to_resource+0x28/0xb4)
[<c0318698>] (of_irq_to_resource+0x28/0xb4) from [<c031875c>] 
(of_irq_to_resource_table+0x38/0x58)
[<c031875c>] (of_irq_to_resource_table+0x38/0x58) from [<c0315d54>] 
(of_device_alloc+0x128/0x184)
[<c0315d54>] (of_device_alloc+0x128/0x184) from [<c0315df0>] 
(of_platform_device_create_pdata+0x40/0x98)
[<c0315df0>] (of_platform_device_create_pdata+0x40/0x98) from 
[<c03160d4>] (of_platform_bus_create+0x28c/0x370)
[<c03160d4>] (of_platform_bus_create+0x28c/0x370) from [<c0316140>] 
(of_platform_bus_create+0x2f8/0x370)
---[ end trace e4672a449c68df7b ]---
------------[ cut here ]------------

Best Regards,
Holger

-- 
Holger Adams, DeZem GmbH
phone: +49 30 3180 0730, fax: +49 30 3180 0731
