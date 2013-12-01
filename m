Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3LAPn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 10:43:58 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46877 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865Ab3LAPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 10:43:32 -0500
Message-ID: <529B591F.1020909@hurleysoftware.com>
Date: Sun, 01 Dec 2013 10:43:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Manuel Krause <manuelkrause@netscape.net>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        "linux-serial" <linux-serial@vger.kernel.org>
Subject: Re: 3.12.x looses serial mouse over hibernate + resume
References: <52951E69.7090602@netscape.net>
In-Reply-To: <52951E69.7090602@netscape.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Dmitry Torokhov, Greg Kroah-Hartman, linux-input, linux-serial ]

On 11/26/2013 05:19 PM, Manuel Krause wrote:
> Since kernel 3.12.0 I have a problem with hibernate+resume
> not reactivating my serial mouse (trackball) with my HP notebook.
> Kernels 3.11.0 til 9 don't show this behaviour.
>
> Machine:           HP Notebook with Core2Duo CPU (Penryn)
> Distro:            openSUSE 12.3, 64bit, continuously updated
> Desktop:           KDE 4.11.3
> MESA & drm & Xorg: most recent ones from:
>
> http://download.opensuse.org/repositories/home:/pontostroy:/X11/openSUSE_12.3/x86_64/
> Current kernel:    3.12.1 vanilla from openSUSE repos, with
>                     -ck1 and BFQ patches
>
> The Logitech Trackman Marble FX is a PS/2 device and connected via an original Logitech
> PS/2-COM-port adapter and manually configured via my xorg.conf.
>
> At first, I blamed the -ck1 patches from Con Kolivas for this behaviour that I use in
> addition  to the BFQ patches, what has showed up as not right: This happens with the
> normal vanilla kernel
> schedulers for CPU and disk I/O, too.
>
> By coincidence I found a weird(!) way to reactivate the serial mouse:
> (1) call Hibernate (suspend-to-disk) from KDE desktop as normal
> (2) resume --> the PS/2 touchpad is working, the serial trackball NOT
> (3) call suspend-to-RAM (Sleep) from KDE, serial trackball still dead
> (4) execute `setserial -a /dev/ttyS0` in a konsole window or a tty* console
> (5) ==> serial trackball is back with all configuration from xorg.conf
>
> It's fully reproducible over multiple hibernations. This also happens when calling
> `pm-hibernate` (to-disk) and `pm-suspend` (to-RAM) and the setserial from a root shell
> in KDE or any tty*.
>
> Please, _always_CC_me_ -- as I'm not on the kernel mailing list.

Manuel,

Please attach complete dmesgs (zipped, if necessary) of a suspend/resume cycle
on a vanilla 3.12.x (where resume fails) _and_ a vanilla 3.11.x (where resume succeeds).

For the test configurations, please do not apply patches.

Regards,
Peter Hurley

