Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaAMQNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:13:48 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35759 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752997AbaAMQNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:13:42 -0500
Date: Mon, 13 Jan 2014 16:13:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 15/28] drm/i2c: tda998x: use the tda998x video
	format when cea mode
Message-ID: <20140113161333.GA15937@n2100.arm.linux.org.uk>
References: <20140109120448.24d89eba@armhf> <20140111181832.GD15937@n2100.arm.linux.org.uk> <20140113170707.10b908dc@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113170707.10b908dc@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:07:07PM +0100, Jean-Francois Moine wrote:
> On Sat, 11 Jan 2014 18:18:32 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Thu, Jan 09, 2014 at 12:04:48PM +0100, Jean-Francois Moine wrote:
> > > This patch uses the tda998x video format tied to the CEA mode.
> > > This reduces the number of i2c exchanges.
> > 
> > It is my understanding that one of the major design goals of this driver
> > is to avoid the use of such a table, and therefore this change is
> > undesirable by the original driver authors.  This is more a comment for
> > Rob to pick up on.
> 
> I retrieved a message from Rabeeh who got this description from NXP
> (http://www.solid-run.com/phpbb/viewtopic.php?f=9&t=1205&start=10
>  Thu Mar 28, 2013 10:59 am):
> 
> 1. write register FF of CEC device to &h87.
>                 (68ff = 87h)           -> activate all clock tree inc HDMI ones so you can then use HDMI device
> 2. select page 00 of HDMI device :  write 00 in FF
>                 (e0ff =00h)
> 3. write register A0 of HDMI device to select predefined format :
>                 (e0a0 = 06h)       -> select a predefined 1080p60 format
> 4. write registers A5 and A6 with total number of pixels per line (or greater value)
>                 (e0a5 = 08h)
>                 (e0a6 = 97h) for example
> 5. write register TBG_CTRL1 of HDMI device to select resync method
>                 (e0cb = 7ch)        -> select
> 6. write registers VIP_CTRL to configure RGB input ports :
>                 (e020 = 45h)       -> select VP port configuration
>                 (e021 = 01h)
>                 (e022 = 23h)
> 7. write register VIP_CTRL3 to 20h vto select external SP sync method
>                 (e023 = 20h)

Sorry, I don't see what bearing your response to my reply has.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
