Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaBHT4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:56:33 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:40347 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaBHT4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:56:32 -0500
Message-ID: <52F68BEF.5030305@msgid.tls.msk.ru>
Date: Sat, 08 Feb 2014 23:56:31 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: screen goes blank when loading gma500_gfx (atom D2500)
X-Enigmail-Version: 1.5.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Today I rebooted my router into a new kernel and noticed that
the screen goes blank after booting the system (initial bootup
messages are visible).  After some debugging it turns out that
the screen goes blank when loading gma500_gfx module.

This is an intel D2500CC motherboard with Atom D5200 built-in,
with a monitor connected to a VGA port, the following vga device
is reported by lspci:

00:02.0 VGA compatible controller: Intel Corporation Atom Processor D2xxx/N2xxx Integrated Graphics Controller (rev 09)

Here are the dmesg output after loading gma500_gfx:

[  176.427071] Linux agpgart interface v0.103
[  176.452914] [drm] Initialized drm 1.1.0 20060810
[  176.476037] gma500 0000:00:02.0: setting latency timer to 64
[  176.476216] gma500 0000:00:02.0: irq 50 for MSI/MSI-X
[  176.491675] acpi device:29: registered as cooling_device2
[  176.492041] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[  176.492169] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input11
[  176.492357] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  176.492396] [drm] No driver support for vblank timestamp query.
[  176.607485] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[  176.607531] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[  176.806078] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0

which does not look bad or suspicious to me.

fbcon is loaded so it isn't an issue.

I tried 3.10 kernel initially (the above messages are from it), next
I tried 3.13 kernel too, and that one behaves exactly the same.

As far as I remember, this system never worked with graphics well.
Previous kernel (from which I updated) was 3.2 which had no
gma500 module (local build).

What are the steps to debug this further?

Thanks,

/mjt
