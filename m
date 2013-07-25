Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3GYFjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 01:39:03 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41750 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3GYFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 01:38:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com>
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com>
 <51F07489.7010404@gmail.com> <CAD6i1fJO3geZ0vkHLsJEd+KedHkpC1OZVTJJskU2RAAKYBhhJQ@mail.gmail.com>
From: Prashant Shah <pshah.mumbai@gmail.com>
Date: Thu, 25 Jul 2013 11:08:37 +0530
Message-ID: <CAD6i1f+NYu7rcQwF-TXk4+OdjPNZwMKxxjJ9YA_+v9B6uPYq+g@mail.gmail.com>
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
To: Ryan Mallon <rmallon@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mwhitehe@redhat.com,
        kernel-mentors@selenic.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 25, 2013 at 10:49 AM, Prashant Shah <pshah.mumbai@gmail.com> wrote:
> Hi,
>
>> You should also remove the definition of DRV_NAME, since it is no longer
>> used. The changelog should probably mention that this will change the
>> interrupt name (which appears in /proc/interrupts for example) from "wd"
>> to "eth%d".
>>

I was going through the code. The apne driver apne.c in the same
folder is using DRV_NAME in request_region()

> if (!request_region(IOBASE, 0x20, DRV_NAME)) {

I can change the wd.c request_region() code to use DRV_NAME. Currently
it is using a string constant.

> r = request_region(base_addr, WD_IO_EXTENT, "wd-probe");

This will make it more consistent. Please suggest which change is more
preferable.

@Matthew, following drivers are not using dev->name in request_irq()
axnet_cs.c
mac8390.c
hydra.c
ne-h8300.c
apne.c
stnic.c
zorro8390.c

Regards.
