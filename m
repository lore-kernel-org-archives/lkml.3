Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3KGON5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:13:57 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46875 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3KGONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131103184832.GD5763@orbis-terrarum.net>
References: <20131103184832.GD5763@orbis-terrarum.net>
From: Veaceslav Falico <veaceslav@falico.eu>
Date: Thu, 7 Nov 2013 15:13:33 +0100
Message-ID: <CAE3RKNmuTNEJRy3E67E7vrC5+6E_59GH=N2wOzenRs=VG2mwRw@mail.gmail.com>
Subject: Re: KMS/radeon regression: failure to set modes on CEDAR & TAHITI;
 v3.11 vs 3.12-rc5/rc7
To: Linux-Kernel <linux-kernel@vger.kernel.org>, robbat2@gentoo.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 3, 2013 at 7:48 PM, Robin H. Johnson <robbat2@gentoo.org> wrote:
> (Please CC, not sub'd to LKML; Was originally posted to
> xorg-driver-ati@lists.x.org, dri-devel@lists.freedesktop.org, but I
> think the dmesg attachments got it eaten as spam).
>
> I apologize for not sending this sooner, but I wanted to be really sure that I
> wasn't introducing the bug elsewhere, and I was lacking time to even narrow it
> down this far.
>
> TL;DR:
> 3.11 kernel does proper modeset for dual 1920x1200 outputs
> 3.12-rc5/rc7 kernel fails to do proper modeset, blank screen after radeon loaded
>
> Symptoms:
> - With implicit video= modes, after the radeon module loads, both monitors just go blank.
>   Kernel message: radeon 0000:01:00.0: No connectors reported connected with modes
>   X does not visible start, screen stays black.
> - With explicit video= modes, after the radeon module loads, both monitors during the
>   kernel boot display very garbled output; after X starts, they are in
>   1024x768, with no higher modes listed.
>
> Attached are four dmesg [1] runs, on v3.11 vs v3.12-rc7, with both explicit
> video parameters, and implicit video parameters; as well as drm.debug=0x06 in
> ALL cases; as well as two xorg logs (both from the implicit variants).
>
> testcase 1 (implicit): modeset=1 fbcon=map:0 drm.debug=0x06
> testcase 2 (explicit): video=HDMI-A-1:1920x1200e video=DVI-I-1:1920x1200e modeset=1 fbcon=map:0 drm.debug=0x06
>
> I have produced this bug with three different cards:
> CEDAR 0x1002:0x68F9 0x1043:0x03CA (used for all these bug reports)
> CEDAR 0x1002:0x68F9 0x174B:0xE164
> TAHITI 0x1002:0x6798 0x1458:0x2261 (7970, borrowed before)
>
> This happened as far back as 3.12-rc5 for me, but I didn't debug more at the
> time.
>
> Monitors:
> (Left) Dell U2410 via DVI
> (Center) Dell U2413 via HDMI
> (Right is another U2410, not connected at all)
>
> Userspace:
> xorg-server-1.14.3
> mesa-9.2.1
> xf86-video-ati-7.2.0
>
> I think the error might be and off by one in the connector probing, based on
> this:
>
> 3.11:
> [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
> [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] probed modes :
>
> 3.12-rc7:
> [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:16:HDMI-A-1]
> [drm:radeon_process_i2c_ch], hw_i2c error
> [drm:radeon_atombios_connected_scratch_regs], DFP1 disconnected
> [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:16:HDMI-A-1] disconnected
>
> [1] yes I know about the bonding error, that's a separate issue I need
> to mail to LKML/netdev.

Bonding issue should be fixed with
b32418705107265dfca5edfe2b547643e53a732e ("bonding: RCUify
bond_set_rx_mode()") in net-next.

>
> --
> Robin Hugh Johnson
> Gentoo Linux: Developer, Trustee & Infrastructure Lead
> E-Mail     : robbat2@gentoo.org
> GnuPG FP   : 11ACBA4F 4778E3F6 E4EDF38E B27B944E 34884E85



-- 
Best regards,
Veaceslav Falico
