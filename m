Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3K2COY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:14:24 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37024 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3K2COW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:14:22 -0500
MIME-Version: 1.0
In-Reply-To: <1385690880-32303-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1385690880-32303-1-git-send-email-chris.ruehl@gtsys.com.hk>
Date: Fri, 29 Nov 2013 00:14:20 -0200
Message-ID: <CAOMZO5DZ2AtM-6m9C54hEi60V=c95HzYaNW6YkiZjBy+8QWfaw@mail.gmail.com>
Subject: Re: [PATCH 3/3] usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
From: Fabio Estevam <festevam@gmail.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Fri, Nov 29, 2013 at 12:08 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:
> hw_phymode_configure configures the PORTSC registers and allow the
> following phy_inits to operate on the right parameters. This fix a problem
> where the UPLI (ISP1504) could not detected, because the Viewport was not
> available and returns 0's only.
>
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>

I have already fixed this issue. It is in mainline now:

commit 03779f05be6dfc48de99763f6c845a003e1e40f3
Author: Fabio Estevam <fabio.estevam@freescale.com>
Date:   Wed Aug 14 12:43:56 2013 +0300

    usb: chipidea: move hw_phymode_configure() into probe

    Currently hw_phymode_configure() is located inside hw_device_reset(), which
    only called by chipidea udc driver.

    When operating in host mode, we also need to call hw_phymode_configure() in
    order to properly configure the PHY mode, so move this function into probe.

    After this change, USB Host1 port on mx53qsb board is functional.

    Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
    Tested-by: Arnaud Patard <arnaud.patard@rtp-net.org>
    Reviewed-by: Peter Chen <peter.chen@freescale.com>
    Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Regards,

Fabio Estevam
