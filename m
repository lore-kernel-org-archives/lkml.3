Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaHBPR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 11:17:29 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33779 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754489AbaHBPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 11:17:27 -0400
Date: Sat, 2 Aug 2014 16:17:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
	dma controller API
Message-ID: <20140802151714.GB30282@n2100.arm.linux.org.uk>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com> <20140730160607.GM8181@intel.com> <20140731074440.GY3952@lukather> <20140731115628.GQ8181@intel.com> <20140731162330.GE3952@lukather> <20140801171306.GF8181@intel.com> <20140802144925.GJ3952@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802144925.GJ3952@lukather>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 04:49:25PM +0200, Maxime Ripard wrote:
> In the case of the call to device_control, especially in the
> DMA_SLAVE_CONFIG case, but that also applies to pause/resume, are the
> changes supposed to be immediates or can they happen later?

pause/resume are expected to operate synchronously on the channel.
When asking for the channel to pause, the channel must be stopped
before the call returns.

In the case of channel configuration, that should have no effect on
any previously queued transfer - in other words, changing the channel
configuration only has an effect when subsequent transactions are
prepared.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
