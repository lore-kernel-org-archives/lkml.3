Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3HRXXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:23:20 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:40136 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3HRXXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <1376509413-1462-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1376509413-1462-6-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 19 Aug 2013 09:23:17 +1000
Message-ID: <CAPM=9txe+PCHR2GViRg71DXf+QDMp9oVG_vMJBURytTUjgepWA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] drm/i2c: tda998x: add video and audio input configuration
From: Dave Airlie <airlied@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 5:43 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> From: Russell King <rmk+kernel@arm.linux.org.uk>
>
> This patch adds tda998x specific parameters to allow it to be configured
> for different boards using it. Also, this implements rudimentary audio
> support for S/PDIF attached controllers.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Darren Etheridge <detheridge@ti.com>
> ---

I've merged the series,

this one generates a warning though:
  CC [M]  drivers/gpu/drm/i2c/tda998x_drv.o
/home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:
In function ‘tda998x_encoder_mode_set’:
/home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:637:11:
warning: ‘clksel_fs’ may be used uninitialized in this function
[-Wmaybe-uninitialized]
/home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:573:30:
note: ‘clksel_fs’ was declared here
/home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:637:11:
warning: ‘clksel_aip’ may be used uninitialized in this function
[-Wmaybe-uninitialized]
/home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:573:18:
note: ‘clksel_aip’ was declared here

It doesn't seem like a real problem, since the function is unlikely to
be called any way to make that case happen.

Dave.
