Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaKRSAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:00:51 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:54071 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaKRSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:00:49 -0500
Date: Tue, 18 Nov 2014 18:00:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drm/i2c: tda998x: Allow for different audio sample rates
Message-ID: <20141118180036.GC4042@n2100.arm.linux.org.uk>
References: <546B8452.6030701@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B8452.6030701@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:39:30PM +0000, Andrew Jackson wrote:
> On HDMI, the audio data are carried across the HDMI link which is
> driven by the TDMS clock. The TDMS clock is dependent on the video pixel
> rate.
> 
> This patch sets the denominator (Cycle Time Stamp) appropriately
> allowing the driver to send audio to a wider range of HDMI sinks
> (i.e. monitors).

This is actually pointless, because we don't use "manual" CTS mode.

If the clocks for the video and audio are coherent, then you can program
both the N and CTS values to allow the sink to properly recover the
synchronous audio clock.

However, in most cases, the audio and video clocks are not coherent, and
since the recovered audio clock has to match the source audio clock, the
only way this can be done is by the TDA998x (or in fact other HDMI
encoder) to measure the audio clock rate and generate the CTS value
itself.

This is the mode we drive the TDA998x - so the programmed CTS value is
irrelevant.

See the HDMI spec, section 7.2 for a discussion about this, especially
non-coherent clocks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
