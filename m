Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966314Ab3E2OrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:47:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33954 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966175Ab3E2OrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:47:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAB9dFdunPQo5a9bgwFvaZ4++4Zm1HEaQ8VEK7pmKuwc7+DTv6g@mail.gmail.com>
References: <CAB9dFdunPQo5a9bgwFvaZ4++4Zm1HEaQ8VEK7pmKuwc7+DTv6g@mail.gmail.com>
Date: Wed, 29 May 2013 10:47:00 -0400
Message-ID: <CAB9dFdvjbQxE+G-ME044OcNcc5GRXMXzp+qiNXg5ehmL+RtfQA@mail.gmail.com>
Subject: Re: Reboot problem with nouveau - bisected
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 2:14 PM, Marc Dionne <marc.c.dionne@gmail.com> wrote:
> My machine has been getting stuck when rebooting during the current
> 3.9 cycle, and yesterday I took the time to bisect the problem to this
> commit:
>
> 32256c87ead3edec86bed5023a0ff96a6d907931:  drm/nouveau/fifo/nvc0:
> improve interrupt handler somewhat
>
>     Logs extra info for interrupts that have a sub-status register, and
>     handles the "special" ack from INTR bit 31.
>
>     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
>
> The symptom when rebooting is that the console starts spitting out a
> continuous stream of identical messages like this (transcribed by
> hand):
>
>     nouveau W[   PFIFO][0000:03:00.0] INTR 0x01000000: 0x00000005
>
> The system is then unresponsive until it is reset.  Just commenting
> out the corresponding nv_warn() in
> drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c is enough to allow the
> system to reboot normally.
>
> Video card in this system is (from lspci -v):
>
> 03:00.0 VGA compatible controller: NVIDIA Corporation GF119 [GeForce
> GT 520] (rev a1) (prog-if 00 [VGA controller])
>     Subsystem: Micro-Star International Co., Ltd. Device 2630
>     Flags: bus master, fast devsel, latency 0, IRQ 16
>     Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
>     Memory at d8000000 (64-bit, prefetchable) [size=128M]
>     Memory at d6000000 (64-bit, prefetchable) [size=32M]
>     I/O ports at bc00 [size=128]
>     Expansion ROM at fbb80000 [disabled] [size=512K]
>     Capabilities: <access denied>
>     Kernel driver in use: nouveau
>
> Marc

Ping..

Any ideas on this one?  This machine still needs a hard reset to
reboot as of 3.10-rc3, with the same symptoms as described above.

Thanks,
Marc
