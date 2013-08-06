Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3HFIUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:20:20 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57431 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3HFIUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:20:17 -0400
Message-ID: <5200B1BD.7030307@gmail.com>
Date: Tue, 06 Aug 2013 10:20:13 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?B?WmJpZ25pZXcgSsSZZHJ6ZWpld3NraS1Tem1law==?= 
	<zbyszek@in.waw.pl>,
        systemd-devel@lists.freedesktop.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        linux-hotplug@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] Change CONFIG_FW_LOADER_USER_HELPER to default n and
 don't select it
References: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com> <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net>
In-Reply-To: <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 05-08-13 18:29, Andy Lutomirski schreef:
> The systemd commit below can delay firmware loading by multiple
> minutes if CONFIG_FW_LOADER_USER_HELPER=y.  Unfortunately no one
> noticed that the systemd-udev change would break new kernels as well
> as old kernels.
>
> Since the kernel apparently can't count on reasonable userspace
> support, turn this thing off by default.
>
> commit a3bd8447be4ea2ce230eb8ae0e815c04d85fa15a
> Author: Tom Gundersen <teg@jklm.no>
> Date:   Mon Mar 18 15:12:18 2013 +0100
>
>     udev: make firmware loading optional and disable by default
>
>     Distros that whish to support old kernels should set
>       --with-firmware-dirs="/usr/lib/firmware/updates:/usr/lib/firmware"
>     to retain the old behaviour.
>
methinks this patch should be reverted then, or a stub should be added to udev to always fail firmware loading so timeouts don't occur.

~Maarten
