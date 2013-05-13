Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3EMVRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:17:10 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:39775 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3EMVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
References: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
Date: Mon, 13 May 2013 18:17:06 -0300
Message-ID: <CACo8zOceMMJQPXNLM3JL_GMQh8wNVNDkSC5eBaZf3a=--9JGqA@mail.gmail.com>
Subject: Re: [PATCH] HID: input: return ENODATA if reading battery attrs fails
From: Daniel Nicoletti <dantti12@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/13 David Herrmann <dh.herrmann@gmail.com>:
> Anyway, I'd still like to see this patch applied so we have this annoying
> bug fixed. I'd be willing to change the power_supply core, too, if one of the
> maintainers agrees on the design (David? Anton?).
>
> And, @Daniel, can you check whether this actually fixes the bug? I don't own
> a device that reports battery-information, but it at least fixes the same bug
> for the hid-wiimote driver (tested by me).

Yes, it does fixes the bug. Now udevadm properly show add and remove events
and upower happily get's them.
But there is around  15 seconds block on the bluetooth stack, in other words
when connecting a device it seems to probe the device which blocks till
a timeout, and while that timeout doesn't finish other bluetooth
devices are also
blocked. It seems the devices aren't able to be probed so soon, possibly
because bluetooth didn't finished setting them up. Looking at udevadm output
I clearly see that it locks for around 3 times.
My kernel knowledge is rather limited but if you can give me tips or patches to
test I really want to see this code finally working properly, and sorry for
not realizing when I sent it that it had this issue...

--
Daniel Nicoletti

KDE Developer - http://dantti.wordpress.com
