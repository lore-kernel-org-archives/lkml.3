Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaFCTAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:00:32 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45623 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaFCTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
References: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
Date: Tue, 3 Jun 2014 14:00:29 -0500
Message-ID: <CADYTM3aX-X4QbecitTD9EOFyoLeiqSnJum7AFnaF5UEV3FBmpQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Add support for SW babble Control
From: Bin Liu <binmlist@gmail.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        zonque@gmail.com, b-liu@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George,

On Mon, May 26, 2014 at 4:20 AM, George Cherian <george.cherian@ti.com> wrote:
> Series add support for SW babble control logic found in
> new silicon versions of AM335x. Runtime differentiation of
> silicon version is done by checking the BABBLE_CTL register.
> For newer silicon the register default value read is 0x4 and
> for older versions its 0x0.

Please add 'Tested-by: Bin Liu <b-liu@ti.com>' to this series.

Thanks,
-Bin.

>
> Patch 1 -> Handle Babble only if MUSB is in HOST mode
> Patch 2 -> Convert recover work to delayed work.
> Patch 3 -> usb_phy_vbus_(off/_on) are NOPs for am335x PHY
>            so use usb_phy(_shutdown/_init) in musb_platform_reset()
> Patch 4 -> Add return value for musb_platform_reset() in prepration
>            to support SW babble_ctrl
> Patch 5 -> Add and Enable sw babble control for newer silicon
>
> v5 -> v6 : Squash patch 5 and 6 form v5 to avoid build warnings.
>
> v4 -> v5 : Added a debug print before resetting MUSB.
>            changed a musb_readb to dsps_readb introduced in Patch#5 of v4.
>
> v3 -> v4 : Fixes an issue in gagdet mode - BUS RESET should not
>            be handled as a BABBLE. Added a check for the same.(Patch #1)
>            Enable sw babble control properly (Patch #6)
>
> v2 -> v3 : Modify musb_platform_reset() to return zero on success.
>
>
>
> George Cherian (5):
>   usb: musb: core: Handle Babble condition only in HOST mode
>   usb: musb: core: Convert babble recover work to delayed work
>   usb: musb: dsps: Call usb_phy(_shutdown/_init) during
>     musb_platform_reset()
>   usb: musb: core: Convert the musb_platform_reset to have a return
>     value.
>   usb: musb: dsps: Add the sw_babble_control() and Enable for newer
>     silicon
>
>  drivers/usb/musb/musb_core.c | 27 ++++++++------
>  drivers/usb/musb/musb_core.h | 12 +++---
>  drivers/usb/musb/musb_dsps.c | 88 ++++++++++++++++++++++++++++++++++++++++++--
>  drivers/usb/musb/musb_regs.h |  7 ++++
>  4 files changed, 114 insertions(+), 20 deletions(-)
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
