Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbaCTPTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:19:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32813 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758082AbaCTPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:19:49 -0400
Date: Thu, 20 Mar 2014 15:19:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
	documentation
Message-ID: <20140320151934.GV7528@n2100.arm.linux.org.uk>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr> <532ADFD8.80301@gmail.com> <20140320140156.5d768b1f@armhf> <532AEDE2.3080306@gmail.com> <20140320145221.09252bf6@armhf> <20140320143110.GU7528@n2100.arm.linux.org.uk> <20140320155935.7a474173@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320155935.7a474173@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 03:59:35PM +0100, Jean-Francois Moine wrote:
> On Thu, 20 Mar 2014 14:31:10 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > 1. change the DT compatible strings the driver has to accept both
> >    nxp,tda19988 and nxp,tda19989, and set the appropriate device
> >    in the DT file (tda19988).  I'm a bit nervous about using
> >    "nxp,tda1998x" in case we're clashing with devices with different
> >    characteristics.
> 
> The Cubox is sold with either the TDA19988 or the TDA19989 (I don't
> know about the AMX33XX boards). Then, setting the exact type in the DT
> would ask for 2 differents DTs or for having two tda998x definitions in
> a same DT...

I'm not saying that it has to match the physical device fitted - I'm
merely suggesting not using nxp,tda1998x which could (and as Sebastian
has found, does) conflict with other devices with different properties.

We still auto-detect the exact device type by reading the ID register
because that's the most reliable way to detect exactly what kind of
device is fitted to the board.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
