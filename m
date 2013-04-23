Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3DWQgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:36:00 -0400
Received: from sauhun.de ([89.238.76.85]:34628 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab3DWQf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:35:58 -0400
Date: Tue, 23 Apr 2013 18:35:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Josef Ahmad <josef.ahmad@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        Stefan Roese <sr@denx.de>, Axel Lin <axel.lin@gmail.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
Message-ID: <20130423163543.GB3228@the-dreams.de>
References: <alpine.DEB.2.02.1304191859570.17829@localhost>
 <20130422071943.GK1283@intel.com>
 <53398.163.33.213.79.1366630241.squirrel@linux.intel.com>
 <20130422122808.GO1283@intel.com>
 <alpine.DEB.2.02.1304221508050.31571@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304221508050.31571@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 03:08:59PM +0100, Josef Ahmad wrote:
> From a969728248c3b439dc97a69e7dac133b5efa34e7 Mon Sep 17 00:00:00 2001
> From: Josef Ahmad <josef.ahmad@linux.intel.com>
> Date: Fri, 19 Apr 2013 17:28:10 +0100
> Subject: [PATCH] i2c-designware: fix RX FIFO overrun
> 
> i2c_dw_xfer_msg() pushes a number of bytes to transmit/receive
> to/from the bus into the TX FIFO.
> For master-rx transactions, the maximum amount of data that can be
> received is calculated depending solely on TX and RX FIFO load.
> 
> This is racy - TX FIFO may contain master-rx data yet to be
> processed, which will eventually land into the RX FIFO. This
> data is not taken into account and the function may request more
> data than the controller is actually capable of storing.
> 
> This patch ensures the driver takes into account the outstanding
> master-rx data in TX FIFO to prevent RX FIFO overrun.
> 
> Signed-off-by: Josef Ahmad <josef.ahmad@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

This driver had a major cleanup meanwhile. Could you rebase your patch
on top of my for-next branch? I guess this version should make it into
stable?

