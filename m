Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3DWRo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:44:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:28811 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab3DWRo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,536,1363158000"; 
   d="scan'208";a="323692600"
Message-ID: <51465.163.33.213.85.1366739082.squirrel@linux.intel.com>
In-Reply-To: <20130423163543.GB3228@the-dreams.de>
References: <alpine.DEB.2.02.1304191859570.17829@localhost>
    <20130422071943.GK1283@intel.com>
    <53398.163.33.213.79.1366630241.squirrel@linux.intel.com>
    <20130422122808.GO1283@intel.com>
    <alpine.DEB.2.02.1304221508050.31571@localhost>
    <20130423163543.GB3228@the-dreams.de>
Date: Tue, 23 Apr 2013 10:44:42 -0700 (PDT)
Subject: Re: [PATCH] i2c-designware: fix RX FIFO overrun
From: "Josef Ahmad" <josef.ahmad@linux.intel.com>
To: "Wolfram Sang" <wsa@the-dreams.de>
Cc: "Josef Ahmad" <josef.ahmad@linux.intel.com>,
        "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Ben Dooks" <ben-linux@fluff.org>, "Jean Delvare" <khali@linux-fr.org>,
        "Stefan Roese" <sr@denx.de>, "Axel Lin" <axel.lin@gmail.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dirk Brandewie" <dirk.brandewie@gmail.com>
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 22, 2013 at 03:08:59PM +0100, Josef Ahmad wrote:
>> From a969728248c3b439dc97a69e7dac133b5efa34e7 Mon Sep 17 00:00:00 2001
>> From: Josef Ahmad <josef.ahmad@linux.intel.com>
>> Date: Fri, 19 Apr 2013 17:28:10 +0100
>> Subject: [PATCH] i2c-designware: fix RX FIFO overrun
>>
>> i2c_dw_xfer_msg() pushes a number of bytes to transmit/receive
>> to/from the bus into the TX FIFO.
>> For master-rx transactions, the maximum amount of data that can be
>> received is calculated depending solely on TX and RX FIFO load.
>>
>> This is racy - TX FIFO may contain master-rx data yet to be
>> processed, which will eventually land into the RX FIFO. This
>> data is not taken into account and the function may request more
>> data than the controller is actually capable of storing.
>>
>> This patch ensures the driver takes into account the outstanding
>> master-rx data in TX FIFO to prevent RX FIFO overrun.
>>
>> Signed-off-by: Josef Ahmad <josef.ahmad@linux.intel.com>
>> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> This driver had a major cleanup meanwhile. Could you rebase your patch
> on top of my for-next branch? I guess this version should make it into
> stable?
>

Hi Wolfram

This patch applies just fine on top of your i2c-embedded/for-next branch.

