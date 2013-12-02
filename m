Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3LBQiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:38:24 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39828 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3LBQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:38:20 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manuel Krause <manuelkrause@netscape.net>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>
Subject: Re: 3.12.x looses serial mouse over hibernate + resume
Date: Mon, 02 Dec 2013 08:38:16 -0800
Message-ID: <19253701.sgP3OieFUq@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.11.3 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <529CB07C.2040609@netscape.net>
References: <52951E69.7090602@netscape.net> <529B591F.1020909@hurleysoftware.com> <529CB07C.2040609@netscape.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 05:08:28 PM Manuel Krause wrote:
> On 2013-12-01 16:43, Peter Hurley wrote:
> > [ +cc Dmitry Torokhov, Greg Kroah-Hartman, linux-input,
> > linux-serial ]
> > 
> > On 11/26/2013 05:19 PM, Manuel Krause wrote:
> >> Since kernel 3.12.0 I have a problem with hibernate+resume
> >> not reactivating my serial mouse (trackball) with my HP notebook.
> >> Kernels 3.11.0 til 9 don't show this behaviour.
> >> 
> >> Machine:           HP Notebook with Core2Duo CPU (Penryn)
> >> Distro:            openSUSE 12.3, 64bit, continuously updated
> >> Desktop:           KDE 4.11.3
> >> MESA & drm & Xorg: most recent ones from:
> >> 
> >> http://download.opensuse.org/repositories/home:/pontostroy:/X11/openSUSE_
> >> 12.3/x86_64/
> >> 
> >> Current kernel:    3.12.1 vanilla from openSUSE repos, with
> >> 
> >>                     -ck1 and BFQ patches
> >> 
> >> The Logitech Trackman Marble FX is a PS/2 device and connected
> >> via an original Logitech
> >> PS/2-COM-port adapter and manually configured via my xorg.conf.
> >> 
> >> At first, I blamed the -ck1 patches from Con Kolivas for this
> >> behaviour that I use in
> >> addition  to the BFQ patches, what has showed up as not right:
> >> This happens with the
> >> normal vanilla kernel
> >> schedulers for CPU and disk I/O, too.
> >> 
> >> By coincidence I found a weird(!) way to reactivate the serial
> >> mouse:
> >> (1) call Hibernate (suspend-to-disk) from KDE desktop as normal
> >> (2) resume --> the PS/2 touchpad is working, the serial
> >> trackball NOT
> >> (3) call suspend-to-RAM (Sleep) from KDE, serial trackball
> >> still dead
> >> (4) execute `setserial -a /dev/ttyS0` in a konsole window or a
> >> tty* console
> >> (5) ==> serial trackball is back with all configuration from
> >> xorg.conf
> >> 
> >> It's fully reproducible over multiple hibernations. This also
> >> happens when calling
> >> `pm-hibernate` (to-disk) and `pm-suspend` (to-RAM) and the
> >> setserial from a root shell
> >> in KDE or any tty*.
> >> 
> >> Please, _always_CC_me_ -- as I'm not on the kernel mailing list.
> > 
> > Manuel,
> > 
> > Please attach complete dmesgs (zipped, if necessary) of a
> > suspend/resume cycle
> > on a vanilla 3.12.x (where resume fails) _and_ a vanilla 3.11.x
> > (where resume succeeds).
> > 
> > For the test configurations, please do not apply patches.
> > 
> > Regards,
> > Peter Hurley
> 
> Thank you very much for your reply!
> Attached you'll find a zip file with the two edited dmesg logs of
> plain vanilla kernel runs.
> 
> I have to add, that the resumes _do_ succeed in both cases, only
> the serial mouse doesn't get activated after hibernate in 3.12.x
> automatically. Just scan for and compare the lines indicating
> "serial 00:08: disabled" or "serial 00:08: activated". In 3.12.x
> the activation doesn't happen after hibernate, but after
> suspend-to-ram (sleep). That only after STR and not before a
> setserial gets my mouse back... a miracle. ;-)

I do not see

> [  206.577370] serial 00:08: activated

in the restore from hibernation log of 3.12 which shoudl come from PNP
layer.

[dtor@dtor-d630 work]$ git log --oneline v3.11..v3.12 -- drivers/pnp/ 
729377d pnp: change pnp bus pm_ops to invoke pnp driver dev_pm_ops if specified
ce63e18 Merge branch 'pnp'
8ad928d ACPI / PM: Use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3 everywhere
eaf140b PNP: convert PNP driver bus legacy pm_ops to dev_pm_ops

I'd start looking into these commits.

Thanks.

-- 
Dmitry
