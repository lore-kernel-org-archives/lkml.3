Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaLRWEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:04:20 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42660 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRWET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:04:19 -0500
Date: Fri, 19 Dec 2014 00:04:16 +0200
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: "Rogelio M. Serrano Jr." <rogelios664@gmail.com>
Cc: linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: atomic_inc and spin_lock_irq
Message-ID: <20141219000416.689f3ab7@mdontu-l.dsd.ro>
In-Reply-To: <CAB_-8bLk-HVWB6Mmt=rjDguou1kbGQ9c7o5nQxV3zAg+Txf7GQ@mail.gmail.com>
References: <CAB_-8bLk-HVWB6Mmt=rjDguou1kbGQ9c7o5nQxV3zAg+Txf7GQ@mail.gmail.com>
Organization: Home
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014 21:07:46 +0000 Rogelio M. Serrano Jr. wrote:
> whats the difference between:
> 
> atomic_inc(&port->count);

It is intended to atomically increment a variable of a standard size
(int/long). See [1] for more information.

> and
> 
> spin_lock_irq(&port->lock);
> ++port->count;
> spin_unlock_irq(&port->lock);

These are intended to be used when larger changes are to be made in an
atomic fashion (not just increments). See [2] for details and [3] for
an example.

[1] https://en.wikipedia.org/wiki/Fetch-and-add
[2] http://lxr.free-electrons.com/source/include/linux/spinlock_api_smp.h#L104
[3] http://lxr.free-electrons.com/source/arch/x86/mm/mmio-mod.c#L265

-- 
Mihai Donțu
