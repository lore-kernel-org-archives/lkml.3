Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaAVWvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:51:37 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45812 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752985AbaAVWvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:51:35 -0500
Date: Wed, 22 Jan 2014 22:51:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 17/24] drm/i2c: tda998x: get a better status of the
	connection
Message-ID: <20140122225127.GN15937@n2100.arm.linux.org.uk>
References: <cover.1390153344.git.moinejf@free.fr> <20140119195844.202f021b@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119195844.202f021b@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:58:44PM +0100, Jean-Francois Moine wrote:
> This patch refines the connection status testing both bits RXSENS and
> HPD of the CEC register giving the connection level.

Can you explain why this is necessary?

I believe this is not necessary for the following reason:

HDMI cables are required to mate in a certain order:
- First to mate is the shell.
- Second are all pins with the exception of the +5V line.
- Third is the +5V line.

Sinks are not permitted to assert the HPD line until the EDID memory is
ready to be read, and +5V is indicated from the source.

Hence, HPD will not be asserted until the connector is fully mated, and
there are receivers available on the line.

This doesn't indicate whether the sink is powered and able to display
a picture - it merely means that the sink is present and valid EDID is
available to be read.  That's all that we really need here.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
