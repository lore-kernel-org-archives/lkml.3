Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab3CRHPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 03:15:18 -0400
Received: from www17.your-server.de ([213.133.104.17]:58112 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3CRHPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 03:15:16 -0400
Date: Mon, 18 Mar 2013 08:14:48 +0100
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor
 interrupt responses)
Message-ID: <3mh5gd58po5ybltccyfh2htu.1363590888245@email.android.com>
From: Thomas Meyer <thomas@m3y3r.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        " Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2I7FfUJ015220

My laptop is an Acer 1810T. I see this error message each boot.

Kind regards
Thomas

Jiri Kosina <jkosina@suse.cz> schrieb:

>On Fri, 15 Mar 2013, Jiri Kosina wrote:
>
>> > I have the same problem on my Lenovo T500. I think the graphics card is
>> > involved.
>> > 
>> > This laptop has "hybrid graphics" - one Intel GMA 4500MHD and one ATI
>> > Mobility Radeon HD 3650. When I boot with the Intel card, I get "irq 16:
>> > nobody cared" during boot, not when I boot with the ATI card.
>> 
>> Confirming this. After a lot of hassle, I have bisected this reliably to
>> 
>> 	commit 28c70f162a315bdcfbe0bf940a740ef8bfb918d6
>> 	Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> 	Date:   Sat Dec 1 13:53:45 2012 +0100
>> 
>> 	    drm/i915: use the gmbus irq for waits
>> 
>> Adding Daniel, Imre and Daniel to CC while I will try to figure out what's 
>> happening in parallel.
>> 
>> Attaching dmesg.txt from the machine with 28c70f162a as head, with 
>> drm.debug=0xe.
>
>Just a datapoint -- I have put a trivial debugging patch in place, and it 
>reveals that "nobody cared" for irq 16 happens long after last
>
>	I915_WRITE(GMBUS4 + reg_offset, 0);
>
>has been performed in gmbus_wait_hw_status(). On the other hand, if I 
>comment out both GMBUS4 register offset writes in gmbus_wait_hw_status(), 
>then it of course falls back to GPIO bit-banging, but the "nobody cared" 
>for irq 16 is gone. 
>
>So it seems like something gets severely confused by the I915_WRITE to 
>GMBUS4 + reg_offset. So far this seems to have been reported solely on 
>Lenovos as far as I can see (although a completely different types), so it 
>might be some platform-specific quirk?
>
>Honestly, I still don't understand how all the GMBUS stuff relates to IRQ 
>16 at all. 
>
>-- 
>Jiri Kosina
>SUSE Labs
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
