Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaAKSgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:36:55 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34545 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753841AbaAKSgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:36:53 -0500
Date: Sat, 11 Jan 2014 18:36:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/28] drm/i2c: tda998x: move the TBG_CNTRL_0
	register setting
Message-ID: <20140111183648.GH15937@n2100.arm.linux.org.uk>
References: <20140109120607.6a33bee5@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120607.6a33bee5@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:06:07PM +0100, Jean-Francois Moine wrote:
> According to the comment, the TBG_CNTRL_0 register must be set at the
> end of the mode change sequence.

So you believe comments without understanding the history, and you move
code around due to those.

No, this is again wrong.  That write to REG_TBG_CNTRL_0 in the sequence
writing the video information to the chip.  This doesn't encompass the
HDMI/DVI mode setting nor the audio configuration - the audio configuration
can change independently of the video setting, and does not require this
register to be written.

This also brings up a bug in one of your previous patches which I now
must go back and comment upon.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
