Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3H1OjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:39:13 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:57454 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3H1OjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130828052758.GQ30088@pengutronix.de>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
	<20130828052758.GQ30088@pengutronix.de>
Date: Wed, 28 Aug 2013 11:39:11 -0300
Message-ID: <CAOMZO5BiE7tqja9p51gOGEwtWsKjyX23qZ3=ewyuubMwsgXcLA@mail.gmail.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 2:27 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Nack. We need the references to prevent that encoders/connectors are
> (de)registered while the device is active. Simply dropping this code is
> no solution.

Any suggestions about a proper way of handling this?

After b5dc0d10, imx_drm_device_get() is called from
imx_drm_driver_load(), which increments the 'references' very early
now.

Then when we check:

    if (imxdrm->references) {
        ret = -EBUSY;
        goto err_busy;
    }

,it will fail always.

Not sure where is a proper location to increment/decrement
'imxdrm->references' though.

Tried to look at other drm drivers, but could not find examples on how
to deal with such references.

Regards,

Fabio Estevam
