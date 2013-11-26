Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3KZW1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:27:10 -0500
Received: from omr-d08.mx.aol.com ([205.188.109.207]:54879 "EHLO
	omr-d08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3KZW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:27:04 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2013 17:27:04 EST
Message-ID: <52951E69.7090602@netscape.net>
Date: Tue, 26 Nov 2013 23:19:21 +0100
From: Manuel Krause <manuelkrause@netscape.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.12.x looses serial mouse over hibernate + resume
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
x-aol-global-disposition: G
x-aol-sid: 3039ac1d338252951e743190
X-AOL-IP: 93.218.247.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kernel 3.12.0 I have a problem with hibernate+resume not 
reactivating my serial mouse (trackball) with my HP notebook.
Kernels 3.11.0 til 9 don't show this behaviour.

Machine:           HP Notebook with Core2Duo CPU (Penryn)
Distro:            openSUSE 12.3, 64bit, continuously updated
Desktop:           KDE 4.11.3
MESA & drm & Xorg: most recent ones from:
 
http://download.opensuse.org/repositories/home:/pontostroy:/X11/openSUSE_12.3/x86_64/
Current kernel:    3.12.1 vanilla from openSUSE repos, with
                    -ck1 and BFQ patches

The Logitech Trackman Marble FX is a PS/2 device and connected 
via an original Logitech PS/2-COM-port adapter and manually 
configured via my xorg.conf.

At first, I blamed the -ck1 patches from Con Kolivas for this 
behaviour that I use in addition to the BFQ patches, what has 
showed up as not right: This happens with the normal vanilla 
kernel schedulers for CPU and disk I/O, too.

By coincidence I found a weird(!) way to reactivate the serial mouse:
(1) call Hibernate (suspend-to-disk) from KDE desktop as normal
(2) resume --> the PS/2 touchpad is working, the serial trackball NOT
(3) call suspend-to-RAM (Sleep) from KDE, serial trackball still dead
(4) execute `setserial -a /dev/ttyS0` in a konsole window or a 
tty* console
(5) ==> serial trackball is back with all configuration from 
xorg.conf

It's fully reproducible over multiple hibernations. This also 
happens when calling `pm-hibernate` (to-disk) and `pm-suspend` 
(to-RAM) and the setserial from a root shell in KDE or any tty*.

Please, _always_CC_me_ -- as I'm not on the kernel mailing list.

Thank you in advance and best regards,
Manuel Krause
