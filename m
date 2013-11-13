Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab3KMQ46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:56:58 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:34847 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3KMQ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:56:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAOpc7mHTi72OUH_sn2i+GP7rxAnKit8MH1L4-06gcYsK-81LGA@mail.gmail.com>
References: <CAOpc7mHTi72OUH_sn2i+GP7rxAnKit8MH1L4-06gcYsK-81LGA@mail.gmail.com>
Date: Wed, 13 Nov 2013 17:56:51 +0100
Message-ID: <CAMeQTsY2PcNhOmgVzK0XOs+HD1jr+JyZ+fZ5Yzj-v8yt9wmvRg@mail.gmail.com>
Subject: Re: [BUG] gma500: sleeping function called from invalid context at kernel/mutex.c:413
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 4:49 PM, Holger Schurig <holgerschurig@gmail.com> wrote:
> Kernel: 3.10.19
>
> From time to time, when I booted, I had a completely dark screen (with
> kernel command line quiet) and a non-blinking cursor. I wondered if
> that was perhaps gma500. So I turned on various debug checks. Then
> I've got the BUG from the subject.
>
> The device is a " VGA compatible controller [0300]: Intel Corporation
> System Controller Hub (SCH Poulsbo) Graphics Controller [8086:8108]
> (rev 07)".
>
> Here's relevant "dmesg" output:
>
> ...

Hi

We're calling backlight_update_status() in IRQ context which isn't allowed.

I'll add it to my todo list.

Thanks
Patrik
