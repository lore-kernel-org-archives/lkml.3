Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaIWONJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:13:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58147 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751485AbaIWONF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:13:05 -0400
Date: Tue, 23 Sep 2014 16:13:01 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] drm: panel: simple-panel: add bus format
 information for foxlink panel
Message-ID: <20140923161301.54dda63c@bbrezillon>
In-Reply-To: <20140923140612.GB5982@ulmo>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
	<1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
	<20140923140612.GB5982@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Tue, 23 Sep 2014 16:06:13 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Tue, Jul 22, 2014 at 02:23:47PM +0200, Boris BREZILLON wrote:
> > Foxlink's fl500wvr00-a0t supports RGB888 format.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/gpu/drm/panel/panel-simple.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> > index 42fd6d1..f1e49fd 100644
> > --- a/drivers/gpu/drm/panel/panel-simple.c
> > +++ b/drivers/gpu/drm/panel/panel-simple.c
> > @@ -428,6 +428,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
> >  		.width = 108,
> >  		.height = 65,
> >  	},
> > +	.bus_format = VIDEO_BUS_FMT_RGB888_1X24,
> 
> This is really equivalent to .bpc = 8. Didn't you say you had other
> use-cases where .bpc wasn't sufficient?

Yes, the HLCDC support RGB565 where you don't have the same number of
bits for each color (Red and Blue = 5 bits, Green = 6 bits), and thus
can't be encoded in the bpc field.

> 
> Thierry



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
