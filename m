Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab3HRXbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:31:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41922 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3HRXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:31:01 -0400
Date: Mon, 19 Aug 2013 00:29:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] drm/i2c: tda998x: add video and audio input
	configuration
Message-ID: <20130818232936.GQ23006@n2100.arm.linux.org.uk>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376509413-1462-6-git-send-email-sebastian.hesselbarth@gmail.com> <CAPM=9txe+PCHR2GViRg71DXf+QDMp9oVG_vMJBURytTUjgepWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9txe+PCHR2GViRg71DXf+QDMp9oVG_vMJBURytTUjgepWA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:23:17AM +1000, Dave Airlie wrote:
> On Thu, Aug 15, 2013 at 5:43 AM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> >
> > This patch adds tda998x specific parameters to allow it to be configured
> > for different boards using it. Also, this implements rudimentary audio
> > support for S/PDIF attached controllers.
> >
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > Tested-by: Darren Etheridge <detheridge@ti.com>
> > ---
> 
> I've merged the series,

Thanks.

> this one generates a warning though:
>   CC [M]  drivers/gpu/drm/i2c/tda998x_drv.o
> /home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:
> In function ‘tda998x_encoder_mode_set’:
> /home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:637:11:
> warning: ‘clksel_fs’ may be used uninitialized in this function
> [-Wmaybe-uninitialized]
> /home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:573:30:
> note: ‘clksel_fs’ was declared here
> /home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:637:11:
> warning: ‘clksel_aip’ may be used uninitialized in this function
> [-Wmaybe-uninitialized]
> /home/airlied/devel/kernel/drm-next/drivers/gpu/drm/i2c/tda998x_drv.c:573:18:
> note: ‘clksel_aip’ was declared here
> 
> It doesn't seem like a real problem, since the function is unlikely to
> be called any way to make that case happen.

Ok, I'll squash those warnings by a slight rearrangement of the code.
